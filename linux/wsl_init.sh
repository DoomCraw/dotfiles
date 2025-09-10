# ADD REPOS AND INSTALL PACKAGES
source /etc/os-release

# Docker CE
curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
tee /etc/apt/sources.list.d/docker.list << EOF > /dev/null
deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable
EOF

# Hashicorp
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /etc/apt/keyrings/hashicorp.gpg
tee /etc/apt/sources.list.d/hashicorp.list << EOF > /dev/null
deb [signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com ${VERSION_CODENAME} main
EOF

# NodeJS
curl -fsSL https://deb.nodesource.com/setup_20.x | /bin/bash -

# Pritunl
curl -fsSL https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc | gpg --dearmor -o /etc/apt/keyrings/pritunl.gpg
tee /etc/apt/sources.list.d/pritunl.list << EOF > /dev/null
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/pritunl.gpg] http://repo.pritunl.com/stable/apt ${VERSION_CODENAME} main
EOF

# Tailscale
curl -fsSL https://pkgs.tailscale.com/stable/${ID}/${VERSION_CODENAME}.noarmor.gpg | tee /etc/apt/keyrings/tailscale.gpg > /dev/null
curl -fsSL https://pkgs.tailscale.com/stable/${ID}/${VERSION_CODENAME}.tailscale-keyring.list | sed s,\/usr\/share,\/etc\/apt,g | sed s,tailscale-archive-keyring,tailscale,g | tee /etc/apt/sources.list.d/tailscale.list > /dev/null

apt update -y && \
apt install -y apt-transport-https \
               atop \
               bash-completion \
               ca-certificates \
               ca-certificates \
               cpio \
               curl \
               fonts-powerline \
               fzf \
               git \
               gnupg \
               gzip \
               htop \
               inetutils-traceroute \
               iperf3 \
               jq \
               jsonnet \
               logrotate \
               libguestfs-tools \
               make \
               netcat-openbsd \
               nodejs \
               openjdk-17-jdk \
               openjdk-17-jre \
               openssh-client \
               openssh-server \
               openssl \
               pritunl-client \
               python3 \
               python3-dev \
               python3-pip \
               python3-setuptools \
               python3-venv \
               python3-virtualenv \
               rsync \
               rsyslog \
               sshpass \
               socat \
               sysstat \
               systemd \
               tailscale \
               tar \
               tcpdump \
               terraform \
               terraform-ls \
               tmux \
               unzip \
               vim \
               wget \
               xclip \
               xorriso \
               zip
# Docker CE
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Tflint (terraform linter)
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | /bin/bash -

# Install Helix Editor
# curl -fsSLO https://github.com/helix-editor/helix/releases/download/25.01.1/helix-25.01.1-x86_64-linux.tar.xz
# tar -xJf helix-25.01.1-x86_64-linux.tar.xz
# cp -r helix-25.01.1-x86_64-linux/runtime .config/helix
# cp helix-25.01.1-x86_64-linux/hx /usr/local/bin/hx
# chmod 755 /usr/local/bin/hx
# rm helix-25.01.1-x86_64-linux.tar.xz

# Npiperelay to forward SSH_AGENT_SOCK
npiperelaypath=$(wslpath "C:/npiperelay")
[ -d $npiperelaypath ] && rm -rf $npiperelaypath
wget https://github.com/jstarks/npiperelay/releases/latest/download/npiperelay_windows_amd64.zip
unzip npiperelay_windows_amd64.zip -d $npiperelaypath
rm -f npiperelay_windows_amd64.zip

# AWS CLI v2
curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
unzip awscliv2.zip
./aws/install
rm -rf ./aws ./awscliv2.zip

# ADD CONFIGS

tee /root/.vimrc << EOF > /dev/null
set number
colorscheme torte
EOF

tee -a /root/.bashrc << EOF > /dev/null

export EDITOR=vim
EOF

tee -a /etc/systemd/resolved.conf << EOF > /dev/null

DNS=10.1.2.32 8.8.8.8 
FallbackDNS=8.8.4.4
Domains=ascalon.ae devs.ae devs.local sdc.local
DNSSEC=yes
EOF

tee /etc/wsl.conf << EOF > /dev/null
[user]
default=${WSLUSER}

[automount]
enabled=true
mountFsTab=false
root=/mnt
options="metadata,umask=22,fmask=11"

[network]
generateHosts=false
generateResolvConf=false

[boot]
systemd=true
EOF

tee /etc/sudoers.d/$(echo $WSLUSER | sed 's/\./_/g') << EOF > /dev/null
${WSLUSER}   ALL=(ALL:ALL) NOPASSWD:ALL
EOF

chmod 440 /etc/sudoers.d/$(echo $WSLUSER | sed 's/\./_/g')

pritunl-client completion bash > /etc/bash_completion.d/pritunl-client-completion.sh

# password="$(echo <secret> | openssl passwd -6 -stdin)"
#useradd -m -d /home/${WSLUSER} -U -G docker -s /bin/bash -p "${password}" ${WSLUSER}
# useradd -d $(wslpath ${Env:USERPROFILE}) -U -G docker -s /bin/bash ${WSLUSER}
useradd -m -U -G docker -s /bin/bash ${WSLUSER}

sudo -H -u ${WSLUSER} /bin/bash << EOF
cd ~

git config --global user.name valeriy.z
git config --global user.mail valeriy.z@devs.ae
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"

git clone https://github.com/DoomCraw/dotfiles.git .dotfiles

/bin/bash .dotfiles/linux/bootstrap.sh

ln -s ${GIT_FOLDER} git

exit 0
EOF

cat << EOT > /home/${WSLUSER}/post-install.sh
sudo tailscale up \
    --login-server https://headscale.devs.ae \
    --auth-key ${TAILSCALE_AUTH_KEY} \
    --reset \
    --timeout 10s \
    --accept-routes=false \
    --accept-dns=false

sudo systemctl disable --now systemd-resolved.service
sudo systemctl mask systemd-resolved.service
sudo rm -f /etc/resolv.conf
sudo tee /etc/resolv.conf << EOF > /dev/null
# nameserver 10.1.2.32
nameserver 8.8.8.8
search ascalon.ae devs.ae devs.local sdc.local
EOF

rm -f \$0

exit 0
EOT

chown ${WSLUSER}:${WSLUSER} /home/${WSLUSER}/post-install.sh

exit 0
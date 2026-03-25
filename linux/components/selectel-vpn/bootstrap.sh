#!/bin/bash


export TAILSCALE_LOGIN_SERVER='https://headscale.devs.ae'
export TAILSCALE_AUTH_KEY='ef5c505f6e132c90de90d2d87adc5f3d2b742d04c3aeb547'
export PRITUNL_PROFILE='https://uae-1.vpn.devs.ae/k/2QT8oreh'


export DEBIAN_FRONTEND=noninteractive


# Update/upgrade
apt update -y && \
    apt dist-upgrade \
        -o "Dpkg::Options::=--force-confold" \
        -o "Dpkg::Options::=--force-confdef" \
        -y \
        --allow-downgrades \
        --allow-remove-essential \
        --allow-change-held-packages


# Install tools
apt install -y htop \
               atop \
               curl \
               wget \
               netcat-openbsd \
               iperf3 \
               dnsutils \
               gnupg \
               jq


# Install tailscale client
curl -fsSL https://tailscale.com/install.sh | /bin/sh -

# Install pritunl-client
tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt noble main
EOF

gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A && \
    gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | \
        tee /etc/apt/trusted.gpg.d/pritunl.asc
apt update -y && \
    apt install -y pritunl-client


# SSH config
cat << EOF > /etc/ssh/sshd_config
# Authentication
PermitRootLogin yes
PasswordAuthentication no
PermitEmptyPasswords no
PubkeyAuthentication yes
ChallengeResponseAuthentication no
KbdInteractiveAuthentication no
UsePAM yes

#KeepAlive
ClientAliveCountMax 5
ClientAliveInterval 120
TCPKeepAlive no

# Other
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem       sftp    /usr/lib/openssh/sftp-server
EOF


# Systemd services
pushd /etc/systemd/system

for service in ssh.service.d pritunl-client.service.d tailscaled.service.d; do 
    mkdir ${service}
    cat << EOF > ${service}/override.conf
[Service]
IOSchedulingClass=2
IOSchedulingPriority=4
Nice=-15
OOMScoreAdjust=-600
EOF
done

popd

systemctl daemon-reload && \
    systemctl restart ssh.service

systemctl disable --now iperf3


# Connect

tailscale up \
    --login-server "${TAILSCALE_LOGIN_SERVER}" \
    --auth-key "${TAILSCALE_AUTH_KEY}" \
    --reset \
    --timeout 30s \
    --accept-dns=false \
    --accept-routes=false \
    --hostname "${HOSTNAME}"


pritunl-client add "${PRITUNL_PROFILE}"
sleep 2
pritunl_account_id=$(pritunl-client list -f  | jq -crM '.[].id')
pritunl-client enable ${pritunl_account_id} && \
    pritunl-client start ${pritunl_account_id}


# Resolving

systemctl disable --now systemd-resolved.service && \
    systemctl mask systemd-resolved.service

rm -f /etc/resolv.conf

cat << EOF > /etc/resolv.conf
nameserver 10.1.2.32
nameserver 1.1.1.1
nameserver 8.8.8.8
search ascalon.ae rasd.ae devs.ae devs.local rasd.local 
EOF

exit 0
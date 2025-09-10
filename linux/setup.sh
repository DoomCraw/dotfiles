#!/bin/bash


set -eu


source /etc/os-release


DEFAULT_COMPONENTS="+awscli;+docker;+nodejs;+tailscale;+terraform;+tflint"
COMPONENTS=${1:-"${DEFAULT_COMPONENTS}"}
COMPONENTS="+common;${COMPONENTS}"


install_awscli () {
    curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
    unzip awscliv2.zip
    ./aws/install
    rm -rf ./aws ./awscliv2.zip
}


install_common () {
    apt update -y && \
        apt install -y \
            apt-transport-https \
            atop \
            bash-completion \
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
            openssh-client \
            openssl \
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
            tar \
            tcpdump \
            tmux \
            unzip \
            vim \
            wget \
            xclip \
            xorriso \
            zip
}


install_docker () {
    curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | \
        gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt update -y && \
        apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    usermod -aG docker $(whoami)
}


install_nodejs () {
    curl -fsSL https://deb.nodesource.com/setup_22.x | /bin/bash -

    apt update -y && \
        apt install -y nodejs
}


install_npiperelay () {
    local npiperelay_path=$(wslpath "C:/npiperelay")
    
    [ -d $npiperelay_path ] && rm -rf $npiperelay_path
    curl -fsSL https://github.com/jstarks/npiperelay/releases/latest/download/npiperelay_windows_amd64.zip \
        -o npiperelay_windows_amd64.zip
    unzip ./npiperelay_windows_amd64.zip -d $npiperelay_path
    rm -f ./npiperelay_windows_amd64.zip

    unset npiperelay_path
}


install_pritunl () {
    curl -fsSL https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc | \
        gpg --dearmor -o /etc/apt/keyrings/pritunl.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/pritunl.gpg] http://repo.pritunl.com/stable/apt ${VERSION_CODENAME} main" | \
        tee /etc/apt/sources.list.d/pritunl.list > /dev/null

    apt update -y && \
        apt install -y pritunl-client

    pritunl-client completion bash | tee /etc/bash_completion.d/pritunl-client > /dev/null
}


install_tailscale () {
    curl -fsSL https://pkgs.tailscale.com/stable/${ID}/${VERSION_CODENAME}.noarmor.gpg | \
        tee /etc/apt/keyrings/tailscale.gpg > /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/tailscale.gpg] https://pkgs.tailscale.com/stable/${ID} ${VERSION_CODENAME} main" | \
        tee /etc/apt/sources.list.d/tailscale.list > /dev/null

    apt update -y && \
        apt install -y tailscale

    tailscale completion bash | tee /etc/bash_completion.d/tailscale > /dev/null
}


install_terraform () {
    curl -fsSL https://apt.releases.hashicorp.com/gpg | \
        gpg --dearmor -o /etc/apt/keyrings/hashicorp.gpg
    echo "deb [signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com ${VERSION_CODENAME} main" | \
        tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

    apt update -y && \
        apt install -y terraform terraform-ls
}


install_tflint () {
    curl -fsSL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | \
        /bin/bash -
}


install_component () {
    local component=$1

    case "${component}" in
        "awscli") install_awscli ;;
        "common") install_common ;;
        "docker") install_docker ;;
        "nodejs") install_nodejs ;;
        "npiperelay") install_npiperelay ;;
        "pritunl") install_pritunl ;;
        "tailscale") install_tailscale ;;
        "terraform") install_terraform ;;
        "tflint") install_tflint ;;
    esac

    unset component
}


IFS=";"
for component in ${COMPONENTS}; do
    if [[ $component =~ ^\+ ]]; then
        install_component $component
    fi
done


# Environment dependent components

test -n "${WSL_DISTRO_NAME}" && install_component "npiperelay"


# Dotfiles

dotfiles_dir="${HOME}/.dotfiles"
git clone -q https://github.com/DoomCraw/dotfiles "${dotfiles_dir}"

pushd "${dotfiles_dir}/linux"

. ./bootstrap.sh
. ./components/ansible-venv/bootstrap.sh

popd


exit 0
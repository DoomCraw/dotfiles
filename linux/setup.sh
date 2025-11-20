#!/bin/bash


set -eu

export DEBIAN_FRONTEND=noninteractive
REPO="https://github.com/DoomCraw/dotfiles"

source /etc/os-release


get_dotfiles () {
    if [[ -n "${SUDO_USER}" ]]; then
        sudo -H -u $SUDO_USER \
            /bin/bash -c "test -d ~/.dotfiles || git clone ${REPO} ~/.dotfiles"
    else
        test -d ~/.dotfiles || git clone ${REPO} ~/.dotfiles
    fi
}


install_ansible () {
    get_dotfiles
    if [[ -n "${SUDO_USER}" ]]; then
        sudo -H -u $SUDO_USER \
            /bin/bash -c 'source ~/.dotfiles/linux/components/ansible/bootstrap.sh'
    else
        source ~/.dotfiles/linux/components/ansible/bootstrap.sh
    fi
}


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
            eza \
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

    usermod -aG docker ${SUDO_USER}
    systemctl enable --now docker.service docker.socket containerd.service
}


install_dotfiles () {
    get_dotfiles
    if [[ -n "${SUDO_USER}" ]]; then
        sudo -H -u $SUDO_USER \
            /bin/bash -c 'source ~/.dotfiles/linux/bootstrap.sh'
    else
        source ~/.dotfiles/linux/bootstrap.sh
    fi
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


install_starship () {
    curl -fsSL https://starship.rs/install.sh | /bin/sh -s -- -y
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
        "ansible") install_ansible ;;
        "awscli") install_awscli ;;
        "common") install_common ;;
        "docker") install_docker ;;
        "dotfiles") install_dotfiles ;;
        "nodejs") install_nodejs ;;
        "npiperelay") install_npiperelay ;;
        "pritunl") install_pritunl ;;
        "starship") install_starship ;;
        "tailscale") install_tailscale ;;
        "terraform") install_terraform ;;
        "tflint") install_tflint ;;
    esac

    unset component
}


upgrade_os () {
    apt update -y && \
        apt dist-upgrade \
            -o "Dpkg::Options::=--force-confold" \
            -o "Dpkg::Options::=--force-confdef" \
            -y \
            --allow-downgrades \
            --allow-remove-essential \
            --allow-change-held-packages
}


if [[ "$(uname -s)" == *"MINGW"* ]]; then
    exit 0
elif [[ "$(uname -r)" == *"WSL"* ]]; then
    COMPONENTS=${COMPONENTS:-"common;ansible;awscli;nodejs;dotfiles;npiperelay;starship;terraform;tflint"}
elif [[ "${NAME}" == "Linux Mint" ]]; then
    COMPONENTS=${COMPONENTS:-"common;ansible;awscli;docker;nodejs;dotfiles;pritunl;starship;tailscale;terraform;tflint"}
fi

upgrade_os

IFS=";"
for component in ${COMPONENTS}; do
    install_component $component
done


exit 0
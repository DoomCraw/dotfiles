#!/bin/bash

set -eu

WSLUSER=${$1:-"wsluser"}

apt update -y && \
    apt dist-upgrade -y

if ! command -v curl > /dev/null; then
    apt install -y curl
fi

useradd -m -U -G sudo -s /bin/bash ${WSLUSER}

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

chmod 644 /etc/wsl.conf && \
    chown root:root /etc/wsl.conf

SUDOERS_FILE=$(echo $WSLUSER | sed 's/\./_/g')

tee /etc/sudoers.d/${SUDOERS_FILE} << EOF > /dev/null
${WSLUSER}   ALL=(ALL:ALL) NOPASSWD:ALL
EOF

chmod 440 /etc/sudoers.d/${SUDOERS_FILE} && \
    chown root:root /etc/sudoers.d/${SUDOERS_FILE}

exit 0
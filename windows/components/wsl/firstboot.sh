#!/bin/bash


set -eu


WSLUSER=${1:-"wsluser"}
WSLHOSTNAME=${2:-"wslhostname"}


useradd -m -U -G sudo -s /bin/bash ${WSLUSER}

SUDOERS_FILE=$(echo $WSLUSER | sed 's/\./_/g')

tee /etc/sudoers.d/${SUDOERS_FILE} << EOF > /dev/null
${WSLUSER}   ALL=(ALL:ALL) NOPASSWD:ALL
EOF

chmod 440 /etc/sudoers.d/${SUDOERS_FILE} && \
    chown root:root /etc/sudoers.d/${SUDOERS_FILE}

tee /etc/wsl.conf << EOF > /dev/null
[boot]
systemd=false

[network]
hostname=${WSLHOSTNAME}
generateHosts=false
generateResolvConf=true

[user]
default=${WSLUSER}

[automount]
enabled=true
mountFsTab=false
root=/mnt
options="metadata,umask=22,fmask=11"
EOF

chmod 644 /etc/wsl.conf && \
    chown root:root /etc/wsl.conf


exit 0
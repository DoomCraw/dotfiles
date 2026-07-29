#!/bin/bash


set -eu


WSLUSER=${1:-"wsluser"}
WSLHOSTNAME=${2:-"wslhostname"}


useradd -m -U -G sudo -s /bin/bash ${WSLUSER}

SUDOERS_FILE=$(echo $WSLUSER | sed 's/\./_/g')

cat > /etc/sudoers.d/${SUDOERS_FILE} << EOF
${WSLUSER}   ALL=(ALL:ALL) NOPASSWD:ALL
EOF

chmod 440 /etc/sudoers.d/${SUDOERS_FILE} && \
    chown root:root /etc/sudoers.d/${SUDOERS_FILE}

wsl_conf=/etc/wsl.conf
cat > $wsl_conf << EOF
[boot]
systemd=false

[network]
hostname=${WSLHOSTNAME}
generateHosts=false
generateResolvConf=false

[user]
default=${WSLUSER}

[automount]
enabled=true
mountFsTab=false
root=/mnt
options="metadata,umask=22,fmask=11"
EOF

chmod 644 $wsl_conf && \
    chown root:root $wsl_conf

resolv_conf=/etc/resolv.conf

test -h $resolv_conf && \
    rm -f $resolv_conf

cat > $resolv_conf << EOF
nameserver 9.9.9.9
nameserver 1.1.1.1
EOF

chmod 644 $resolv_conf && \
    chown root:root $resolv_conf


exit 0
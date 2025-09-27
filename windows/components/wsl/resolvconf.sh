#!/bin/bash

set -eu

systemctl disable --now systemd-resolved && \
    systemctl mask systemd-resolved

rm -f /etc/resolv.conf

echo 'nameserver 8.8.8.8' | tee /etc/resolv.conf > /dev/null

exit 0
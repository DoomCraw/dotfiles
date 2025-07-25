#!/bin/bash

set -eu

apt install -y ${packages[@]}

for component in ${components[@]}; do
    case "${component}" in
        docker) install_docker ;;
        aws) install_aws ;;
        tailscale) install_tailscale ;;
        pritunl) install_pritunl ;;
        powershell) install_powershell ;;
    esac
done

exit 0
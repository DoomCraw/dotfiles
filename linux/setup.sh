#!/bin/bash

set -eu

packages=()
cmds=""

install_docker() {
  packages=(${packages[@]} docker-ce containerio docker-compose)
  cmds=$(
    cat <<EOF
    ${cmds}
    usermod -aG docker ${USER}
EOF
  )
}

for component in ${components[@]}; do
  case "${component}" in
  docker) packages=$(install_docker) ;;
  aws) install_aws ;;
  tailscale) install_tailscale ;;
  pritunl) install_pritunl ;;
  powershell) install_powershell ;;
  esac
done

apt install -y ${packages[@]}

eval "${cmds}"

exit 0

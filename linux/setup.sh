#!/bin/bash
# eza instead ls
set -eu

packages=()
cmds=""

install_bin () {
  url=$1
  binary=$2
  filename=$(echo $url | awk -F'/' '{print $NF}')

  pushd /tmp

  curl -fsSL $url -o $filename
  tar -xzf $filename
  install -o root -g root -m 755 $binary /usr/local/bin/$binary

  rm -f $filename $binary

  popd

  unset url binary filename
}

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
  terraform) install_powershell ;;
  npiperelay) install_powershell ;;
  esac
done

apt install -y ${packages[@]}

eval "${cmds}"

install_bin 'https://github.com/junegunn/fzf/releases/download/v0.65.0/fzf-0.65.0-linux_amd64.tar.gz' fzf

./deps/.ansible-venv/bootstrap.sh

exit 0

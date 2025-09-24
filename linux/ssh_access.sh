#!/bin/bash

is_user_exists() {
  if getent passwd "${1}" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

is_docker_group_exists() {
  if getent groups docker >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

get_sudo_group() {
  if getent groups sudo >/dev/null 2>&1; then
    echo "sudo"
  elif getent groups wheel >/dev/null 2>&1; then
    echo "wheel"
  fi
}

USER_GROUPS="$(get_sudo_group)"

if is_docker_group_exists; then
  USER_GROUPS="${USER_GROUPS},docker"
fi

if ! is_user_exists "${USERNAME}"; then
  sudo useradd -m -U -G $USER_GROUPS -s /bin/bash $USERNAME
fi

if ! sudo /bin/bash -c 'echo $(whoami)' >/dev/null 2>&1; then
  pushd /etc/sudoers.d
  sudoers_file=$(echo ${USERNAME} | sed "s,\.,\_,g")
  echo "" >${sudoers_file}
  chmod 440 ${sudoers_file}
  chown root:root ${sudoers_file}
fi

pushd /home/${USERNAME}

if [[ ! -d .ssh ]]; then
  mkdir .ssh
fi

cat <<EOF >.ssh/authorized_keys
${SSH_PUBKEY}
EOF

chmod 0700 .ssh
chmod 600 .ssh/authorized_keys
chown ${USERNAME}:${USERNAME} -R .ssh

# BASH PROFILE

if nc -zw3 github.com 443; then
  curl -fsSL https://${GIT_USER}:${GIT_PASS}@github.com/${GIT_REPO}/${GIT_PATH} | /bin/bash -
else
  script=$(mktemp)
  cat - >$script
  /bin/bash $script
  rm -f $script
fi

exit 0

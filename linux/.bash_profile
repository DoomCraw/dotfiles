#.bash_profile

if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
elif [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

# FUNCTIONS 

_ansible_add_new_role () {
    local role_name=${1:-new_role}

    if [ -d ./roles/${role_name} ]; then
      echo 'Role already exists' # TODO change to "error" function
      exit 1
    fi
  
    mkdir -p ./roles/${role_name}

    for folder in tasks handlers files templates defaults vars meta; do
        mkdir -p ./roles/${role_name}/${folder}
        case "${folder}" in
            tasks|handlers|defaults|meta) echo -e "---\n" >> ./roles/${role_name}/${folder}/main.yaml ;;
        esac
    done

    unset role_name
}

_ansible_playbook () {
    source $HOME/ansible/bin/activate
    ansible-playbook $@
    deactivate
}

_ssh_tunnels () {
    ps axu | grep -i ssh | grep -Evi 'grep|ssh-agent'
}

_stop_ssh_tunnels () {
    _ssh_tunnels | awk -F" " '{print $2}' | xargs -I {} /bin/kill {}
}

init_ssh_agent () {
    if [ -f ~/.agent.env ]; then
        . ~/.agent.env > /dev/null
        if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
            echo "Stale agent file found. Spawning new agent… "
            eval $(ssh-agent | tee ~/.agent.env)
        fi 
    else
        echo "Starting ssh-agent"
        eval $(ssh-agent | tee ~/.agent.env)
    fi

    if ! ssh-add -L > /dev/null; then
        ssh-add -t 605000 ${HOME}/.ssh/vzaytsev_devs.pem.key
        ssh-add -t 605000 ${HOME}/.ssh/LinuxServersDefault.pem
        # find .ssh/ -type f ! -name *.pub ! -name *config* ! -name *known_hosts* | \
        #   while read key; do
        #     ssh-add -t 605000 ${HOME}/${key} > /dev/null 2>&1;
        #   done
    fi
}

# ALIASES

alias ansible_add_new_role='_ansible_add_new_role'
alias ansible-playbook='_ansible_playbook $@'
alias check_port='netcat -vzw3'
alias ssh_tunnels='_ssh_tunnels'
alias stop_ssh_tunnels='_stop_ssh_tunnels'
alias tmux='tmux attach -t 0 || tmux'
alias ssh='ssh -o StrictHostKeyChecking=no'
alias s='ls -l'
alias cls='clear'
alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'

# EXPORT ENVIRONMENT VARS

export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
export TAILSCALE_GATEWAY_SERVER=100.64.0.18
export EDITOR=vim
export TERM='xterm-256color'
# export PS1="\[\e[32m\][\[\e[m\]\[\e[1;91m\]\u\[\e[m\]\[\e[1;96m\]@\[\e[m\]\[\e[92m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]\[\e[32;98m\]\nλ\[\e[m\] "
export PS1="\[\e[36m\]\w\[\e[m\]\[\e[32m\]\[\e[m\]\[\e[32;98m\]\nλ\[\e[m\] "
export PROMPT_COMMAND="echo"
# export ANSIBLE_VAULT_PASSWORD=$(/usr/bin/keepassxc-cli show -sa Password /mnt/d/yandex_disk/JobSecrets.kdbx ANSIBLE_VAULT_PASSWORD)
# read -rsp 'Enter ansible vault password: ' ANSIBLE_VAULT_PASSWORD
# export ANSIBLE_VAULT_PASSWORD=${ANSIBLE_VAULT_PASSWORD}

# MAIN

cd $HOME

complete -C '/usr/local/bin/aws_completer' aws
complete -C /usr/bin/terraform terraform

if [ ! -f ~/.dircolors ]; then
    dircolors --print-database > ~/.dircolors
fi

eval $(dircolors ~/.dircolors)

# Initialize ssh-agent with keys
# init_ssh_agent
ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
    rm -f $SSH_AUTH_SOCK
    npiperelaypath=$(wslpath "C:/npiperelay")
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$npiperelaypath/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi

# Create SSH tunnels to ESXi
if ! ps axu | grep -Pq 'ssh.+127.0.0.1:\d{1}443'; then
    ssh -o ControlMaster=no -f -p 22 -N -C -L 127.0.0.1:1443:10.18.42.43:443 $TAILSCALE_GATEWAY_SERVER
    ssh -o ControlMaster=no -f -p 22 -N -C -L 127.0.0.1:2443:10.18.42.44:443 $TAILSCALE_GATEWAY_SERVER
fi

# Start tmux
if [ -z $TMUX ]; then
    tmux
fi

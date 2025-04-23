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
    source $ANSIBLE_VENV_PATH/bin/activate
    ansible-playbook $@
    deactivate
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
        for pubkey in $@; do
            ssh-add -t 605000 $pubkey
        done
    fi
}

_list_ssh_tunnels () {
    ps axu | grep -i 'ssh' | grep -Evi 'grep|ssh-agent'
}

_down_ssh_tunnels () {
    _list_ssh_tunnels | awk -F" " '{print $2}' | xargs -I {} /bin/kill {}
}

_up_ssh_tunnels () {
    local ssh_proxy_cmd="ssh -o StrictHostKeyChecking=no \
                             -o ControlMaster=no \
                             -o ServerAliveInterval=60 \
                             -o ExitOnForwardFailure=yes \
                             -p 22 \
                             -nfCNT"

    ${ssh_proxy_cmd} -L 127.0.0.1:4444:10.18.42.1:4444 ${SSH_PROXY}
    ${ssh_proxy_cmd} -L 127.0.0.1:5443:10.18.42.29:443 ${SSH_PROXY}
    ${ssh_proxy_cmd} -L 127.0.0.1:1443:10.18.42.43:443 ${SSH_PROXY}
    ${ssh_proxy_cmd} -L 127.0.0.1:2443:10.18.42.44:443 ${SSH_PROXY}
 
    unset ssh_proxy_cmd
}

# ALIASES

alias getpasswd='tr -dc "A-Za-z0-9@!#%^$&*()-_=+" < /dev/urandom | fold -w ${PASSLEN:-16} | head -1'
alias getpasswd_alnum='tr -dc [:alnum:] < /dev/urandom | fold -w ${PASSLEN:-16} | head -1'
alias ansible_add_new_role='_ansible_add_new_role'
alias ansible-playbook='_ansible_playbook $@'
alias nc='nc -vzw3 $@'
alias tun='_list_ssh_tunnels'
alias tundown='_down_ssh_tunnels'
alias tunup='_up_ssh_tunnels'
alias kl='ssh-add -L | cut -d" " -f3'
alias tmux='tmux attach -t 0 || tmux'
alias ssh='ssh -o StrictHostKeyChecking=no'
alias s='ls -l'
alias cls='clear'
alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'

# EXPORT ENVIRONMENT VARS

export ANSIBLE_VENV_PATH=~/.ansible-venv
export SSH_AUTH_SOCK=~/.ssh/agent.socket
export SSH_PROXY=valeriy.z@100.64.0.18
export PATH=${PATH}:${ANSIBLE_VENV_PATH}/bin
export EDITOR=vim
export TERM='xterm-256color'
export PS1="\[\e[36m\]\w\[\e[m\]\[\e[32m\]\[\e[m\]\[\e[32;98m\]\nλ\[\e[m\] "
export PROMPT_COMMAND="echo"

# MAIN

cd ~

eval $(dircolors ~/.dircolors)

# Initialize ssh-agent with keys
# init_ssh_agent
# Using npiperelay for WSL to proxy ssh-agent keys from Windows host machine
ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
    rm -f $SSH_AUTH_SOCK
    npiperelaypath=$(wslpath "C:/npiperelay")
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$npiperelaypath/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi

# Start tmux
if [ -z $TMUX ]; then
    tmux
fi

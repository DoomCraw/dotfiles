#!/bin/bash

set -eu

DOTFILES_ROOT=$(cd $(dirname $0); echo $(pwd))
ANSIBLE_VENV_NAME=.ansible-venv
ANSIBLE_VENV_PIP_REQUIREMENTS=${DOTFILES_ROOT}/${ANSIBLE_VENV_NAME}/requirements.txt
ANSIBLE_VENV_GALAXY_REQUIREMENTS=${DOTFILES_ROOT}/${ANSIBLE_VENV_NAME}/requirements.yml

dotfiles_sync () {
	pushd ${DOTFILES_ROOT}
	git pull origin main
	rsync --exclude ".git/" \
		  --exclude "${ANSIBLE_VENV_NAME}/" \
		  --exclude ".gitignore" \
		  --exclude "bootstrap.sh" \
		  --exclude "README.md" \
		  --exclude "LICENSE" \
		  -avh \
		  --no-perms . ~
	popd
}

ssh_perms () {
	chown ${USER}:${USER} -R ~/.ssh
	chmod 0700 -R ~/.ssh
	chmod 600 ~/.ssh/*
}

pushd ~

python3 -m venv ${ANSIBLE_VENV_NAME}
source ${ANSIBLE_VENV_NAME}/bin/activate
pip install pip --upgrade
pip install -r ${ANSIBLE_VENV_PIP_REQUIREMENTS}
ansible-galaxy install -r ${ANSIBLE_VENV_GALAXY_REQUIREMENTS}
deactivate

mkdir -p .vim/{autoload,bundle}
curl -fsSL https://tpo.pe/pathogen.vim -o .vim/autoload/pathogen.vim

export plugins=(
"https://github.com/vim-airline/vim-airline-themes vim-airline-themes"
"https://github.com/vim-airline/vim-airline vim-airline"
"https://github.com/sheerun/vim-polyglot vim-polyglot"
"https://github.com/sainnhe/everforest.git everforest"
"https://github.com/morhetz/gruvbox.git gruvbox"
"https://github.com/cocopon/iceberg.vim.git iceberg"
"https://github.com/preservim/nerdtree.git nerdtree"
"https://github.com/pearofducks/ansible-vim ansible-vim"
"https://github.com/neoclide/coc.nvim coc.nvim"
"https://github.com/martinda/Jenkinsfile-vim-syntax.git Jenkinsfile-vim-syntax"
"https://github.com/dense-analysis/ale ale"
)
pushd .vim/bundle
for plugin in "${plugins[@]}"; do
    git clone -q $plugin
done
popd

pushd .vim/bundle/coc.nvim
npm ci
popd

dotfiles_sync
ssh_perms

test -d ~/.tmux/plugins/tpm || \
	git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

dircolors --print-database > ~/.dircolors

unset DOTFILES_ROOT ANSIBLE_VENV_NAME ANSIBLE_VENV_PIP_REQUIREMENTS ANSIBLE_VENV_GALAXY_REQUIREMENTS
unset dotfiles_sync ssh_perms plugins

exit 0

#!/bin/bash


set -eu

pushd $(dirname ${BASH_SOURCE})
git pull origin main

sync_dotfiles () {
	rsync --exclude ".git" \
		  --exclude ".gitignore" \
		  --exclude "components" \
		  --exclude "bootstrap.sh" \
		  --exclude "setup.sh" \
		  --exclude "README.md" \
		  --exclude "LICENSE" \
		  -avh \
		  --no-perms . ~
}

set_ssh_perms () {
	chown ${USER}:${USER} -R ~/.ssh
	chmod 0700 -R ~/.ssh
	chmod 600 -R ~/.ssh/**
}

sync_dotfiles
set_ssh_perms

pushd ~

if [ ! -d .vim/autoload -a ! -d .vim/bundle ]; then
	mkdir -p .vim/{autoload,bundle}
	curl -fsSL https://tpo.pe/pathogen.vim -o .vim/autoload/pathogen.vim

	plugins=(
    "https://github.com/vim-airline/vim-airline-themes"
    "https://github.com/vim-airline/vim-airline"
    "https://github.com/sheerun/vim-polyglot"
    "https://github.com/sainnhe/everforest"
    "https://github.com/morhetz/gruvbox"
    "https://github.com/cocopon/iceberg.vim"
    "https://github.com/preservim/nerdtree"
    "https://github.com/pearofducks/ansible-vim"
    "https://github.com/neoclide/coc.nvim"
    "https://github.com/martinda/Jenkinsfile-vim-syntax"
    "https://github.com/dense-analysis/ale"
	)

	pushd .vim/bundle

	IFS=""
	for plugin in "${plugins[@]}"; do
	    git clone -q $plugin
	done

	popd

	pushd .vim/bundle/coc.nvim
	npm ci
	popd
fi

if [ ! -d ~/.tmux/plugins/tpm ]; then
	if [ ! -d ~/.tmux/plugins ]; then
		mkdir -p ~/.tmux/plugins
	fi
	git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -f ~/.dircolors ]; then
	dircolors --print-database > ~/.dircolors
fi

popd

popd


unset sync_dotfiles set_ssh_perms plugins plugin

exit 0
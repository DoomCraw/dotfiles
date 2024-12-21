#!/bin/bash

GIT_FOLDER="${1:-/mnt/d/git}"

dotfiles_sync () {
	rsync --exclude ".git/" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE" \
		-avh \
		--no-perms . ~
}

cd ~

rm -rf ansible .aws .bash_profile .ctags .tmux.conf .vim .vimrc .ssh

mkdir -p ~/.ssh/controlmasters
chmod 0700 -R ~/.ssh/controlmasters

ln -s $GIT_FOLDER git

python3 -m venv ansible
source ~/ansible/bin/activate
pip install pip --upgrade
pip install ansible==9.13.0 ansible-lint==24.7.0 pyyaml==6.0.2 docker==6.1.3 requests==2.32.3 passlib==1.7.4
deactivate

mkdir -p ~/.vim/{autoload,bundle}
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

export plugins=(
"https://github.com/vim-airline/vim-airline-themes vim-airline-themes"
"https://github.com/vim-airline/vim-airline vim-airline"
"https://github.com/sheerun/vim-polyglot vim-polyglot"
"https://github.com/sainnhe/everforest.git everforest"
"https://github.com/preservim/nerdtree.git nerdtree"
"https://github.com/pearofducks/ansible-vim ansible-vim"
"https://github.com/neoclide/coc.nvim coc.nvim"
"https://github.com/morhetz/gruvbox.git gruvbox"
"https://github.com/martinda/Jenkinsfile-vim-syntax.git Jenkinsfile-vim-syntax"
"https://github.com/junegunn/fzf.vim.git fzf"
"https://github.com/juliosueiras/vim-terraform-completion.git vim-terraform-completion"
"https://github.com/hashivim/vim-terraform.git vim-terraform"
"https://github.com/google/vim-jsonnet vim-jsonnet"
"https://github.com/flazz/vim-colorschemes.git colorschemes"
"https://github.com/dense-analysis/ale ale"
"https://github.com/cocopon/iceberg.vim.git iceberg"
)
cd ~/.vim/bundle
for plugin in "${plugins[@]}"; do
    git clone -q $plugin
done

cd .vim/bundle/coc.nvim
npm ci

cd "$(dirname "${BASH_SOURCE}")"

git pull origin main

dotfiles_sync

unset GIT_FOLDER dotfiles_sync plugins

exit 0

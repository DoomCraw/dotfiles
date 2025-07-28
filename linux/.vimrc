syntax on
filetype plugin indent on

" General
set cuc                         " Set cursorcolumn
set cursorline                  " Set cursonline
set cursorlineopt=number        " Set line number highlight
set exrc                        " Load vimrc from project directory
set number                      " Show line numbers
set numberwidth=4
set showmatch                   " Highlight matching brace
set visualbell                  " Use visual bell (no beeping)
set nocompatible                " Set off vi compatible mode
set signcolumn=yes

" set paste                     " don't shift line when press enter

set hlsearch                    " Highlight all search results
set smartcase                   " Enable smart-case search
set ignorecase                  " Always case-insensitive
set incsearch                   " Searches for strings incrementally

set autoindent                  " Auto-indent new lines
set expandtab                   " Use spaces instead of tabs
set shiftwidth=4                " Number of auto-indent spaces
set smartindent                 " Enable smart-indent
set smarttab                    " Enable smart-tabs
set softtabstop=4               " Number of spaces per Tab
set tabstop=4                   " Number of spaces per Tab

set ruler                       " Show row and column ruler information
set undolevels=1000             " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour
" set nowrap                    " no linebreak for long lines
set wrap linebreak              " linebreak for long lines

set showcmd                     " show command letter for quick commands

set tabpagemax=15               " Maximum number of tab pages to be opened
set showtabline=2               " Always show tabline

set encoding=utf-8

set nobackup
set nowritebackup

set updatetime=100

" Color column 120
highlight ColorColumn ctermbg=6 guibg=lightblue
set colorcolumn=120

" ==========================       COLORSCHEME       =========================================
set background=dark " dark, light
" let g:everforest_background = 'hard' " hard, medium, soft
" let g:everforest_better_performance = 1
" let g:airline_theme = 'everforest'

let g:gruvbox_contrast_dark='hard'
if has('termguicolors')
  set termguicolors
endif

autocmd VIMEnter * ++nested colorscheme iceberg

" ===============================       KEYMAP       =========================================
" tabs
map TN :tabnew<cr>
map TC :tabclose<cr>
map TE :tabedit
map <leader>t<leader> :tabnext
map <leader>tm :tabmove
map <leader>to :tabonly<cr>
nnoremap H gT
nnoremap L gt
" exit
map ZA :qall!<cr>
map ZX :q!<cr>
" NERDTree
map <F5> :NERDTreeToggle<CR>
" Vim terminal
" terminal in split window
map <leader>t :term ++close<cr>
tmap <leader>t <c-w>:term ++close<cr>

" terminal in new tab
map <leader>T :tab term ++close<cr>
tmap <leader>T <c-w>:tab term ++close<cr>

" ===============================       FILETYPES       ======================================
au FileType yml,yaml setlocal ts=2 sts=2 sw=2 indentkeys-=0# " indentkeys-=<:>
au BufRead,BufNewFile */ansible/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */ansible/*.yaml set filetype=yaml.ansible

" =============================== PLUGINS MANAGEMENT =========================================

" Call pathogen plugin manager
call pathogen#infect()

" NERDTree
" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
autocmd VimEnter * NERDTree | wincmd p

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
autocmd VimLeave * NERDTreeClose

let NERDTreeShowHidden = 1
" END: NERDTree

" AirLine
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '>'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_statusline_ontop=0
let g:airline_theme='google_dark'

function! AirLineInit()
  let g:airline_section_a = airline#section#create(['mode',' ','branch'])
  let g:airline_section_b = airline#section#create_left(['ffenc','hunks','%f'])
  let g:airline_section_c = airline#section#create(['filetype'])
  let g:airline_section_x = airline#section#create(['%P'])
  let g:airline_section_y = airline#section#create(['%B'])
  let g:airline_section_z = airline#section#create_right(['%l', '%c'])
endfunction
autocmd VimEnter * call AirLineInit()

" END: AirLine

" COC Ansible
let g:coc_filetype_map = {
    \ 'yaml.ansible': 'ansible',
  \ }

let g:ansible_unindent_after_newline = 1
let g:ansible_attribute_highlight = 'ob'
let g:ansible_name_highlight = 'd'
let g:ansible_extra_keywords_highlight = 1
let g:ansible_extra_keywords_highlight_group = 'Statement'
let g:ansible_fqcn_highlight = 'Constant'

" END: COC Ansible

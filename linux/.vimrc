" Load local vimrc from project directory (set this in your main vimrc)
" set exrc

syntax on
filetype plugin indent on

autocmd FileType yml,yaml setlocal ts=2 sts=2 sw=2 et ai cuc indentkeys-=0# " indentkeys-=<:>

" Color column 80
highlight ColorColumn ctermbg=6 guibg=lightblue
set colorcolumn=80

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

"" Advanced
set ruler                       " Show row and column ruler information
set undolevels=1000             " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour
" set nowrap                    " no linebreak for long lines
set wrap linebreak              " linebreak for long lines

set showcmd                     " show command letter for quick commands

set background=dark " dark, light
" let g:everforest_background = 'hard' " hard, medium, soft
" let g:everforest_better_performance = 1
" let g:airline_theme = 'everforest'

let g:gruvbox_contrast_dark='hard'
if has('termguicolors')
  set termguicolors
endif

" autocmd VIMEnter * ++nested colorscheme everforest
" autocmd VimEnter * ++nested colorscheme gruvbox
autocmd VimEnter * ++nested colorscheme iceberg
" autocmd VimEnter * ++nested colorscheme moody
" autocmd VimEnter * ++nested colorscheme distinguished

" vim tabcontrol
map <leader>tn :tabnew<cr>
map <leader>t<leader> :tabnext
map <leader>tm :tabmove
map <leader>tc :tabclose<cr>
map <leader>to :tabonly<cr>
map <leader>te :tabedit
map ZA :qall!<cr>
map <F5> :NERDTreeToggle<CR>

call pathogen#infect()
" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
autocmd VimEnter * NERDTree | wincmd p
autocmd ColorScheme * highlight CursorLineNr cterm=bold term=bold gui=bold
au BufRead,BufNewFile */ansible/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */ansible/*.yaml set filetype=yaml.ansible
au BufReadPre,BufWritePost *.tf,*.tfvars silent execute "!terraform fmt" | redraw!
autocmd BufWritePost *.c,*.cpp,*.h,*.yml,*.yaml,*.tf,*.tfvars,*.ps1,*.psm1,*.py,*.sh silent! !ctags . &
autocmd VimLeave * NERDTreeClose
autocmd VimLeave *.tf,*.tfvars !terraform validate
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" Fzf (fuzzy search)
let g:fzf_preview_window = 'right:50%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }

" terraform
let g:terraform_fmt_on_save=1
let g:terraform_align=1
silent! autocmd! filetypedetect BufRead,BufNewFile *.tf
autocmd BufRead,BufNewFile *.hcl set filetype=hcl
autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl
autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform
autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json

let g:coc_filetype_map = {
    \ 'yaml.ansible': 'ansible',
  \ }

let g:ansible_unindent_after_newline = 1
let g:ansible_attribute_highlight = "ob"
let g:ansible_name_highlight = 'd'
let g:ansible_extra_keywords_highlight = 1
let g:ansible_extra_keywords_highlight_group = 'Statement'
let g:ansible_fqcn_highlight = 'Constant'

let g:ansible_goto_role_paths = './roles,../_common/roles'

function! FindAnsibleRoleUnderCursor()
  if exists("g:ansible_goto_role_paths")
    let l:role_paths = g:ansible_goto_role_paths
  else
    let l:role_paths = "./roles"
  endif
  let l:tasks_main = expand("<cfile>") . "/tasks/main.yaml"
  let l:found_role_path = findfile(l:tasks_main, l:role_paths)
  if l:found_role_path == ""
    let l:tasks_main = expand("<cfile>") . "/tasks/main.yml"
    let l:found_role_path = findfile(l:tasks_main, l:role_paths)
  endif
  if l:found_role_path == ""
    echo l:tasks_main . " not found"
  else
    execute "edit " . fnameescape(l:found_role_path)
  endif
endfunction

au BufRead,BufNewFile */ansible/*.{yml,yaml} nnoremap <leader>gf :call FindAnsibleRoleUnderCursor()<CR>
" au BufRead,BufNewFile */ansible/*.yaml nnoremap <leader>gf :call FindAnsibleRoleUnderCursor()<CR>
au BufRead,BufNewFile */ansible/*.{yml,yaml} vnoremap <leader>gf :call FindAnsibleRoleUnderCursor()<CR>
" au BufRead,BufNewFile */ansible/*.yaml vnoremap <leader>gf :call FindAnsibleRoleUnderCursor()<CR>

" Ansible config END

" AirLine plugin
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '>'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_statusline_ontop=1
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

" let g:airline_powerline_fonts = 1

" if !exists('g:airline_symbols')
"   let g:airline_symbols = {}
" endif
" unicode symbols
" let g:airline_left_sep = '»'
" let g:airline_left_sep = '▶'
" let g:airline_right_sep = '«'
" let g:airline_right_sep = '◀'
" let g:airline_symbols.linenr = '␊'
" let g:airline_symbols.linenr = '␤'
" let g:airline_symbols.linenr = '¶'
" let g:airline_symbols.branch = '⎇'
" let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.paste = 'Þ'
" let g:airline_symbols.paste = '∥'
" let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
" let g:airline_symbols.branch = ''
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = ''

" Macroses
" let @q = '0ciwC-cP'

" FileType indentation example
" augroup custom_indentation
"   autocmd!
" 
"   " for html/rb files, 2 spaces
"   autocmd Filetype html setlocal ts=2 sw=2 expandtab
"   autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
" 
"   " for js/coffee/jade files, 4 spaces
"   autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 expandtab
"   autocmd Filetype coffeescript setlocal ts=4 sw=4 sts=0 expandtab
"   autocmd Filetype jade setlocal ts=4 sw=4 sts=0 expandtab
" augroup END
" -------------------------------------------------


" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" AutoBrackets
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

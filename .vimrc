set nocompatible

" Plugins {{{
" Install Vim-Plug if not yet installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Plugins should be listed below
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'      " Enables dot command for surround.vim
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
" All Plugins must be added before the following line
call plug#end()

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif
" }}}

" Colors {{{
if !exists("g:syntax_on")
    syntax enable
endif
colorscheme torte
" Sets color of column representing the margin to grey
highlight colorColumn ctermbg=8
" Sets color of invisible characters to turquoise.
highlight SpecialKey ctermfg=30
" }}}

" Spaces and tabs {{{
set expandtab      " Use spaces instead of tabs
set shiftwidth=2   " Number of auto-indent spaces
set smarttab       " Use shiftwidth for tab when tab is used for indentation
set softtabstop=2  " Number of spaces per TAB when editing
set tabstop=2      " Number of visual spaces per TAB
" }}}

" Invisible chars {{{
set listchars=tab:>\ ,trail:-
set list                          " Show invisible characters.
" }}}

" UI configs {{{
set colorcolumn=101     " Colors the 101th character in each column differently
set cursorline          " Underscores current line
set display+=lastline   " Last line that does not fit window is truncated.
set laststatus=2        " Always display the status line.
set lazyredraw          " Redraw only when needed.
set number              " Show line numbers
set showcmd             " Show last command in bottom bar
set showmatch           " Highlight matching brace
set visualbell          " Use visual bell (no beeping)
set wildmenu            " Visual autocomplete for command menu
" Scrollofs
if !&scrolloff
  set scrolloff=3       " Minimum number of lines above and below the current line
endif
if !&sidescrolloff
  set sidescrolloff=5   " If nowrap: min number of columns to the left and right of cursor
endif
" Splits
set splitright          " vsplit opens new window on the right
set splitbelow          " split opens new window on the left
" }}}

" Search options {{{
set hlsearch       " Highlight all search results
set ignorecase     " Always case-insensitive
set incsearch      " Increament search
set smartcase      " Enable smart-case search
" }}}

" Folding {{{
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
" }}}

" Automcommands {{{
augroup configs
  autocmd!
  autocmd FileType make setlocal noexpandtab
augroup END
" }}}

" Custom commands and mappings {{{

" Use jk in insert mode to change to normal mode.
inoremap jk <esc>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Use <C-N> to clear search highlights.
if maparg('<C-N>', 'n') ==# ''
  nnoremap <silent> <C-N> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Quicker moving between windows.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Use \l to toggle showing invisible characters.
nnoremap <leader>l :set list!<CR>

" Use space to fold.
nnoremap <space> za

" Make * and # usable on visual selection. Source:
" http://vimcasts.org/episodes/search-for-the-selected-text
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" }}}

" Misc {{{
set autoindent
set autoread
set backspace=indent,eol,start  " Backspace works as normal
" Default autcomplete doesn't try to find possible matches from 'included files' (e.g. when using
" import / require). If you want to use the imported files as source use <C-x><C-i>.
set complete-=i

" No need for economic settings
if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif

set matchpairs+=<:>             " use % to jump between pairs

" Numbers starting with 0 won't be considered octals when using <c-a> or <c-x>
set nrformats-=octal

" Set timeframe for typing in key codes
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/usr/bin/env\ bash
endif
" }}}

" Stuff from Sensible-Vim I don't understand totally yet or didn't decide which section to put {{{
if !empty(&viminfo)
  set viminfo^=!  " Restore global variables named with all upper case letter
endif
set sessionoptions-=options
set viewoptions-=options
" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" Make <C-U> or <C-W> in insert mode undo-able
" (<C-U>: delete everythin in line till cursor; <C-W>: delete last word)
" delete last word). Makes the deletion undo-able.
if empty(mapcheck('<C-U>', 'i'))
  inoremap <C-U> <C-G>u<C-U>
endif
if empty(mapcheck('<C-W>', 'i'))
  inoremap <C-W> <C-G>u<C-W>
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif
" }}}

" Disable built-in commands for training the correct habits {{{
" Use the h, j , k, l buttons instead of the arrows.
nnoremap <up> <Nop>
nnoremap <down> <Nop>
nnoremap <left> <Nop>
nnoremap <right> <Nop>

" }}}

" vim: filetype=vim foldmethod=marker foldlevel=0

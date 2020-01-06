" Remove ALL auto-commands.  This avoids having the autocommands twice when
" the vimrc file is sourced again.
autocmd!

" Include the system settings
:if filereadable( "/etc/vimrc" )
   source /etc/vimrc
:endif

" Put your own customizations below
set nocompatible
set autoindent          " always set autoindenting on
set shiftwidth=3
set expandtab

set autowrite " Save whenever we do something like :make
set nojoinspaces

set incsearch " Search as you type
set smarttab

" The first tab completes as much as it can, second tab displays a list of 
" options, and the third tab will present a list that allows you to scroll 
" through and select filenames beginning with that prefix.
set wildmode=longest,list,full
set wildmenu

" Enable file type detection.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

autocmd BufRead *.C,*.cc,*.c,*.h,*.cpp,*.cp setlocal cindent
" In Makefiles, tabs matter
autocmd FileType automake setlocal noexpandtab

""" General syntax
syntax on

" Avoid using 4 spaces for tabs
let g:python_recommended_style = 0

" Install vimplug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'Yggdroot/indentLine'

" Initialize plugin system
call plug#end()

" #############################################################################
"  Color Scheme
" #############################################################################
syntax enable
set background=dark
colorscheme gruvbox

" #############################################################################
" new keybindings
" #############################################################################
ino jj <esc>     
cno jj <c-c>                  
vno v <esc>

" #############################################################################
" Window customizations
" #############################################################################
set number
set cursorline
set colorcolumn=86
highlight ColorColumn ctermbg=8

" #############################################################################
" Search customizations
" #############################################################################
set ignorecase
set smartcase
set magic

" #############################################################################
" Mouse Support
" #############################################################################
if has('mouse')
   set mouse=a
endif

" #############################################################################
" Tmux stuff
" #############################################################################
if &term =~ '^screen' && exists('$TMUX')
   " tmux knows the extended mouse mode
   set mouse+=a
endif

set pastetoggle=<F3>

" #############################################################################
" Copy into vimbuffer
" #############################################################################
vmap Y :w! ~/.vimbuffer<CR>
vmap x :w! ~/.vimbuffer <bar> :'<,'>d<CR>
nmap P :r ~/.vimbuffer<CR>

" Vim initialisation file (Unix version: ".vimrc")
" 
" Maintainer:	Mario Schweigler <ms44@kent.ac.uk>
" Last Change:	23 April 2003

"{{{  Colour scheme (must be done first!)
colorscheme zenburn
"}}}

" {{{ Look & Feel
" Filetype detection on
filetype on
" Filetype plugin on
filetype plugin on
" Syntax highlighting on
syntax on
" Show line number
set number
" Show command
set showcmd
" Show current mode
set showmode
" Show ruler in status line
set ruler
" Wrap lines at line break
set wrap
set linebreak
let &breakat = ' 	'
" Show status line for all files
set laststatus=2
" Enable autoindent
set autoindent
" Enable filetype indent
filetype indent on
" Ignore case on pure lower case search patterns
set ignorecase
set smartcase
" Increment search as you type search pattern
set incsearch
" Highlight search patterns
set hlsearch
" Show matching brackets
set showmatch
set matchtime=3
" Create backup files
set backup
" Add $TEMP directory to swap file directory list
if exists('$TEMP')
  let &directory = &directory . ',' . $TEMP
endif
" }}}

"{{{  Call external runtime files
" Some improvements
runtime kent-improve.vim
" Entering folds and other fold improvements
runtime kent-folding.vim
" Programming scripts
runtime kent-programming.vim
" Occam scripts
runtime kent-occam.vim 
"}}}


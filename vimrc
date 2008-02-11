set nocompatible
source $VIMRUNTIME/vimrc_example.vim
behave xterm

colorscheme zenburn

set nobackup

" vim assumes you want to print cjk when encoding is utf-8
set printencoding=posix

" turn on spell check
set spelllang=en_us
map <F8> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>
set sps=best,10

" set localleader to \
"let maplocalleader="\\"

" tab stuff
" comment expandtab to use tabs instead of spaces
set expandtab
set smarttab
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4

" random settings from kent 
set cmdheight=2
set winaltkeys=no
set backspace=2 whichwrap+=<,>,[,]

" minibufexpl
let loaded_minibufexplorer = 1 " to stop mbe loading
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

" yankring
"noremap <F5> :YRShow<CR>

" lookupfile
let g:LookupFile_TagExpr = '"./filenametags"'

" taglist
noremap <F6> :TlistToggle<CR>
let g:Tlist_Use_Right_Window = 1
let g:Tlist_Exit_OnlyWindow = 1
let g:Tlist_File_Fold_Auto_Close = 1
let g:Tlist_Max_Submenu_Items = 20

" remap NERD comments leader
"let NERD_mapleader = '\n'

" rjs files are ruby
au BufNewFile,BufRead *.rjs    setf ruby

" enable rubycomplete
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete

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
" Add $TEMP directory to swap file directory list
if exists('$TEMP')
  let &directory = &directory . ',' . $TEMP
endif
set wildmenu

"
" genutils
"

" The :find command is very useful to search for a file in path, but it
"   doesn't support file completion. Add the following command in your vimrc
"     to add this functionality
command! -nargs=1 -bang -complete=custom,<SID>PathComplete FindInPath
            \ :find<bang> <args>
function! s:PathComplete(ArgLead, CmdLine, CursorPos)
    return UserFileComplete(a:ArgLead, a:CmdLine, a:CursorPos, 1, &path)
endfunction

" If you are running commands that generate multiple pages of output, you
"   might find it useful to redirect the output to a new buffer. Put the
"     following command in your vimrc
"command! -nargs=* -complete=command Redir
"          \ :new | put! =GetVimCmdOutput('<args>') | setl bufhidden=wipe |
"          \ setl nomodified

" rails.vim
"
" url command
:command -bar -nargs=1 OpenURL :!firefox <args>

" rails_level
let g:rails_level = 4

" rubycomplete
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 0
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

"
" project.vim
"
" flags, see help proj_flags for explanation
let g:proj_flags="imstgL"

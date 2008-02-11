" Vim GUI initialisation file (Unix version: ".gvimrc")
" 
" Maintainer:	Mario Schweigler <ms44@kent.ac.uk>
" Last Change:	23 April 2003

"{{{  Colour scheme (must be done first!)
colorscheme zenburn
"}}}

"{{{  Call external runtime files
" Behave like a "normal" editor (concerning selections, copy, paste, etc.)
runtime kent-gui-improve.vim
"}}}

"{{{  Personal settings (Please adjust according to personal preference!)
" Set number of lines and columns
"set lines=55
"set columns=135

" Set font and fix the font bug of some releases
augroup fixfontbug
  autocmd BufEnter * execute 'set guifont& | autocmd! fixfontbug'
augroup end
"}}}


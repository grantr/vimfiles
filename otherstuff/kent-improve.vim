" Vim support file to improve the look and feel of Vim
"
" Maintainer:	Mario Schweigler <ms44@kent.ac.uk>
" Last Change:	23 April 2003

" Only load this file once
if exists("b:did_improve")
  finish
endif
let b:did_improve = 1

" {{{ Settings
" Filetype detection on
filetype on
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
set linebreak
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
"set backup
" }}}

"{{{  User defined commands

" Toggle backup
command Togglebackup call <SID>ToggleBackup()

" Toggle tab style
command Toggletabstyle call <SID>ToggleTabStyle()

" Clean white lines
command -range Cleanwhiteline call <SID>CleanWhiteLines(<line1>, <line2>)

"{{{  Shortcuts for the commands
command TB Togglebackup
command TTS Toggletabstyle
command -range CWL <line1>,<line2> Cleanwhiteline
"}}}

"}}}

"{{{  Keyboard mappings

"{{{  Handle Tab key
"{{{  function <SID>HandleTab(mode, shift)
" Search for a help link or a compiler error line number or increase/decrease indent
function <SID>HandleTab(mode, shift)

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  " Special window and normal mode
  if (&filetype == 'help' || exists('b:is_compileroutput')) && a:mode == 'n'

    " Set search string
    if &filetype == 'help'
      let searchstring = '|\S\+|'
    elseif exists('b:is_compileroutput')
      let searchstring = '\<\d*\>'
    endif

    " Perform search
    call search(searchstring, a:shift)

  else
    if &modifiable
      " Find range if in visual mode
      if a:mode == 'v'
        let startline = line("'<")
        let endline = line("'>")
	if @z =~ "\n$" && @z !~ "^\n$"
          let endline = endline - 1
        endif
      endif

      " Increase indent
      if a:shift == ''
        if a:mode == 'v'
          if endline >= startline
            exe startline . ',' . endline . '>'
          endif
        else
          >
        endif
      " Decrease indent
      else
        if a:mode == 'v'
          if endline >= startline
            exe startline . ',' . endline . '<'
          endif
        else
          <
        endif
      endif

    else
      echohl ErrorMsg
      echomsg "E21: Cannot make changes, 'modifiable' is off"
      echohl None
    endif
  endif

  " Restore magic
  if !save_magic|setlocal nomagic|endif
endfunction
"}}}

" Tab is Goto next help link or Increase indent (not in insert mode; there normal tab behaviour)
noremap <silent><Tab> :call <SID>HandleTab('n', '')<CR>
onoremap <silent><Tab> <Esc>
vnoremap <silent><Tab> "zy:call <SID>HandleTab('v', '')<CR>gv

" Shift-Tab is Goto previous help link or Decrease indent
noremap <silent><S-Tab> :call <SID>HandleTab('n', 'b')<CR>
onoremap <silent><S-Tab> <Esc>
vnoremap <silent><S-Tab> "zy:call <SID>HandleTab('v', 'b')<CR>gv
inoremap <silent><S-Tab> <C-O>:call <SID>HandleTab('i', 'b')<CR>
"}}}

"{{{  Handle Enter key
"{{{  function <SID>HandleEnter()

" Goto help link or source line
function <SID>HandleEnter()
  if &filetype == 'help'
    let v:errmsg = ''
    silent! normal 
    if v:errmsg != ''
      echohl ErrorMsg
      echomsg v:errmsg
      echohl None
    endif
  elseif exists('b:is_compileroutput')
    Gotosourceline
  else
    nunmap <CR>
    normal 
    nnoremap <silent><CR> :call <SID>HandleEnter()<CR>
  endif
endfunction
"}}}

" Enter follows link in help and compiler output windows
nnoremap <silent><CR> :call <SID>HandleEnter()<CR>
"}}}

"{{{  Toggle backup
" F9 toggles backup
noremap <silent><F9> :Togglebackup<CR>
onoremap <F9> <Esc>
vnoremap <silent><F9> <Esc>:Togglebackup<CR>
inoremap <silent><F9> <C-O>:Togglebackup<CR>
"}}}

"{{{  Toggle tab style
" F12 toggles tab style
noremap <silent><F12> :Toggletabstyle<CR>
onoremap <F12> <Esc>
vnoremap <silent><F12> <Esc>:Toggletabstyle<CR>
inoremap <silent><F12> <C-O>:Toggletabstyle<CR>
"}}}

"{{{  Clean white lines
" Ctrl-F12 is Clean white lines
noremap <silent><C-F12> :Cleanwhiteline<CR>
onoremap <C-F12> <Esc>
inoremap <silent><C-F12> <C-O>:Cleanwhiteline<CR>
"}}}

"}}}

"{{{  function <SID>ToggleBackup()
" Function to toggle whether backup is switched on or off
function <SID>ToggleBackup()
  if &backup
    set nobackup
    echomsg "Backup disabled"
  else
    set backup
    echomsg "Backup enabled"
  endif
endfunction
"}}}

"{{{  function <SID>ToggleTabStyle()
" Function to toggle between Vim style and occam style tabs
function <SID>ToggleTabStyle()
  if &shiftwidth == 2
    setlocal shiftwidth&
    setlocal softtabstop&
    setlocal expandtab&
    echomsg "Switched to Vim style tabs"
  else
    setlocal shiftwidth=2
    setlocal softtabstop=2
    setlocal expandtab
    echomsg "Switched to occam style tabs"
  endif
endfunction
"}}}

"{{{  function <SID>CleanWhiteLines(startsel, endsel)
" Function to clean lines which contain only whitespaces
" Arguments: a:startsel is the first line of the selection
"            a:endsel is the last line of the selection
function <SID>CleanWhiteLines(startsel, endsel)

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  " For all lines
  let curline = a:startsel
  while curline <= a:endsel

    " Clean line
    let line = getline(curline)
    if line =~ '^\s\+$'
      call setline(curline, '')
    endif
    let curline = curline + 1
  endwhile

  " Restore magic
  if !save_magic|setlocal nomagic|endif
endfunction
"}}}


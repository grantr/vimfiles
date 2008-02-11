" Vim support file to improve the look and feel of GVim, so that it acts in a more "usual" way
" Partly based on Bram Moolenaar's <Bram@vim.org> "mswin.vim" script
"
" Maintainer:	Mario Schweigler <ms44@kent.ac.uk>
" Last Change:	23 April 2003

" Only load this file once
if exists("b:did_guiimprove")
  finish
endif
let b:did_guiimprove = 1

" {{{ Settings
" Height of commandline is 2
" (This enables us to see keep the last output and reduces number of "Hit Enter" messages)
set cmdheight=2

" Set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
"behave mswin

" Reserve keys for shortcuts
set winaltkeys=no

" Always use Selcet mode instead of Visual mode
set selectmode+=cmd

" Backspace and cursor keys wrap to previous/next line
set backspace=2 whichwrap+=<,>,[,]
"}}}

"{{{  Keyboard mappings

"{{{  Set cpoptions to Vim default
if 1 " only do this when compiled with expression evaluation
  let s:save_cpo = &cpoptions
endif
set cpo&vim
"}}}

"{{{  Buffers and windows
" Ctrl-Tab is Next window
"noremap <C-Tab> <C-W>w
"onoremap <C-Tab> <Esc>
"inoremap <C-Tab> <C-O><C-W>w
"cnoremap <C-Tab> <C-C><C-W>w

" Ctrl-Shift-Tab is Previous window
"noremap <C-S-Tab> <C-W>W
"onoremap <C-S-Tab> <Esc>
"inoremap <C-S-Tab> <C-O><C-W>W
"cnoremap <C-S-Tab> <C-C><C-W>W

" Ctrl-F4 is Close window
noremap <silent><C-F4> :if winheight(2) < 0\|confirm enew\|else\|confirm close\|endif<CR>
onoremap <C-F4> <Esc>
vnoremap <silent><C-F4> <Esc>:if winheight(2) < 0\|confirm enew\|else\|confirm close\|endif<CR>
inoremap <silent><C-F4> <C-O>:if winheight(2) < 0\|confirm enew\|else\|confirm close\|endif<CR>
cnoremap <silent><C-F4> <C-C>

" Alt-F4 is Close Vim; ignore it on Cancel (for MS Windows)
if has("gui")
  noremap <silent><M-F4> :<CR>
  inoremap <silent><M-F4> <C-O>:<CR>
  cnoremap <silent><M-F4> x<BS>
endif

" Alt-Space is System menu
if has("gui")
  noremap <silent><M-Space> :simalt ~<CR>
  inoremap <silent><M-Space> <C-O>:simalt ~<CR>
  cnoremap <silent><M-Space> <C-C>:simalt ~<CR>
endif
"}}}

"{{{  Movement
" Ctrl-Up is Scroll one line up
noremap <C-Up> <C-Y>
onoremap <C-Up> <Esc>
inoremap <C-Up> <C-O><C-Y>

" Ctrl-Down is Scroll one line down
noremap <C-Down> <C-E>
onoremap <C-Down> <Esc>
inoremap <C-Down> <C-O><C-E>

" F11 toggles between displaywise and linewise movement
"{{{  function <SID>ToggleMovement()
function <SID>ToggleMovement()
  if maparg('<Up>', '') =~ '^$'

    " Up is Displaywise Up
    noremap <Up> gk
    vnoremap <Up> <Esc>gkgV
    inoremap <Up> <C-O>gk

    " Down is Displaywise Down
    noremap <Down> gj
    vnoremap <Down> <Esc>gjgV
    inoremap <Down> <C-O>gj

    " Shift-Up is Displaywise Shift-Up
    noremap <S-Up> vgk<C-G>
    onoremap <S-Up> gk
    vnoremap <S-Up> gk
    inoremap <S-Up> <S-Left><S-Right>g<Up><C-G>

    " Shift-Down is Displaywise Shift-Down
    noremap <S-Down> vgj<C-G>
    onoremap <S-Down> gj
    vnoremap <S-Down> gj
    inoremap <S-Down> <S-Right><S-Left>g<Down><C-G>

    " Not in origami mode
    if maparg('<Insert>', '') =~ '^$'
      " Home is Displaywise Home
      noremap <Home> g<Home>
      vnoremap <Home> <Esc>g<Home>gV
      inoremap <Home> <C-O>g<Home>

      " End is Displaywise End
      noremap <End> g<End>
      vnoremap <End> <Esc>g<End>gV
      inoremap <End> <C-O>g<End>
    endif

    " Shift-Home is Displaywise Shift-Home
    noremap <S-Home> vg<Home><C-G>
    onoremap <S-Home> g<Home>
    vnoremap <S-Home> g<Home>
    inoremap <S-Home> <S-Left><S-Right>g<Home><C-G>

    " Shift-End is Displaywise Shift-End
    noremap <S-End> vg<End><C-G>
    onoremap <S-End> g<End>
    vnoremap <S-End> g<End>
    inoremap <S-End> <S-Right><S-Left>g<End><C-G>

    echomsg "Switched to displaywise movement"
  else

    " Upmap relevant key mappings
    unmap <Up>
    iunmap <Up>
    unmap <Down>
    iunmap <Down>
    unmap <S-Up>
    iunmap <S-Up>
    unmap <S-Down>
    iunmap <S-Down>
    unmap <S-Home>
    iunmap <S-Home>
    unmap <S-End>
    iunmap <S-End>

    " Not in origami mode
    if maparg('<Insert>', '') =~ '^$'
      unmap <Home>
      iunmap <Home>
      unmap <End>
      iunmap <End>
    endif

    echomsg "Switched to linewise movement"
  endif
endfunction
"}}}
noremap <silent><F11> :call <SID>ToggleMovement()<CR>
onoremap <F11> <Esc>
vnoremap <silent><F11> <Esc>:call <SID>ToggleMovement()<CR>
inoremap <silent><F11> <C-O>:call <SID>ToggleMovement()<CR>
"}}}

"{{{  Delete, Cut, Copy, Paste, Select
" Backspace in Visual mode deletes selection
vnoremap <BS> d

" Ctrl-D deletes line
noremap <C-D> dd
onoremap <C-D> <Esc>
vnoremap <silent><C-D> :d<CR>gV
inoremap <C-D> <C-O>dd

" Use additional Alt for original Ctrl-D command
noremap <M-C-D> <C-D>

" Fix bug of middle mouse button in select mode 
vnoremap <MiddleMouse> <MiddleMouse>
vnoremap <2-MiddleMouse> <Esc>
vnoremap <3-MiddleMouse> <Esc>
vnoremap <4-MiddleMouse> <Esc>

" Insert selection at the mouse position when middle mouse button pressed in insert mode 
inoremap <MiddleMouse> <LeftMouse><MiddleMouse>

" Ctrl-X and Shift-Del are Cut (linewise if nothing is selected)
"noremap <C-X> "+dd
"onoremap <C-X> <Esc>
"vnoremap <C-X> "+x
"inoremap <C-X> <C-O>"+dd

noremap <S-Del> "+dd
onoremap <S-Del> <Esc>
vnoremap <S-Del> "+x
inoremap <S-Del> <C-O>"+dd

" Ctrl-Alt-X toggles Cut mapping to enable ^X mode in insert mode
"{{{  function <SID>ToggleCutMapping()
function <SID>ToggleCutMapping()
  if maparg('<C-X>', 'i') =~ '^$'
    inoremap <C-X> <C-O>"+dd
    echomsg "^X mode disabled"
  else
    iunmap <C-X>
    echomsg "^X mode enabled"
  endif
endfunction
"}}}
noremap <M-C-X> :call <SID>ToggleCutMapping()<CR>
onoremap <M-C-X> <Esc>
vnoremap <M-C-X> <Esc>:call <SID>ToggleCutMapping()<CR>
inoremap <M-C-X> <C-O>:call <SID>ToggleCutMapping()<CR>

" Ctrl-C and Ctrl-Insert are Copy (linewise if nothing is selected)
noremap <C-C> "+Y
onoremap <C-C> <Esc>
vnoremap <C-C> "+y
inoremap <C-C> <C-O>"+Y

noremap <C-Insert> "+Y
onoremap <C-Insert> <Esc>
vnoremap <C-Insert> "+y
inoremap <C-Insert> <C-O>"+Y

" Use Ctrl-F9 for original Ctrl-C command
noremap <C-F9> <C-C>
inoremap <C-F9> <C-C>

" Ctrl-V and Shift-Insert are Paste
noremap <C-V> "+gP
noremap <S-Insert> "+gP

onoremap <C-V> <Esc>
onoremap <S-Insert> <Esc>

if has("virtualedit")
  nnoremap <silent> <SID>Paste :call <SID>Paste()<CR>

  "{{{  function <SID>Paste()
  function <SID>Paste()
    if !&modifiable
      echohl ErrorMsg
      echomsg "E21: Cannot make changes, 'modifiable' is off"
      echohl None
      return
    endif
    let ove = &ve
    set ve=all
    silent! normal `^"+gP
    let c = col('.')
    normal i
    if col('.') < c
      normal l
    endif
    let &ve = ove
  endfunc
  "}}}
  imap <C-V> <Esc><SID>Pastegi
  vmap <C-V> "-c<Esc><SID>Paste
else
  nnoremap <silent> <SID>Paste "=@+.'xy'<CR>gPFx"_2x
  imap <C-V> x<Esc><SID>Paste"_s
  vmap <C-V> "-c<Esc>gix<Esc><SID>Paste"_x
endif
imap <S-Insert> <C-V>
vmap <S-Insert> <C-V>

cnoremap <C-V> <C-R>+
cnoremap <S-Insert> <C-R>+

" Ctrl-Q replaces Ctrl-V in Insert and Command mode
onoremap <C-Q> <Esc>
inoremap <C-Q> <C-V>
cnoremap <C-Q> <C-V>

" Ctrl-B starts or changes to blockwise selection
noremap <C-B> <C-V>
onoremap <C-B> <Esc>
inoremap <C-B> <C-O><C-V>

" Ctrl-L starts or changes to linewise selection
noremap <C-L> 1\|V
onoremap <C-L> <Esc>
vnoremap <C-L> V
inoremap <C-L> <C-O>1\|<C-O>V

" Use additional Alt for original Ctrl-B and Ctrl-L commands
noremap <M-C-B> <C-B>
inoremap <M-C-B> <C-B>
noremap <M-C-L> <C-L>
inoremap <M-C-L> <C-O><C-L>

" Ctrl-K changes to normal selection
vnoremap <C-K> v

" Ctrl-A is Select all
noremap <C-A> gg<Home>gh<C-O>G<S-End>
onoremap <C-A> <Esc>
inoremap <C-A> <C-O>gg<Home><C-O>gh<C-O>G<S-End>
"}}}

"{{{  Undo and Redo
" Ctrl-Z is Undo; not in cmdline though
noremap <C-Z> u
onoremap <C-Z> <Esc>
vnoremap <C-Z> <Esc>ugV
inoremap <C-Z> <C-O>u

" Ctrl-Y is Redo (although not repeat); not in cmdline though
noremap <C-Y> <C-R>
onoremap <C-Y> <Esc>
vnoremap <C-Y> <Esc><C-R>gV
inoremap <C-Y> <C-O><C-R>

" Use additional Alt for original Ctrl-Z and Ctrl-Y command
noremap <M-C-Z> <C-Z>
inoremap <M-C-Z> <C-O><C-Z>
noremap <M-C-Y> <C-Y>
inoremap <M-C-Y> <C-Y>

" Alt-Backspace is Undo; not in cmdline though
noremap <M-BS> u
onoremap <M-BS> <Esc>
vnoremap <M-BS> <Esc>ugV
inoremap <M-BS> <C-O>u

" Shift-Alt-Backspace is Redo (although not repeat); not in cmdline though
noremap <M-S-BS> <C-R>
onoremap <M-S-BS> <Esc>
vnoremap <M-S-BS> <Esc><C-R>gV
inoremap <M-S-BS> <C-O><C-R>
"}}}

"{{{  Find and Replace
" Ctrl-F is Find
noremap <C-F> /
onoremap <C-F> <Esc>
vnoremap <C-F> <Esc>/
inoremap <C-F> <C-O>/

" Use additional Alt for original Ctrl-F command
noremap <M-C-F> <C-F>
inoremap <M-C-F> <C-F>

" Ctrl-Shift-F3 is Find backwards
noremap <C-S-F3> ?
onoremap <C-S-F3> <Esc>
vnoremap <C-S-F3> <Esc>?
inoremap <C-S-F3> <C-O>?

" F3 is Repeat search
noremap <silent><F3> /<CR>
onoremap <F3> <Esc>
vnoremap <silent><F3> <Esc>/<CR>gV
inoremap <silent><F3> <C-O>/<CR>

" Shift-F3 is Repeat search backwards
noremap <silent><S-F3> ?<CR>
onoremap <S-F3> <Esc>
vnoremap <silent><S-F3> <Esc>?<CR>gV
inoremap <silent><S-F3> <C-O>?<CR>

" Ctrl-F3 is Unhighlight seach pattern in text
noremap <silent><C-F3> :nohlsearch<CR>
onoremap <C-F3> <Esc>
vnoremap <silent><C-F3> <Esc>:nohlsearch<CR>
inoremap <silent><C-F3> <C-O>:nohlsearch<CR>

" Ctrl-R is Replace globally on line or in selection
noremap <C-R> :s///g<Left><Left><Left>
onoremap <C-R> <Esc>
inoremap <C-R> <C-O>:s///g<Left><Left><Left>

" Shift-F2 is Replace first occurence on line or on each line in selection
noremap <S-F2> :s//<Left>
onoremap <S-F2> <Esc>
inoremap <S-F2> <C-O>:s//<Left>

" Ctrl-F2 is Replace globally in buffer
noremap <C-F2> :%s///g<Left><Left><Left>
onoremap <C-F2> <Esc>
vnoremap <C-F2> <Esc>:%s///g<Left><Left><Left>
inoremap <C-F2> <C-O>:%s///g<Left><Left><Left>

" Ctrl-Shift-F2 is Replace first occurence on each line in buffer
noremap <C-S-F2> :%s//<Left>
onoremap <C-S-F2> <Esc>
vnoremap <C-S-F2> <Esc>:%s//<Left>
inoremap <C-S-F2> <C-O>:%s//<Left>

" F2 is Repeat replacement
noremap <silent><F2> :s//~/&<CR>
onoremap <F2> <Esc>
vnoremap <silent><F2> <Esc>:s//~/&<CR>gV
inoremap <silent><F2> <C-O>:s//~/&<CR>
"}}}

"{{{  Manipulate indent
" Alt-Right is Increase indent
noremap <silent><M-Right> :><CR>
onoremap <M-Right> <Esc>
vnoremap <silent><M-Right> >gv
inoremap <silent><M-Right> <C-O>:><CR>

" Alt-Left is Decrease indent
noremap <silent><M-Left> :<<CR>
onoremap <M-Left> <Esc>
vnoremap <silent><M-Left> <gv
inoremap <silent><M-Left> <C-O>:<<CR>
"}}}

"{{{  Add and Subtract
" Ctrl-Alt-A is Add
noremap <M-C-A> <C-A>
inoremap <M-C-A> <C-O><C-A>

" Ctrl-Alt-S is Subtract
noremap <M-C-S> <C-X>
inoremap <M-C-S> <C-O><C-X>
"}}}

"{{{  Toggle case
" F4 is Toggle case
noremap <F4> ~
onoremap <F4> <Esc>
inoremap <F4> <C-O>~
"}}}

"{{{  Jump to match
" Ctrl-F11 is Jump to match
noremap <C-F11> %
onoremap <C-F11> <Esc>
inoremap <C-F11> <C-O>%
"}}}

"{{{  Call help
" Shift-F1 is Start help comand
noremap <S-F1> :help 
onoremap <S-F1> <Esc>
vnoremap <S-F1> <Esc>:help 
inoremap <S-F1> <C-O>:help 

"{{{  function <SID>ShowContextHelp(v, show)
" Show help for the word under the cursor
function <SID>ShowContextHelp(v, show)

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  if !a:v
    " Get word under the cursor
    let curword = matchstr(getline(line('.')), '\<\k*\%' . col('.') . 'c\k*\>')
  else
    " Get selection
    let curword = @z
  endif

  " Restore magic
  if !save_magic|setlocal nomagic|endif

  " Start help
  if a:show
    if curword == ''
      echohl ErrorMsg
      echomsg 'E349: No identifier under cursor'
      echohl None
    else
      let v:errmsg = ''
      silent! exe 'help ' . curword
      if v:errmsg != ""
        echohl ErrorMsg
        echomsg v:errmsg
        echohl None
      endif
    endif
  else
    if !a:v
      let @z = curword
    endif
  endif

endfunction
"}}}

" Ctrl-F1 is Context sensitive help
noremap <silent><C-F1> :call <SID>ShowContextHelp(0, 1)<CR>
onoremap <C-F1> <Esc>
vnoremap <silent><C-F1> "zy:call <SID>ShowContextHelp(1, 1)<CR>gV
inoremap <silent><C-F1> <C-O>:call <SID>ShowContextHelp(0, 1)<CR>

" Ctrl-Shift-F1 is Start help comand with context sensitive keyword
noremap <C-S-F1> :call <SID>ShowContextHelp(0, 0)<CR>:help <C-R>z
onoremap <C-S-F1> <Esc>
vnoremap <C-S-F1> "zy:help <C-R>z
inoremap <C-S-F1> <C-O>:call <SID>ShowContextHelp(0, 0)<CR><C-O>:help <C-R>z
"}}}

"{{{  Save file
" Ctrl-S is Save file
noremap <silent><C-S> :if expand("%") == ""\|browse confirm w\|else\|confirm w\|endif<CR>
onoremap <C-S> <Esc>
vnoremap <silent><C-S> <Esc>:if expand("%") == ""\|browse confirm w\|else\|confirm w\|endif<CR>
inoremap <silent><C-S> <C-O>:if expand("%") == ""\|browse confirm w\|else\|confirm w\|endif<CR>
cnoremap <silent><C-S> <C-C>:if expand("%") == ""\|browse confirm w\|else\|confirm w\|endif<CR>
"}}}

"{{{  Restore cpoptions
set cpo&
if 1
  let &cpoptions = s:save_cpo
  unlet s:save_cpo
endif
"}}}

"}}}


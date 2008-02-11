" Vim support file to improve the look & feel of folds (based on origami style)
"
" Maintainer:	Mario Schweigler <ms44@kent.ac.uk>
" Last Change:	23 April 2003

" ATTENTION: These scripts will ONLY work properly with swapfile switched on,
"            foldmethod=marker and WITHOUT manually setting the foldlevel, i.e.
"            without things like }}}1

" Only load this file one
if exists("b:did_foldingmacros")
  finish
endif
let b:did_foldingmacros = 1

"{{{  Settings
set foldmethod=marker
set foldmarker={{{,}}}
let g:_fold_showfoldlevel = 0
let g:_fold_expandemptyfoldtext = 1
let g:_fold_emptyfoldtext = '(FOLDED)'
let g:_fold_foldcommentmarker = 'COMMENT'
set foldopen=
set foldclose=
set foldcolumn=4
set fillchars-=fold:-
set foldtext=GetFoldText()
set statusline=%<%.1000f\ %.100{GetStatusLine(1)}%m%r\ %=%{GetStatusLine(0)}%P
"}}}

"{{{  Auto commands
augroup foldsyntax
  autocmd BufWinEnter * call SetFoldSyntax()
  autocmd BufWinEnter * call SetCommentstring()

  autocmd FileType * call SetFoldSyntax()
  autocmd FileType * call SetCommentstring()
augroup end

augroup foldcheckrecovery
  autocmd BufWinEnter * call <SID>RecoverFolds(1, '')
augroup end

augroup foldbufunload
  autocmd BufWinLeave * call <SID>UnloadFolds()
augroup end

augroup foldbuffilepost
  autocmd BufFilePost * call <SID>FoldUpdateSwapfileNames()
augroup end

augroup foldchangedshell
  autocmd FileChangedShell * call <SID>FoldChangedShell()
augroup end

augroup foldsavewholefile
  autocmd BufWriteCmd * call <SID>SaveWholeFile()
augroup end
"}}}

"{{{  User defined commands

" Create folds
command -range Foldcreate call <SID>CreateFold(<line1>, <line2>)

" Delete folds
command -range Folddel call <SID>DeleteFold(0, 0, <line1>, <line2>)
command Folddelall %Folddelrec
command -range Folddelrec call <SID>DeleteFold(1, 0, <line1>, <line2>)

" Eliminate folds
command -range Foldeliminate call <SID>DeleteFold(0, 1, <line1>, <line2>)
command Foldeliminateall %Foldeliminaterec
command -range Foldeliminaterec call <SID>DeleteFold(1, 1, <line1>, <line2>)

" Enter folds or selections
command -range Foldenter call <SID>EnterFold(0, <line1>, <line2>)
command -range Foldenterselection call <SID>EnterFold(1, <line1>, <line2>)

" Exit folds
command Foldexit call <SID>ExitFold()
command Foldexitall call <SID>ExitAllFolds()

" Describe folds with first non-empty line
command -range Folddescribe call <SID>DescribeFold(0, <line1>, <line2>)
command Folddescribeall %Folddescriberec
command -range Folddescriberec call <SID>DescribeFold(1, <line1>, <line2>)

" Toggle whether a fold is commented out
command -range Foldtogglecomment call <SID>ToggleFoldComment(<line1>, <line2>)

" Reinitialise folds
command Foldreinitialise set foldmethod=marker

" Origami mode
command Toggleorigamimode call <SID>ToggleOrigamiMode(0)
command Origamimodeoff call <SID>ToggleOrigamiMode(1)

" Toggle whether fold level is shown in status line
command Toggleshowfoldlevel call <SID>ToggleShowFoldLevel()

" Function to toggle whether an empty fold text will be expanded
command Toggleexpandemptyfoldtext call <SID>ToggleExpandEmptyFoldText()

" Recover folds after a crashed session
" Argument: Optionally the name of the .fold.info file from which to recover
command -nargs=? -complete=file Foldrecover call <SID>RecoverFolds(0, <q-args>)

"{{{  Shortcuts for the commands

command -range FC <line1>,<line2>Foldcreate

command -range FD <line1>,<line2>Folddel
command FDA Folddelall
command -range FDR <line1>,<line2>Folddelrec

command -range FDE <line1>,<line2>Foldeliminate
command FDEA Foldeliminateall
command -range FDER <line1>,<line2>Foldeliminaterec

command -range FE <line1>,<line2>Foldenter
command -range FES <line1>,<line2>Foldenterselection

command FX Foldexit
command FXA Foldexitall

command -range FDB <line1>,<line2>Folddescribe
command FDBA Folddescribeall
command -range FDBR <line1>,<line2>Folddescriberec

command -range FTC <line1>,<line2>Foldtogglecomment

command FRI Foldreinitialise
command Foldreinitialize Foldreinitialise " For our American friends ;)

command TOM Toggleorigamimode
command XOM Origamimodeoff
command TSF Toggleshowfoldlevel
command TEE Toggleexpandemptyfoldtext

command -nargs=? -complete=file FR Foldrecover <args>
"}}}

"}}}

"{{{  Keyboard mappings

"{{{  Create folds
" Alt-Insert is Create fold
noremap <M-Insert> 1\|V
onoremap <M-Insert> <Esc>
vnoremap <silent><M-Insert> :Foldcreate<CR>
inoremap <M-Insert> <C-O>1\|<C-O>V
"}}}

"{{{  Make selection of the fold easier by allowing Alt-Up and Alt-Down to extend selection
vnoremap <M-Up> <S-Up>
vnoremap <M-Down> <S-Down>
"}}}

"{{{  Delete folds
" Alt-Del is Delete fold 
noremap <silent><M-Del> :Folddel<CR>
onoremap <M-Del> <Esc>
vnoremap <silent><M-Del> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
      \gv:Folddel<CR>
inoremap <silent><M-Del> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
      \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
      \<C-O>:Folddel<CR>

" Shift-Alt-Del is Delete folds recursively
noremap <silent><M-S-Del> :Folddelrec<CR>
onoremap <M-S-Del> <Esc>
vnoremap <silent><M-S-Del> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
      \gv:Folddelrec<CR>
inoremap <silent><M-S-Del> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
      \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
      \<C-O>:Folddelrec<CR>

" Ctrl-Shift-Alt-Insert is Eliminate fold
noremap <silent><M-C-S-Insert> :Foldeliminate<CR>
onoremap <M-C-S-Insert> <Esc>
vnoremap <silent><M-C-S-Insert> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
      \gv:Foldeliminate<CR>
inoremap <silent><M-C-S-Insert> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
      \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
      \<C-O>:Foldeliminate<CR>
"}}}

"{{{  Open folds
" Alt-End is Open fold
noremap <silent><M-End> zo
onoremap <M-End> <Esc>
inoremap <silent><M-End> <C-O>zo

" Ctrl-Alt-End is Open all folds
noremap <silent><M-C-End> zR
onoremap <M-C-End> <Esc>
inoremap <silent><M-C-End> <C-O>zR

" Shift-Alt-End is Open folds recursively
noremap <silent><M-S-End> zO
onoremap <M-S-End> <Esc>
inoremap <silent><M-S-End> <C-O>zO

" Ctrl-Shift-Alt-End is Increase fold level
noremap <silent><M-C-S-End> zr
onoremap <M-C-S-End> <Esc>
inoremap <silent><M-C-S-End> <C-O>zr
"}}}

"{{{  Close folds
" Alt-PageDown is Close fold
noremap <silent><M-PageDown> zc
onoremap <M-PageDown> <Esc>
inoremap <silent><M-PageDown> <C-O>zc

" Ctrl-Alt-PageDown is Close all folds
noremap <silent><M-C-PageDown> zM
onoremap <M-C-PageDown> <Esc>
inoremap <silent><M-C-PageDown> <C-O>zM

" Shift-Alt-PageDown is Close folds recursively
noremap <silent><M-S-PageDown> zC
onoremap <M-S-PageDown> <Esc>
inoremap <silent><M-S-PageDown> <C-O>zC

" Ctrl-Shift-Alt-PageDown is Decrease fold level
noremap <silent><M-C-S-PageDown> zm
onoremap <M-C-S-PageDown> <Esc>
inoremap <silent><M-C-S-PageDown> <C-O>zm
"}}}

"{{{  Enter folds or selections
" Alt-Home is Enter fold or selection
noremap <silent><M-Home> :Foldenter<CR>
onoremap <M-Home> <Esc>
vnoremap <silent><M-Home> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
      \gv:Foldenterselection<CR>
inoremap <silent><M-Home> <C-O>:let b:_isininsertmode = 1\|let b:_vc = virtcol('.')\|let b:_ove = &ve\|
      \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
      \<C-O>:Foldenter<CR>
"}}}

"{{{  Exit folds
" Auxiliary command
command -range XYZAuxFXS call <SID>ExitFold()

" Alt-PageUp is Exit fold
noremap <silent><M-PageUp> :Foldexit<CR>
onoremap <M-PageUp> <Esc>
vnoremap <silent><M-PageUp> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
      \gv:XYZAuxFXS<CR>
inoremap <silent><M-PageUp> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
      \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
      \<C-O>:Foldexit<CR>

" Auxiliary command
command -range XYZAuxFXAS call <SID>ExitAllFolds()

" Ctrl-Alt-PageUp is Exit all folds
noremap <silent><M-C-PageUp> :Foldexitall<CR>
onoremap <M-C-PageUp> <Esc>
vnoremap <silent><M-C-PageUp> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
      \gv:XYZAuxFXAS<CR>
inoremap <silent><M-C-PageUp> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
      \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
      \<C-O>:Foldexitall<CR>
"}}}

"{{{  Describe folds with first non-empty line
" Ctrl-Alt-Insert is Describe fold with first non-empty line
noremap <silent><M-C-Insert> :Folddescribe<CR>
onoremap <M-C-Insert> <Esc>
vnoremap <silent><M-C-Insert> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
      \gv:Folddescribe<CR>
inoremap <silent><M-C-Insert> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
      \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
      \<C-O>:Folddescribe<CR>
"}}}

"{{{  Toggle whether a fold is commented out
" Shift-Alt-Insert is Toggle whether a fold is commented out
noremap <silent><M-S-Insert> :Foldtogglecomment<CR>
onoremap <M-S-Insert> <Esc>
vnoremap <silent><M-S-Insert> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
      \gv:Foldtogglecomment<CR>
inoremap <silent><M-S-Insert> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
      \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
      \<C-O>:Foldtogglecomment<CR>
"}}}

"{{{  View cursor line
" Ctrl-Alt-Home is View cursor line
noremap <silent><M-C-Home> zv
onoremap <M-C-Home> <Esc>
inoremap <silent><M-C-Home> <C-O>zv
"}}}

"{{{  Re-apply fold level
" Shift-Alt-Home is Re-apply fold level
noremap <silent><M-S-Home> zX
onoremap <M-S-Home> <Esc>
inoremap <silent><M-S-Home> <C-O>zX
"}}}

"{{{  Reinitialise folds
" Shift-Alt-PageUp is Reinitialise folds
noremap <silent><M-S-PageUp> :set foldmethod=marker<CR>
onoremap <M-S-PageUp> <Esc>
vnoremap <silent><M-S-PageUp> <Esc>:set foldmethod=marker<CR>
inoremap <silent><M-S-PageUp> <C-O>:set foldmethod=marker<CR>
"}}}

"{{{  Disable and enable folding
" Ctrl-Shift-Alt-Home is Disable folding
noremap <silent><M-C-S-Home> zn
onoremap <M-C-S-Home> <Esc>
inoremap <silent><M-C-S-Home> <C-O>zn

" Ctrl-Shift-Alt-PageUp is Enable folding
noremap <silent><M-C-S-PageUp> zN
onoremap <M-C-S-PageUp> <Esc>
inoremap <silent><M-C-S-PageUp> <C-O>zN
"}}}

"{{{  Origami mode
" F10 toggles origami mode
noremap <silent><F10> :Toggleorigamimode<CR>
onoremap <F10> <Esc>
vnoremap <silent><F10> <Esc>:Toggleorigamimode<CR>
inoremap <silent><F10> <C-O>:Toggleorigamimode<CR>

" Ctrl-F10 switches origami mode off
noremap <silent><C-F10> :Origamimodeoff<CR>
onoremap <C-F10> <Esc>
vnoremap <silent><C-F10> <Esc>:Origamimodeoff<CR>
inoremap <silent><C-F10> <C-O>:Origamimodeoff<CR>
"}}}

"{{{  Toggle whether fold level is shown
" Ctrl-F7 toggles whether fold level is shown
noremap <silent><C-F7> :Toggleshowfoldlevel<CR>
onoremap <C-F7> <Esc>
vnoremap <silent><C-F7> <Esc>:Toggleshowfoldlevel<CR>
inoremap <silent><C-F7> <C-O>:Toggleshowfoldlevel<CR>
"}}}

"{{{  Toggle whether empty fold text is expanded
" Ctrl-F8 toggles whether empty fold text is expanded
noremap <silent><C-F8> :Toggleexpandemptyfoldtext<CR>
onoremap <C-F8> <Esc>
vnoremap <silent><C-F8> <Esc>:Toggleexpandemptyfoldtext<CR>
inoremap <silent><C-F8> <C-O>:Toggleexpandemptyfoldtext<CR>
"}}}

"}}}

"{{{  function GetFoldText()
" Auxiliary function to get the fold text
function GetFoldText()
  let line = getline(v:foldstart)
  let myindent = indent(v:foldstart)

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  " Remove fold markers and fold level numbers
  let line = substitute(line, GetFoldMarker(2, 1) . '\d\=', '', 'g')

  " Check for all possible comments in the current language
  let i = 0
  while GetComment(&filetype, i) != ''

    " If there is no right comment
    if GetComment(&filetype, i + 1) == ''

      " Remove first occurence of left comment
      let subst = '\V' . GetComment(&filetype, i)
      let line = substitute(line,  subst , '', '')
    else

      " Remove all occurences of left and right comments
      let subst = '\V' . GetComment(&filetype, i) . '\|' . GetComment(&filetype, i + 1)
      let line = substitute(line,  subst , '', 'g')

    endif

    let i = i + 2
  endwhile

  " Get rid of initial spaces
  let line = substitute(line, '^\s*', '', 'g')

  " Expand empty fold lines if necessary
  if line =~ '^$' && g:_fold_expandemptyfoldtext
    let line = g:_fold_emptyfoldtext
  endif

  " Put three dots in front"
  let line = '...  ' . line
  " Set the indent right
  while myindent != 0
    let myindent = myindent - 1
    let line = ' ' . line
  endwhile

  " Restore magic
  if !save_magic|setlocal nomagic|endif

  return line
endfunction
"}}}

"{{{  function GetStatusLine(first)
" Auxiliary function to get parts of the status line
" Arguments: a:first is true for the fold info to be returned, and false for the ruler
function GetStatusLine(first)

  "{{{  First part
  if a:first

    "{{{  Fold level and enter level
    if exists('b:is_foldentered') && g:_fold_showfoldlevel
      let sl = '[FL ' . &foldlevel . '][EL ' . b:foldentered_level . '] '
    elseif exists('b:is_foldentered')
      let sl = '[Enter level = ' . b:foldentered_level . '] '
    elseif g:_fold_showfoldlevel
      let sl = '[Fold level = ' . &foldlevel . '] '
    else
      let sl = ''
    endif
    "}}}

    "{{{  origami mode
    if maparg('<Insert>', '') !~ '^$'
      if sl == ''
	let sl = ' '
      endif

      let sl = ']' . sl

      " Type of origami mode
      if maparg('<Insert>', 'n') == '1|V'
	let sl = 'Alt' . sl
      elseif maparg('<Insert>', 'n') == ':Folddescribe<CR>'
	let sl = 'Ctrl-Alt' . sl
      elseif maparg('<Insert>', 'n') == ':Foldtogglecomment<CR>'
	let sl = 'Shift-Alt' . sl
      else
	let sl = 'Ctrl-Shift-Alt' . sl
      endif

      let sl = '[origami:' . sl
    endif
    "}}}

    "{{{  File type and comments
    " File type
    if &filetype != ''
      let sl = sl . '[' . &filetype
    endif

    " Comments
    if g:_showcomments
      if &filetype != ''
	let sl = sl . ':'
      else
	let sl = sl . '['
      endif

      if GetComment(&filetype, 0) == ''
	let sl = sl . 'no comment'
      else
	let sl = sl . GetComment(&filetype, 0)
	if GetComment(&filetype, 1) != ''
	  let sl = sl . ',' . GetComment(&filetype, 1)
	endif
      endif
    endif

    if &filetype != '' || g:_showcomments
      let sl = sl . ']'
    endif
    "}}}

  "}}}

  "{{{  Last part
  else
    if &ruler
      let curline = line('.')
      let curcol = col('.')
      let curvirtcol = virtcol('.')

      if strlen(getline('.')) == 0
        let curcol = 0
      endif
      if line('$') == 1 && curcol == 0
        let curline = 0
      endif

      let sl = curline . ',' . curcol
      if curvirtcol != curcol
        let sl = sl . '-' . curvirtcol
      endif

      if &columns > 33
        let restspaces = 15 - strlen(sl)
      else
        let restspaces = &columns - 19 - strlen(sl)
      endif
      if restspaces < 1
        let restspaces = 1
      endif
      while restspaces > 0
        let sl = sl . ' '
        let restspaces = restspaces - 1
      endwhile

    else
      let sl = ''
    endif
  endif
  "}}}

  return sl

endfunction
"}}}

"{{{  function SetFoldSyntax()
" Auxiliary function to set the correct syntax highlighting for folds
function SetFoldSyntax()

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  " Always highlight 
  if GetFoldMarker(0, 0) !~ '\/' && GetFoldMarker(1, 0) !~ '\/'
    let delim = '/'
  elseif GetFoldMarker(0, 0) !~ '"' && GetFoldMarker(1, 0) !~ '"'
    let delim = '"'
  elseif GetFoldMarker(0, 0) !~ "'" && GetFoldMarker(1, 0) !~ "'"
    let delim = "'"
  elseif GetFoldMarker(0, 0) !~ '%' && GetFoldMarker(1, 0) !~ '%'
    let delim = '%'
  else
    let delim = '+'
  endif
  exe 'syn match FoldComment ' . delim . GetFoldMarker(2, 1) . '\(.*\S\)\=' . delim . ' contains=FoldNote'

  " Check for all possible comments in the current language
  let i = 0
  while GetComment(&filetype, i) != ''

    if GetComment(&filetype, i) !~ '\/' && GetFoldMarker(0, 0) !~ '\/' && GetFoldMarker(1, 0) !~ '\/'
      let delim = '/'
    elseif GetComment(&filetype, i) !~ '"' && GetFoldMarker(0, 0) !~ '"' && GetFoldMarker(1, 0) !~ '"'
      let delim = '"'
    elseif GetComment(&filetype, i) !~ "'" && GetFoldMarker(0, 0) !~ "'" && GetFoldMarker(1, 0) !~ "'"
      let delim = "'"
    elseif GetComment(&filetype, i) !~ '%' && GetFoldMarker(0, 0) !~ '%' && GetFoldMarker(1, 0) !~ '%'
      let delim = '%'
    else
      let delim = '+'
    endif

    let exestring1 = 'syn match FoldComment'
    let exestring2 = '\V' . GetComment(&filetype, i) . '\m.\{-0,}' . GetFoldMarker(2, 1)

    if GetComment(&filetype, i + 1) != ''
      let exestring2 = exestring2 . '.\{-0,}\V' . GetComment(&filetype, i + 1)
    else
      let exestring2 = exestring2 . '\(.*\S\)\='
    endif

    if &filetype == 'vim'
      exe exestring1 . 'Container ' . delim . '\s*' . exestring2 . delim . ' contains=FoldComment'
    endif

    exe exestring1 . ' ' . delim . exestring2  . delim . ' contains=FoldNote'

    let i = i + 2
  endwhile

  " Link to special comment
  hi link FoldComment SpecialComment

  " Link fold note to Todo
  exe 'syn keyword FoldNote ' . <SID>GetFoldCommentMarker(0) . ' contained'
  hi link FoldNote Todo

  " Restore magic
  if !save_magic|setlocal nomagic|endif

endfunction
"}}}

"{{{  function SetCommentstring()
" Auxiliary function to set the correct fold comment string
function SetCommentstring()
  let &commentstring = GetComment(&filetype, 0) . '%s' . GetComment(&filetype, 1)
endfunction
"}}}

"{{{  function GetFoldMarker(which, realexp)
" Auxiliary function to get the fold markers
" Arguments: a:which is 0 for the opener, 1 for the closer, 2 for both of them (ORed)
"            a:realexp is true if to be returned as a regular expression, false if to be returned plain
function GetFoldMarker(which, realexp)

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  let commapos = match(&foldmarker, ',')

  " Opener
  if a:which == 0
    let fm = strpart(&foldmarker, 0, commapos)
  " Closer
  elseif a:which == 1
    let fm = strpart(&foldmarker, commapos + 1)
  " Both
  else
    let fm = strpart(&foldmarker, 0, commapos) . '\|' . strpart(&foldmarker, commapos + 1)
  endif

  if a:realexp
    let fm = '\V\(' . fm . '\)\m'
  endif

  " Restore magic
  if !save_magic|setlocal nomagic|endif

  return fm

endfunction
"}}}

"{{{  function AdaptFileName(fn)
" Auxiliary function to adapt the a given file name depending on the platform
" Arguments: a:fn is the given file name
function AdaptFileName(fn)

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  " Adapt name
  if has('win16') || has('win32') || has('dos16') || has('dos32')
    let fn = substitute(a:fn, '\\ ', '\\\\ ', 'g')
  else
    let fn = substitute(a:fn, '\\', '\\\\', 'g')
    let fn = substitute(fn, '\*', '\\*', 'g')
    let fn = substitute(fn, ' ', '\\ ', 'g')
  endif

  " Restore magic
  if !save_magic|setlocal nomagic|endif

  return fn
endfunction
"}}}

"{{{  function <SID>GetFoldCommentMarker(realexp)
" Auxiliary function to get the fold comment marker
" Arguments: a:realexp is true if to be returned as a regular expression, false if to be returned plain
function <SID>GetFoldCommentMarker(realexp)

  let fcm = g:_fold_foldcommentmarker

  if a:realexp
    let fcm = '\V\(\<' . fcm . '\>\)\m'
  endif

  return fcm

endfunction
"}}}

"{{{  function <SID>GetSwapfileName()
" Auxiliary function to get the name of the current swap file
function <SID>GetSwapfileName()

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  let temp_reg_a = @a
  redir @a
  silent swapname
  redir end
  let swapfilename = @a
  let @a = temp_reg_a

  let swapfilename = strtrans(swapfilename)
  let swapfilename = substitute(swapfilename, '\^@', '', 'g')
  let swapfilename = substitute(swapfilename, '^\s*', '', 'g')

  " Restore magic
  if !save_magic|setlocal nomagic|endif

  return swapfilename
endfunction
"}}}

"{{{  function <SID>GetFoldContext(linestart, lineend)
" Auxiliary function to find the start or end of a folding context (i.e. without breaking fold boundaries)
" Arguments: a:linestart is the start of the selection
"            a:lineend is the end of the selection
function <SID>GetFoldContext(linestart, lineend)

  " NOTE: The terms opener and closer are always relative to the search direction!

  " Find start of folding context

  " Count openers and closers
  let openers = 0
  let closers = 0
  let i = a:linestart

  while i <= a:lineend

    let line = getline(i)

    " Count openers and closers in line
    let lo = 0
    let ms = 0
    while match(line, GetFoldMarker(2, 1), ms) != -1

      if matchstr(line, GetFoldMarker(2, 1), ms) == GetFoldMarker(0, 0)
        let lo = lo + 1
      else
        let lo = lo - 1
      endif

      let ms = matchend(line, GetFoldMarker(2, 1), ms)
    endwhile

    " Update figures
    let openers = openers + lo

    if openers < 0
      let closers = closers - openers
      let openers = 0
    endif

    let i = i + 1
  endwhile

  " Go back to equalise closers
  let oldclosers = closers
  let openers = 0
  let closers = 0
  let i = a:linestart - 1

  while i > 0 && closers < oldclosers

    let line = getline(i)

    " Count openers and closers in line
    let lo = 0
    let ms = 0
    while match(line, GetFoldMarker(2, 1), ms) != -1

      if matchstr(line, GetFoldMarker(2, 1), ms) == GetFoldMarker(1, 0)
        let lo = lo + 1
      else
        let lo = lo - 1
      endif

      let ms = matchend(line, GetFoldMarker(2, 1), ms)
    endwhile

    " Update figures
    let openers = openers + lo

    if openers < 0
      let closers = closers - openers
      let openers = 0
    endif

    let i = i - 1
  endwhile

  let fcstart = i + 1
  let fcstartexcess = closers - oldclosers

  " Find end of folding context

  " Count openers and closers
  let openers = 0
  let closers = 0
  let i = a:lineend

  while i >= a:linestart

    let line = getline(i)

    " Count openers and closers in line
    let lo = 0
    let ms = 0
    while match(line, GetFoldMarker(2, 1), ms) != -1

      if matchstr(line, GetFoldMarker(2, 1), ms) == GetFoldMarker(1, 0)
        let lo = lo + 1
      else
        let lo = lo - 1
      endif

      let ms = matchend(line, GetFoldMarker(2, 1), ms)
    endwhile

    " Update figures
    let openers = openers + lo

    if openers < 0
      let closers = closers - openers
      let openers = 0
    endif

    let i = i - 1
  endwhile

  " Go forward to equalise closers
  let oldclosers = closers
  let openers = 0
  let closers = 0
  let i = a:lineend + 1

  while i <= line('$') && closers < oldclosers

    let line = getline(i)

    " Count openers and closers in line
    let lo = 0
    let ms = 0
    while match(line, GetFoldMarker(2, 1), ms) != -1

      if matchstr(line, GetFoldMarker(2, 1), ms) == GetFoldMarker(0, 0)
        let lo = lo + 1
      else
        let lo = lo - 1
      endif

      let ms = matchend(line, GetFoldMarker(2, 1), ms)
    endwhile

    " Update figures
    let openers = openers + lo

    if openers < 0
      let closers = closers - openers
      let openers = 0
    endif

    let i = i + 1
  endwhile

  let fcend = i - 1
  let fcendexcess = closers - oldclosers

  return fcstart . ',' . fcend . ',' . fcstartexcess . ',' . fcendexcess

endfunction
"}}}

"{{{  function <SID>CreateFold(startsel, endsel)
" Function to create a fold
" Arguments: a:startsel is the first line of the selection
"            a:endsel is the last line of the selection
function <SID>CreateFold(startsel, endsel)

  " Stop if buffer is not modifiable
  if !&modifiable
    echohl ErrorMsg
    echomsg "E21: Cannot make changes, 'modifiable' is off"
    echohl None
    return
  endif

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  " Get fold context
  let fc = <SID>GetFoldContext(a:startsel, a:endsel)
  let fcstart = matchstr(fc, '\d\+') + 0
  let ms = matchend(fc, '\d\+')
  let fcend = matchstr(fc, '\d\+', ms) + 0
  let ms = matchend(fc, '\d\+', ms)
  let fcstartexcess = matchstr(fc, '-\=\d\+', ms) + 0
  let ms = matchend(fc, '-\=\d\+', ms)
  let fcendexcess = matchstr(fc, '-\=\d\+', ms) + 0

  " Save the indent of the new fold
  " (This is the SMALLEST indent of all lines)
  let found = 0
  let tempindent = 0
  let i = prevnonblank(fcend)
  while i >= fcstart
    if !found || indent(i) < tempindent
      let tempindent = indent(i)
    endif
    let found = 1
    let i = prevnonblank(i - 1)
  endwhile

  " Add fold closer

  " Remove excess markers in fcendline and put them in separate lines
  while fcendexcess > 0

    call setline(fcend, substitute(getline(fcend), '\(.*\)' . GetFoldMarker(1, 1), '\1', ''))
    call append(fcend, GetComment(&filetype, 0) . GetFoldMarker(1, 0) . GetComment(&filetype, 1))

    normal gV
    exe 'normal ' . (fcend + 1) . 'G'
    normal zv

    if tempindent > 0
      let oldsw = &sw
      exe 'setlocal sw=' . tempindent
      exe 'silent ' . (fcend + 1) . '>'
      exe 'setlocal sw=' . oldsw
    endif

    let fcendexcess = fcendexcess - 1
  endwhile

  " Put missing markers in separate lines
  while fcendexcess < 0

    call append(fcend, GetComment(&filetype, 0) . GetFoldMarker(1, 0) . GetComment(&filetype, 1))

    normal gV
    exe 'normal ' . (fcend + 1) . 'G'
    normal zv

    if tempindent > 0
      let oldsw = &sw
      exe 'setlocal sw=' . tempindent
      exe 'silent ' . (fcend + 1) . '>'
      exe 'setlocal sw=' . oldsw
    endif

    let fcendexcess = fcendexcess + 1
  endwhile

  " Add closer line
  call append(fcend, GetComment(&filetype, 0) . GetFoldMarker(1, 0) . GetComment(&filetype, 1))

  normal gV
  exe 'normal ' . (fcend + 1) . 'G'
  normal zv

  if tempindent > 0
    let oldsw = &sw
    exe 'setlocal sw=' . tempindent
    exe 'silent ' . (fcend + 1) . '>'
    exe 'setlocal sw=' . oldsw
  endif

  " Add fold opener

  " Remove excess markers in fcstartline and put them in separate lines
  while fcstartexcess > 0

    call setline(fcstart, substitute(getline(fcstart), GetFoldMarker(0, 1), '', ''))
    call append(fcstart - 1, GetComment(&filetype, 0) . GetFoldMarker(0, 0) . '  ' . GetComment(&filetype, 1))

    " Put cursor in new fcstart
    normal gV
    exe 'normal ' . fcstart . 'G'
    normal zv

    if tempindent > 0
      let oldsw = &sw
      exe 'setlocal sw=' . tempindent
      exe 'silent ' . (fcstart) . '>'
      exe 'setlocal sw=' . oldsw
    endif
    let fcstart = fcstart + 1

    let fcstartexcess = fcstartexcess - 1
  endwhile

  " Put missing markers in separate lines
  while fcstartexcess < 0

    call append(fcstart - 1, GetComment(&filetype, 0) . GetFoldMarker(0, 0) . '  ' . GetComment(&filetype, 1))

    " Put cursor in new fcstart
    normal gV
    exe 'normal ' . fcstart . 'G'
    normal zv

    if tempindent > 0
      let oldsw = &sw
      exe 'setlocal sw=' . tempindent
      exe 'silent ' . (fcstart) . '>'
      exe 'setlocal sw=' . oldsw
    endif

    let fcstartexcess = fcstartexcess + 1
  endwhile

  " Add opener line
  call append(fcstart - 1, GetComment(&filetype, 0) . GetFoldMarker(0, 0) . '  ' . GetComment(&filetype, 1))

  " Put cursor in new fcstart
  normal gV
  exe 'normal ' . fcstart . 'G'
  normal zv

  if tempindent > 0
    let oldsw = &sw
    exe 'setlocal sw=' . tempindent
    exe 'silent ' . (fcstart) . '>'
    exe 'setlocal sw=' . oldsw
  endif

  " Put cursor to be able to enter comment
  if GetComment(&filetype, 1) == ''
    startinsert!
  else
    call search('\V' . GetComment(&filetype, 1))
    startinsert
  endif 

  " Restore magic
  if !save_magic|setlocal nomagic|endif

endfunction
"}}}

"{{{  function <SID>DeleteFold(rec, elim, startsel, endsel)
" Function to delete a fold
" Arguments: a:rec is true to do it recursively
"            a:elim is true for eliminating the folds (i.e. removing also the fold comment), otherwise false
"            a:startsel is the first line of the selection
"            a:endsel is the last line of the selection
function <SID>DeleteFold(rec, elim, startsel, endsel)

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  let curline = a:startsel
  let foldfound = 0
  let foldlist = ''
  let minline = a:startsel
  let maxline = a:endsel

  while curline <= a:endsel

    " If there is no fold at the current line
    if foldlevel(curline) == 0

      if !foldfound && curline == a:endsel
        echohl ErrorMsg
        echomsg 'No fold found'
        echohl None
      endif

    else

      let foldfound = 1

      " Close current fold if it is open
      let foldwasopen = foldclosed(curline) == -1
      if foldwasopen
        exe curline . 'foldclose'
      endif

      " Get first and last line of current fold
      let firstfoldline = foldclosed(curline)
      let lastfoldline = foldclosedend(curline)

      " If this is a "one line fold"
      if foldclosed(curline) == -1

        if !a:rec
          " Add fold to list
          if match(foldlist, '\<' . curline . ',' . curline . '\>') == -1
            let foldlist = foldlist . '#' . curline . ',' . curline
          endif
        endif

      else

        " Re-open current fold if it was open
        if foldwasopen
          exe curline . 'foldopen'
        endif

        if !a:rec
          " Add fold to list
          if match(foldlist, '\<' . firstfoldline . ',' . lastfoldline . '\>') == -1
            let foldlist = foldlist . '#' . firstfoldline . ',' . lastfoldline
          endif
        else
          " Find minimum and maximum line
          if firstfoldline < minline
            let minline = firstfoldline
          endif
          if lastfoldline > maxline
            let maxline = lastfoldline
          endif
        endif

      endif
    endif  

    let curline = curline + 1
  endwhile

  " Stop if buffer is not modifiable
  if foldfound && !&modifiable
    echohl ErrorMsg
    echomsg "E21: Cannot make changes, 'modifiable' is off"
    echohl None
    " Restore virtualedit if necessary
    if exists('b:_ove')
      exe 'setlocal ve=' . b:_ove
      unlet b:_ove
    endif
    " Restore magic
    if !save_magic|setlocal nomagic|endif
    return
  endif

  if foldfound && a:rec

    exe minline . ',' . maxline . 'foldopen!'

    let curline = minline
    while curline <= maxline

      " If there is a fold at the current line
      if foldlevel(curline) != 0

        " Close current fold if it is open
        let foldwasopen = foldclosed(curline) == -1
        if foldwasopen
          exe curline . 'foldclose'
        endif

        " Get first and last line of current fold
        let firstfoldline = foldclosed(curline)
        let lastfoldline = foldclosedend(curline)

        " If this is a "one line fold"
        if foldclosed(curline) == -1

          " Add fold to list
          if match(foldlist, '\<' . curline . ',' . curline . '\>') == -1
            let foldlist = foldlist . '#' . curline . ',' . curline
          endif

        else
          " Re-open current fold if it was open
          if foldwasopen
            exe curline . 'foldopen'
          endif

          " Add fold to list
          if match(foldlist, '\<' . firstfoldline . ',' . lastfoldline . '\>') == -1
            let foldlist = foldlist . '#' . firstfoldline . ',' . lastfoldline
          endif

        endif
      endif  

      let curline = curline + 1
    endwhile
  endif

  if foldfound

    " Save original cursor position
    let originalline = line('.')
    let originalcol = virtcol('.')

    " Define comment search string
    let ecstring = '\V'
    let i = 0
    while GetComment(&filetype, i) != ''

      if ecstring != '\V'
        let ecstring = ecstring . '\|'
      endif

      let ecstring = ecstring . GetComment(&filetype, i)

      if !a:elim
        let ecstring = ecstring . '\s\*'
      else
        let ecstring = ecstring . '\.\{-}'
      endif

      if GetComment(&filetype, i + 1) != ''
        let ecstring = ecstring . GetComment(&filetype, i + 1)
      else
        let ecstring = ecstring . '\$'
      endif

      let i = i + 2
    endwhile
    let ecstring = '\(' . ecstring . '\)'

    " Remove fold markers
    let lineremovelist = ''
    let ms = 0
    while match(foldlist, '#', ms) != -1

      let firstfoldline = strpart(matchstr(foldlist, '#\d*', ms), 1) + 0
      let lastfoldline = strpart(matchstr(foldlist, ',\d*', match(foldlist, '#', ms)), 1) + 0

      " Get the lines
      let ffl = getline(firstfoldline)
      let lfl = getline(lastfoldline)

      if a:rec

        " Count openers and closers
        let openers = 0
        let ms2 = 0
        while match(ffl, GetFoldMarker(0, 1), ms2) != -1
          let openers = openers + 1
          let ms2 = matchend(ffl, GetFoldMarker(0, 1), ms2)
        endwhile
        let closers = 0
        let ms2 = 0
        while match(lfl, GetFoldMarker(1, 1), ms2) != -1
          let closers = closers + 1
          let ms2 = matchend(lfl, GetFoldMarker(1, 1), ms2)
        endwhile

        " How many markers to remove
        let numremove = openers
        if closers < openers
          let numremove = closers
        endif
      else
        " Remove only one pair of markers
        let numremove = 1
      endif

      " Remove the markers
      let i = 0
      while i < numremove

        " Remove right-most markers
        let ms2 = 0
        while match(ffl, GetFoldMarker(0, 1), ms2) != -1
          let laststart = match(ffl, GetFoldMarker(0, 1), ms2)
          let ms2 = matchend(ffl, GetFoldMarker(0, 1), ms2)
        endwhile

        " Define substitute start and replacement string
        if ffl =~ '\s*\%' . (laststart + 1) . 'c' . GetFoldMarker(0, 1) . '\s*$'
          let subst = '\s*'
          let repl = ''
        elseif laststart == 0 || ffl =~ '\s\+\%' . (laststart + 1) . 'c' . GetFoldMarker(0, 1)
          let subst = ''
          let repl = ''
        else
          let subst = ''
          let repl = ' '
        endif

        let ffl = substitute(ffl, subst . '\%' . (laststart + 1) . 'c' . GetFoldMarker(0, 1) . '\s*', repl, '')

        let ms2 = 0
        while match(lfl, GetFoldMarker(1, 1), ms2) != -1
          let laststart = match(lfl, GetFoldMarker(1, 1), ms2)
          let ms2 = matchend(lfl, GetFoldMarker(1, 1), ms2)
        endwhile

        " Define substitute start and replacement string
        if lfl =~ '\s*\%' . (laststart + 1) . 'c' . GetFoldMarker(1, 1) . '\s*$'
          let subst = '\s*'
          let repl = ''
        elseif laststart == 0 || lfl =~ '\s\+\%' . (laststart + 1) . 'c' . GetFoldMarker(1, 1)
          let subst = ''
          let repl = ''
        else
          let subst = ''
          let repl = ' '
        endif

        let lfl = substitute(lfl, subst . '\%' . (laststart + 1) . 'c' . GetFoldMarker(1, 1) . '\s*', repl, '')

        let i = i + 1
      endwhile

      " Remove comments
      if ecstring != '\(\V\)'
        while ffl =~ ecstring

          let ecstart = match(ffl, ecstring) 

          " Define substitute start and replacement string
          if ffl =~ '\s*\%' . (ecstart + 1) . 'c' . ecstring . '\s\*\$'
            let subst = '\s*'
            let repl = ''
          elseif ecstart == 0 || ffl =~ '\s\+\%' . (ecstart + 1) . 'c' . ecstring
            let subst = ''
            let repl = ''
          else
            let subst = ''
            let repl = ' '
          endif

          let ffl = substitute(ffl, subst . '\%' . (ecstart + 1) . 'c' . ecstring . '\s\*', repl, '')

        endwhile

        while lfl =~ ecstring

          let ecstart = match(lfl, ecstring) 

          " Define substitute start and replacement string
          if lfl =~ '\s*\%' . (ecstart + 1) . 'c' . ecstring . '\s\*\$'
            let subst = '\s*'
            let repl = ''
          elseif laststart == 0 || lfl =~ '\s\+\%' . (ecstart + 1) . 'c' . ecstring
            let subst = ''
            let repl = ''
          else
            let subst = ''
            let repl = ' '
          endif

          let lfl = substitute(lfl, subst . '\%' . (ecstart + 1) . 'c' . ecstring . '\s\*', repl, '')

        endwhile
      endif

      " Put back lines
      call setline(firstfoldline, ffl)
      call setline(lastfoldline, lfl)

      " Remember empty lines
      if ffl =~ '^$'
        if match(lineremovelist, '\<' . firstfoldline . '\>') == -1

          let ms2 = 0
          let startsmaller = -1
          while startsmaller == -1 && match(lineremovelist, '#', ms2) != -1

            let testnum = strpart(matchstr(lineremovelist, '#\d*', ms2), 1) + 0

            if testnum < firstfoldline
              let startsmaller = match(lineremovelist, '#', ms2)
            elseif match(lineremovelist, '#', matchend(lineremovelist, '#', ms2)) == -1
              let startsmaller = strlen(lineremovelist)
            endif

            let ms2 = matchend(lineremovelist, '#', ms2)
          endwhile

          if startsmaller == -1
            let lineremovelist = '#' . firstfoldline . lineremovelist
          else
            let lineremovelist = strpart(lineremovelist, 0, startsmaller) . '#' . firstfoldline . strpart(lineremovelist, startsmaller)
          endif
        endif
      endif

      if lfl =~ '^$'
        if match(lineremovelist, '\<' . lastfoldline . '\>') == -1

          let ms2 = 0
          let startsmaller = -1
          while startsmaller == -1 && match(lineremovelist, '#', ms2) != -1

            let testnum = strpart(matchstr(lineremovelist, '#\d*', ms2), 1) + 0

            if testnum < lastfoldline
              let startsmaller = match(lineremovelist, '#', ms2)
            elseif match(lineremovelist, '#', matchend(lineremovelist, '#', ms2)) == -1
              let startsmaller = strlen(lineremovelist)
            endif

            let ms2 = matchend(lineremovelist, '#', ms2)
          endwhile

          if startsmaller == -1
            let lineremovelist = '#' . lastfoldline . lineremovelist
          else
            let lineremovelist = strpart(lineremovelist, 0, startsmaller) . '#' . lastfoldline . strpart(lineremovelist, startsmaller)
          endif
        endif
      endif

      let ms = matchend(foldlist, '#', ms)
    endwhile

    " Delete empty lines
    let ms = 0
    while match(lineremovelist, '#', ms) != -1

      let removenum = strpart(matchstr(lineremovelist, '#\d*', ms), 1) + 0
      exe removenum . 'd'

      " Update original position
      if originalline == removenum
        let originalcol = 1
      elseif originalline > removenum
        let originalline = originalline - 1
      endif

      let ms = matchend(lineremovelist, '#', ms)
    endwhile

    " Put cursor on new position
    normal gV
    exe 'normal ' . originalline . 'G' . originalcol . '|'
  endif

  " Restore virtualedit if necessary
  if exists('b:_ove')
    exe 'setlocal ve=' . b:_ove
    unlet b:_ove
  endif

  " Restore magic
  if !save_magic|setlocal nomagic|endif

endfunction
"}}}

"{{{  function <SID>DescribeFold(rec, startsel, endsel)
" Function to describe a fold using the first non-empty line
" Arguments: a:rec is true to do it recursively
"            a:startsel is the first line of the selection
"            a:endsel is the last line of the selection
function <SID>DescribeFold(rec, startsel, endsel)

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  let curline = a:startsel
  let foldfound = 0
  let foldlist = ''
  let minline = a:startsel
  let maxline = a:endsel

  while curline <= a:endsel

    " If there is no fold at the current line
    if foldlevel(curline) == 0

      if !foldfound && curline == a:endsel
        echohl ErrorMsg
        echomsg 'No fold found'
        echohl None
      endif

    else

      " Close current fold if it is open
      let foldwasopen = foldclosed(curline) == -1
      if foldwasopen
        exe curline . 'foldclose'
      endif

      " Get first and last line of current fold
      let firstfoldline = foldclosed(curline)
      let lastfoldline = foldclosedend(curline)

      " If this is not a "one line fold"
      if foldclosed(curline) != -1

        let foldfound = 1

        " Re-open current fold if it was open
        if foldwasopen
          exe curline . 'foldopen'
        endif

        if !a:rec
          " Add fold to list
          if match(foldlist, '\<' . firstfoldline . ',' . lastfoldline . '\>') == -1
            let foldlist = foldlist . '#' . firstfoldline . ',' . lastfoldline
          endif
        else
          " Find minimum and maximum line
          if firstfoldline < minline
            let minline = firstfoldline
          endif
          if lastfoldline > maxline
            let maxline = lastfoldline
          endif
        endif

      endif
    endif

    let curline = curline + 1
  endwhile

  " Stop if buffer is not modifiable
  if foldfound && !&modifiable
    echohl ErrorMsg
    echomsg "E21: Cannot make changes, 'modifiable' is off"
    echohl None
    " Restore virtualedit if necessary
    if exists('b:_ove')
      exe 'setlocal ve=' . b:_ove
      unlet b:_ove
    endif
    " Restore magic
    if !save_magic|setlocal nomagic|endif
    return
  endif

  if foldfound && a:rec

    " Create list of open folds
    let openfoldlist = ''
    let curline = minline
    while curline <= maxline

      " If there is a fold at the current line
      if foldlevel(curline) != 0

        " Close current fold if it is open
        let foldwasopen = foldclosed(curline) == -1
        if foldwasopen
          exe curline . 'foldclose'
        endif

        " Get first and last line of current fold
        let firstfoldline = foldclosed(curline)
        let lastfoldline = foldclosedend(curline)

        " If this is not a "one line fold"
        if foldclosed(curline) != -1

          " Re-open current fold if it was open
          if foldwasopen
            exe curline . 'foldopen'

            " Add fold to open list
            if match(openfoldlist, '\<' . firstfoldline . '\>') == -1
              let openfoldlist = openfoldlist . '#' . firstfoldline
            endif
          endif

        endif
      endif  

      let curline = curline + 1
    endwhile

    " Open all folds in range
    exe minline . ',' . maxline . 'foldopen!'

    " Create list of folds
    let curline = minline
    while curline <= maxline

      " If there is a fold at the current line
      if foldlevel(curline) != 0

        " Close current fold if it is open
        let foldwasopen = foldclosed(curline) == -1
        if foldwasopen
          exe curline . 'foldclose'
        endif

        " Get first and last line of current fold
        let firstfoldline = foldclosed(curline)
        let lastfoldline = foldclosedend(curline)

        " If this is not a "one line fold"
        if foldclosed(curline) != -1

          " Re-open current fold if it was open
          if foldwasopen
            exe curline . 'foldopen'
          endif

          " Add fold to list
          if match(foldlist, '\<' . firstfoldline . ',' . lastfoldline . '\>') == -1
            let foldlist = foldlist . '#' . firstfoldline . ',' . lastfoldline
          endif

        endif
      endif  

      let curline = curline + 1
    endwhile

    " Close all folds in range
    exe minline . ',' . maxline . 'foldclose!'

    " Re-open previously open folds
    let ms = 0
    while match(openfoldlist, '#', ms) != -1
      let firstfoldline = strpart(matchstr(openfoldlist, '#\d*', ms), 1) + 0
      exe firstfoldline . 'foldopen'

      let ms = matchend(openfoldlist, '#', ms)
    endwhile

  endif

  if foldfound

    let ms = 0
    while match(foldlist, '#', ms) != -1

      let firstfoldline = strpart(matchstr(foldlist, '#\d*', ms), 1) + 0
      let lastfoldline = strpart(matchstr(foldlist, ',\d*', match(foldlist, '#', ms)), 1) + 0

      " If fold is not commented
      if getline(firstfoldline) !~ <SID>GetFoldCommentMarker(1)

        " Find first non-empty line after fold line
        let found = 0
        let i = firstfoldline + 1
        while !found && i < lastfoldline

          let line = getline(i)
          if line !~ '^\s*$\|' . GetFoldMarker(2, 1)

            " Check for all possible comments in the current language
            let j = 0
            while GetComment(&filetype, j) != ''

              " Remove everything from the first occurence of left comment
              if line =~ '\V' . GetComment(&filetype, j)
                let line = strpart(line, 0, match(line, '\V' . GetComment(&filetype, j)))
              endif

              " Remove everything before the last occurence of right comment
              if GetComment(&filetype, j + 1) != ''
                if line =~ '\V' . GetComment(&filetype, j + 1)
                  let line = strpart(line, matchend(line, '\V' . GetComment(&filetype, j + 1)))
                endif
              endif

              let j = j + 2
            endwhile

            " Remove excess spaces
            if line !~ '^\s*$'
              let found = i
              let line = substitute(line, '^\s*', '', '')
              let line = substitute(line, '\s*$', '', '')
            endif
          endif

          let i = i + 1
        endwhile

        " If non-empty line found
        if found

          " Get first fold line
          let ffl = getline(firstfoldline)

          " Find last fold marker
          let ms2 = 0
          while match(ffl, GetFoldMarker(2, 1), ms2) != -1

            let ms2 = matchend(ffl, GetFoldMarker(2, 1), ms2)
          endwhile

          " Get rest of the line from the first comment marker
          let reststart = -1
          let i = 0
          while GetComment(&filetype, i) != ''

            if match(ffl, '\V' . GetComment(&filetype, i), ms2) != -1
              let newrs = match(ffl, '\V' . GetComment(&filetype, i), ms2)
              if newrs < reststart || reststart == -1
                let reststart = newrs
              endif
            endif
            if GetComment(&filetype, i + 1) != ''
              if match(ffl, '\V' . GetComment(&filetype, i + 1), ms2) != -1
                let newrs = match(ffl, '\V' . GetComment(&filetype, i + 1), ms2)
                if newrs < reststart || reststart == -1
                  let reststart = newrs
                endif
              endif
            endif  

            let i = i + 2
          endwhile

          if reststart == -1
            let reststart = ''
          else
            let reststart = strpart(ffl, reststart)
          endif

          " Delete everything between the last fold marker and the first comment marker and put descriptor in between
          let ffl = strpart(ffl, 0, ms2) . '  ' . line . reststart
          call setline(firstfoldline, ffl)

        endif
      endif

      let ms = matchend(foldlist, '#', ms)
    endwhile
  endif

  " Restore virtualedit if necessary
  if exists('b:_ove')
    exe 'setlocal ve=' . b:_ove
    unlet b:_ove
  endif

  " Restore magic
  if !save_magic|setlocal nomagic|endif

endfunction
"}}}

"{{{  function <SID>ToggleFoldComment(startsel, endsel)
" Function to toggle whether a fold is commented out
" Arguments: a:startsel is the first line of the selection
"            a:endsel is the last line of the selection
function <SID>ToggleFoldComment(startsel, endsel)

  " Stop if no comments are defined for current file type
  if GetComment(&filetype, 0) == ''
    echohl ErrorMsg
    echomsg "Error: No comments defined for this file type"
    echohl None
    return
  endif

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  let curline = a:startsel
  let foldfound = 0
  let foldlist = ''
  let minline = a:startsel
  let maxline = a:endsel

  while curline <= a:endsel

    " If there is no fold at the current line
    if foldlevel(curline) == 0

      if !foldfound && curline == a:endsel
        echohl ErrorMsg
        echomsg 'No fold found'
        echohl None
      endif

    else

      " Close current fold if it is open
      let foldwasopen = foldclosed(curline) == -1
      if foldwasopen
        exe curline . 'foldclose'
      endif

      " Get first and last line of current fold
      let firstfoldline = foldclosed(curline)
      let lastfoldline = foldclosedend(curline)

      " If this is not a "one line fold"
      if foldclosed(curline) != -1

        let foldfound = 1

        " Re-open current fold if it was open
        if foldwasopen
          exe curline . 'foldopen'
        endif

        " Check foldlist for containing and contained folds
        let oldfoldlist = foldlist
        let foldlist = ''
        let ms = 0
        while match(oldfoldlist, '#', ms) != -1

          let oldfirstfoldline = strpart(matchstr(oldfoldlist, '#\d*', ms), 1) + 0
          let oldlastfoldline = strpart(matchstr(oldfoldlist, ',\d*', match(oldfoldlist, '#', ms)), 1) + 0

          " Remove contained folds from foldlist
          if !(oldfirstfoldline >= firstfoldline && oldlastfoldline <= lastfoldline)
            let foldlist = foldlist . '#' . oldfirstfoldline . ',' . oldlastfoldline
          endif

          " Adapt to containing folds
          if oldfirstfoldline <= firstfoldline && oldlastfoldline >= lastfoldline
            let firstfoldline = oldfirstfoldline
            let lastfoldline = oldlastfoldline
          endif

          let ms = matchend(oldfoldlist, '#', ms)
        endwhile

        " Add fold to list
        if match(foldlist, '\<' . firstfoldline . ',' . lastfoldline . '\>') == -1
          let foldlist = foldlist . '#' . firstfoldline . ',' . lastfoldline
        endif

      endif
    endif

    let curline = curline + 1
  endwhile

  " Stop if buffer is not modifiable
  if foldfound && !&modifiable
    echohl ErrorMsg
    echomsg "E21: Cannot make changes, 'modifiable' is off"
    echohl None
    " Restore virtualedit if necessary
    if exists('b:_ove')
      exe 'setlocal ve=' . b:_ove
      unlet b:_ove
    endif
    " Restore magic
    if !save_magic|setlocal nomagic|endif
    return
  endif

  if foldfound

    " Save original cursor position
    let originalline = line('.')
    let originalcol = virtcol('.')

    let ms = 0
    while match(foldlist, '#', ms) != -1

      let firstfoldline = strpart(matchstr(foldlist, '#\d*', ms), 1) + 0
      let lastfoldline = strpart(matchstr(foldlist, ',\d*', match(foldlist, '#', ms)), 1) + 0

      " Save the indent of the current fold
      " (This is the SMALLEST indent of all lines in the fold)
      let found = 0
      let tempindent = 0
      let i = prevnonblank(lastfoldline)
      while i >= firstfoldline
        if !found || indent(i) < tempindent
          let tempindent = indent(i)
        endif
        let found = 1
        let i = prevnonblank(i - 1)
      endwhile

      " Find out whether the current fold is commented or not
      let ffl = getline(firstfoldline)
      let iscommented = ffl =~ <SID>GetFoldCommentMarker(1)

      " Toggle the fold comment marker
      if iscommented
        " Remove all fold comment markers
        while ffl =~ <SID>GetFoldCommentMarker(1)

          let thestart = match(ffl, <SID>GetFoldCommentMarker(1))

          " Define substitute start and replacement string
          if ffl =~ '\s*\%' . (thestart + 1) . 'c' . <SID>GetFoldCommentMarker(1) . '\s*$'
            let subst = '\s*'
            let repl = ''
          elseif thestart == 0 || ffl =~ '\s\+\%' . (thestart + 1) . 'c' . <SID>GetFoldCommentMarker(1)
            let subst = ''
            let repl = ''
          else
            let subst = ''
            let repl = ' '
          endif

          let ffl = substitute(ffl, subst . '\%' . (thestart + 1) . 'c' . <SID>GetFoldCommentMarker(1) . '\s*', repl, '')
        endwhile

        if ffl =~ GetFoldMarker(2, 1) . '$'
          let ffl = ffl . '  '
        endif

      else
        " Add fold comment marker
        let reststart = matchend(ffl, GetFoldMarker(0, 1) . '\s*')
        let therest = strpart(ffl, reststart)
        if therest != ''
          let therest = ' ' . therest
        endif
        let ffl = substitute(strpart(ffl, 0, reststart), '\s*$', '', '') . '  ' . <SID>GetFoldCommentMarker(0) . therest
      endif
      call setline(firstfoldline, ffl)

      " Toggle comments
      call CommentLines(tempindent, iscommented, 1, firstfoldline, lastfoldline)

      let ms = matchend(foldlist, '#', ms)
    endwhile

    " Put cursor on new position
    normal gV
    exe 'normal ' . originalline . 'G' . originalcol . '|'
  endif

  " Restore virtualedit if necessary
  if exists('b:_ove')
    exe 'setlocal ve=' . b:_ove
    unlet b:_ove
  endif

  " Restore magic
  if !save_magic|setlocal nomagic|endif

endfunction
"}}}

"{{{  function <SID>EnterFold(sel, startsel, endsel)
" Function to enter a fold or a selection
" Arguments: a:sel is true to enter a selection and false to enter a fold
"            a:startsel is the first line of the selection
"            a:endsel is the last line of the selection
function <SID>EnterFold(sel, startsel, endsel)

  " Save current cursor position
  let curline = line('.')
  let curcol = virtcol('.')

  " Stop if swap file is switched off
  if !&swapfile
    echohl ErrorMsg
    echomsg 'swapfile must be turned on'
    echohl None
    " Restore virtualedit if necessary
    if exists('b:_ove')
      exe 'setlocal ve=' . b:_ove
      unlet b:_ove
    endif
    if exists('b:_isininsertmode')
      unlet b:_isininsertmode
    endif
    return
  endif

  if a:sel

    " Ensure magic is on
    let save_magic = &magic
    setlocal magic

    " Get fold context
    let fc = <SID>GetFoldContext(a:startsel, a:endsel)
    let fcstart = matchstr(fc, '\d\+') + 0
    let ms = matchend(fc, '\d\+')
    let fcend = matchstr(fc, '\d\+', ms) + 0

    let firstfoldline = fcstart
    let lastfoldline = fcend

  else

    " Stop if there is no fold
    if foldlevel(a:startsel) == 0
      echohl ErrorMsg
      echomsg 'No fold found'
      echohl None
      " Restore virtualedit if necessary
      if exists('b:_ove')
        exe 'setlocal ve=' . b:_ove
        unlet b:_ove
      endif
      if exists('b:_isininsertmode')
        unlet b:_isininsertmode
      endif
      return
    endif

    " Close current fold if it is open
    let foldwasopen = foldclosed(a:startsel) == -1
    if foldwasopen
      foldclose
    endif

    " Get first and last line of current fold
    let firstfoldline = foldclosed(a:startsel)
    let lastfoldline = foldclosedend(a:startsel)

    " If this is a "one line fold"
    if foldclosed(a:startsel) == -1
      echohl ErrorMsg
      echomsg "Error: Can't enter this fold"
      echohl None
      " Restore virtualedit if necessary
      if exists('b:_ove')
        exe 'setlocal ve=' . b:_ove
        unlet b:_ove
      endif
      if exists('b:_isininsertmode')
        unlet b:_isininsertmode
      endif
      return
    endif

    " Ensure magic is on
    let save_magic = &magic
    setlocal magic
  endif

  " Save the indent of the current fold
  " (This is the SMALLEST indent of all lines in the fold)
  let found = 0
  let tempindent = 0
  let i = prevnonblank(lastfoldline)
  while i >= firstfoldline
    if !found || indent(i) < tempindent
      let tempindent = indent(i)
    endif
    let found = 1
    let i = prevnonblank(i - 1)
  endwhile

  " Stop if fold spreads over entire file and indent is zero
  if ((firstfoldline == 1) && (lastfoldline == line('$'))) && tempindent == 0

    if !a:sel
      foldopen
    endif

    " Restore magic
    if !save_magic|setlocal nomagic|endif

    if a:sel
      echohl WarningMsg
      echomsg 'Selection spreads over entire buffer, therefore not entered'
      echohl None
    elseif foldwasopen
      echohl ErrorMsg
      echomsg 'No fold found'
      echohl None
    else
      echohl WarningMsg
      echomsg 'Fold not entered, just opened'
      echohl None
      " Restore cursor position
      exe 'normal ' . curline . 'G' . curcol . '|'
    endif
    " Restore virtualedit if necessary
    if exists('b:_ove')
      exe 'setlocal ve=' . b:_ove
      unlet b:_ove
    endif
    if exists('b:_isininsertmode')
      unlet b:_isininsertmode
    endif
    return
  endif

  " If function was called by pressing mapped key in insert mode
  " This is necessary to ensure un-undo-ability!
  if exists('b:_isininsertmode')

    unlet b:_isininsertmode

    "Stop if fold was open
    if foldwasopen
      " Restore magic
      if !save_magic|setlocal nomagic|endif

      echohl MoreMsg
      echomsg 'Preparing fold entry. Press Alt-Home again to enter fold.'
      echohl None

      " Restore virtualedit if necessary
      if exists('b:_ove')
        exe 'setlocal ve=' . b:_ove
        unlet b:_ove
      endif
      return

    endif
  endif

  " Ensure backup is off
  let save_backup = &backup
  setlocal nobackup

  " Save the current fold level
  let tempfoldlevel = &foldlevel

  " Calculate new foldlevel
  let newfoldlevel = tempfoldlevel - foldlevel(firstfoldline) + 1

  " Don't create alternate files
  let save_cpo = &cpoptions
  setlocal cpoptions-=aA

  " We can't undo this!
  let save_ul = &undolevels
  setlocal undolevels=-1

  " Ensure readonly is off
  let save_ro = &readonly
  setlocal noreadonly

  " Ensure swapfile exists if option is switched on
  if save_ro
    let &swapfile = &swapfile
  endif

  " Ensure modifiable is on
  let save_modifiable = &modifiable
  setlocal modifiable

  " Save modified flag
  let curmodified = &modified

  " If we have not entered a fold yet
  if !exists('b:is_foldentered')

    " Set flag that we entered a fold
    let b:is_foldentered = 1
    " This is the first entered fold
    let b:foldentered_level = 1
  else
    " Increase the enter level
    let b:foldentered_level = b:foldentered_level + 1
  endif

  " Get name of the swap file and save it in the buffer
  if b:foldentered_level == 1
    let b:foldentered_swapfilename = <SID>GetSwapfileName()
  endif

  " Save the current indent, fold level and line offset in the correct variables
  exe 'let b:foldentered_indent_' . b:foldentered_level . ' = tempindent'
  exe 'let b:foldentered_foldlevel_' . b:foldentered_level . ' = tempfoldlevel'
  exe 'let b:foldentered_lineoffset_' . b:foldentered_level . ' = firstfoldline - 1'

  " Shift the fold to the left
  if tempindent > 0
    let oldsw = &sw
    exe 'setlocal sw=' . tempindent
    exe 'silent ' . firstfoldline . ',' . lastfoldline . '<'
    exe 'setlocal sw=' . oldsw
  endif

  " Shift non-fold areas to their normal indent
  if b:foldentered_level > 1
    if b:foldentered_indent_sum > 0
      let oldsw = &sw
      exe 'setlocal sw=' . b:foldentered_indent_sum
      if firstfoldline > 1
        exe 'silent 1,' . (firstfoldline - 1) . '>'
      endif
      if lastfoldline < line('$')
        exe 'silent ' . (lastfoldline + 1) . ',' . line('$') . '>'
      endif
      exe 'setlocal sw=' . oldsw
    endif
  endif

  " Calculate total indent and total line offset of current fold
  if b:foldentered_level == 1
    let b:foldentered_indent_sum = tempindent
    let b:foldentered_lineoffset_sum = firstfoldline - 1
  else
    let b:foldentered_indent_sum = b:foldentered_indent_sum + tempindent
    let b:foldentered_lineoffset_sum = b:foldentered_lineoffset_sum + firstfoldline - 1
  endif

  " Put non-fold areas in special swap files
  if firstfoldline > 1
    exe 'silent 1,' . (firstfoldline - 1) . 'write! ' . AdaptFileName(b:foldentered_swapfilename) . '.fold.' . b:foldentered_level . '.pre'
  else
    call delete(b:foldentered_swapfilename . '.fold.' . b:foldentered_level . '.pre')
  endif
  if lastfoldline < line('$')
    exe 'silent ' . (lastfoldline + 1) . ',' . line('$') . 'write! ' . AdaptFileName(b:foldentered_swapfilename) . '.fold.' . b:foldentered_level . '.post'
  else
    call delete(b:foldentered_swapfilename . '.fold.' . b:foldentered_level . '.post')
  endif

  " Save current enter level and total indent in special file
  call append(0, b:foldentered_level)
  call append(1, b:foldentered_indent_sum)
  exe 'silent 1,2write! ' . AdaptFileName(b:foldentered_swapfilename) . '.fold.info'

  " Remove non-fold areas
  if lastfoldline + 2 < line('$')
    exe 'silent ' . (lastfoldline + 3) . ',' . line('$') . 'd _'
  endif
  exe 'silent 1,' . (firstfoldline + 1) . 'd _'

  " Set new fold level
  setlocal foldmethod=marker
  if !foldlevel(1)
    let newfoldlevel = newfoldlevel - 1
  endif
  exe 'setlocal foldlevel=' . newfoldlevel

  " Calculate new cursor position
  if curline >= firstfoldline && curline <= lastfoldline
    let curline = curline - firstfoldline + 1
    let curcol = curcol - tempindent
    if curcol < 1|let curcol = 1|endif
  else
    let curline = 1
    let curcol = 1
  endif

  " Put cursor on new position
  normal gV
  exe 'normal ' . curline . 'G' . curcol . '|'

  " Open fold
  if !a:sel
    foldopen
  endif

  " Save new state in swap file
  silent preserve

  " Back to normal undo behaviour
  exe 'setlocal undolevels=' . save_ul

  " Restore cpoptions
  exe 'setlocal cpoptions=' . save_cpo

  " Restore modified flag
  if !curmodified|setlocal nomodified|endif

  " Restore magic
  if !save_magic|setlocal nomagic|endif

  " Restore backup
  if save_backup|setlocal backup|endif

  " Restore readonly
  if save_ro|setlocal readonly|endif

  " Restore modifiable
  if !save_modifiable|setlocal nomodifiable|endif

  " Restore virtualedit if necessary
  if exists('b:_ove')
    exe 'setlocal ve=' . b:_ove
    unlet b:_ove
  endif

  if a:sel
    echomsg 'Selection entered'
  else
    echomsg 'Fold entered'
  endif

endfunction
"}}}

"{{{  function <SID>ExitFold()
" Function to exit a fold
function <SID>ExitFold()

  " Save current cursor position
  let curline = line('.')
  let curcol = virtcol('.')

  " Stop if we have not entered a fold
  if !exists('b:is_foldentered')
    echohl ErrorMsg
    echomsg 'Not inside a fold'
    echohl None
    " Restore virtualedit if necessary
    if exists('b:_ove')
      exe 'setlocal ve=' . b:_ove
      unlet b:_ove
    endif
    return
  endif

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  " Ensure backup is off
  let save_backup = &backup
  setlocal nobackup

  " Don't create alternate files
  let save_cpo = &cpoptions
  setlocal cpoptions-=aA

  " We can't undo this!
  let save_ul = &undolevels
  setlocal undolevels=-1
  silent! undo
  silent! undo
  silent! undo
  silent! undo

  " Ensure readonly is off
  let save_ro = &readonly
  setlocal noreadonly

  " Ensure modifiable is on
  let save_modifiable = &modifiable
  setlocal modifiable

  " Save modified flag
  let curmodified = &modified

  " Save whether the first line is still the start of a fold
  let firstlinestillfold = foldlevel(1)

  " Get indent of current fold and saved fold level from the correct variables
  exe 'let tempindent = b:foldentered_indent_' . b:foldentered_level
  exe 'let tempfoldlevel = b:foldentered_foldlevel_' . b:foldentered_level
  exe 'let templineoffset = b:foldentered_lineoffset_' . b:foldentered_level
  " Unlet saved variables
  exe 'unlet b:foldentered_indent_' . b:foldentered_level
  exe 'unlet b:foldentered_foldlevel_' . b:foldentered_level
  exe 'unlet b:foldentered_lineoffset_' . b:foldentered_level

  " Calculate new total indent and line offset
  let b:foldentered_indent_sum = b:foldentered_indent_sum - tempindent
  let b:foldentered_lineoffset_sum = b:foldentered_lineoffset_sum - templineoffset

  " Shift current fold to normal level
  if tempindent > 0
    let oldsw = &sw
    exe 'setlocal sw=' . tempindent
    silent % >
    exe 'setlocal sw=' . oldsw
  endif

  " Save the length of the current fold
  let curfoldlength = line('$')

  " Read in pre-fold area from special swap file
  let foldfilename = b:foldentered_swapfilename . '.fold.' . b:foldentered_level . '.pre'
  if filereadable(foldfilename)
    exe 'silent 0 read ' . AdaptFileName(foldfilename)
    call delete(foldfilename)
  endif

  " Calculate  first and last line of current fold
  let lastfoldline = line('$')
  let firstfoldline = lastfoldline - curfoldlength + 1

  " Read in post-fold area from special swap file
  let foldfilename = b:foldentered_swapfilename . '.fold.' . b:foldentered_level . '.post'
  if filereadable(foldfilename)
    exe 'silent $ read ' . AdaptFileName(foldfilename)
    call delete(foldfilename)
  endif

  " Shift non-fold areas to their normal indent
  if b:foldentered_indent_sum > 0

    silent! foldopen!

    let oldsw = &sw
    exe 'setlocal sw=' . b:foldentered_indent_sum
    if firstfoldline > 1
      exe 'silent 1,' . (firstfoldline - 1) . '<'
    endif
    if lastfoldline < line('$')
      exe 'silent ' . (lastfoldline + 1) . ',' . line('$') . '<'
    endif
    exe 'setlocal sw=' . oldsw
  endif

  " Decrease the enter level
  let b:foldentered_level = b:foldentered_level - 1

  " If we are not in an entered fold anymore
  if b:foldentered_level == 0

    " Delete info file
    call delete(b:foldentered_swapfilename . '.fold.info')

    " Unlet special variables
    unlet b:is_foldentered
    unlet b:foldentered_swapfilename
    unlet b:foldentered_level
    unlet b:foldentered_indent_sum
    unlet b:foldentered_lineoffset_sum

  else
    " Save current enter level and total indent in special file
    call append(0, b:foldentered_level)
    call append(1, b:foldentered_indent_sum)
    exe 'silent 1,2write! ' . AdaptFileName(b:foldentered_swapfilename) . '.fold.info'
    silent 1,2 d _
  endif

  " Restore fold level
  setlocal foldmethod=marker
  exe 'setlocal foldlevel=' . tempfoldlevel

  " Put cursor on beginning of fold
  exe 'normal ' . firstfoldline . 'G'

  " Ensure that current fold is closed, but surrounding fold is open
  let foldleveldiff = foldlevel(firstfoldline) - tempfoldlevel - 1

  if firstlinestillfold
    if foldleveldiff > 0
      exe 'normal ' . foldleveldiff . 'zo'
    elseif foldleveldiff < 0
      exe firstfoldline . ',' . lastfoldline . 'foldclose'
    endif
  else
    let foldleveldiff = foldleveldiff + 1
    if foldleveldiff > 0
      exe 'normal ' . foldleveldiff . 'zo'
    endif
  endif

  " Calculate new cursor position
  let curline = curline + firstfoldline - 1
  let curcol = curcol + tempindent

  " Put cursor on new position
  normal gV
  exe 'normal ' . curline . 'G' . curcol . '|'

  " Save new state in swap file
  if &swapfile
    silent preserve
  endif

  " Back to normal undo behaviour
  exe 'setlocal undolevels=' . save_ul

  " Restore cpoptions
  exe 'setlocal cpoptions=' . save_cpo

  " Restore modified flag
  if !curmodified|setlocal nomodified|endif

  " Restore magic
  if !save_magic|setlocal nomagic|endif

  " Restore backup
  if save_backup|setlocal backup|endif

  " Restore readonly
  if save_ro|setlocal readonly|endif

  " Restore modifiable
  if !save_modifiable|setlocal nomodifiable|endif

  " Restore virtualedit if necessary
  if exists('b:_ove')
    exe 'setlocal ve=' . b:_ove
    unlet b:_ove
  endif

  echomsg 'Fold left'

endfunction
"}}}

"{{{  function <SID>ExitAllFolds()
" Function to exit all entered folds
function <SID>ExitAllFolds()

  " Save current cursor position
  let curline = line('.')
  let curcol = virtcol('.')

  " Stop if we have not entered a fold
  if !exists('b:is_foldentered')
    echohl ErrorMsg
    echomsg 'Not inside a fold'
    echohl None
    " Restore virtualedit if necessary
    if exists('b:_ove')
      exe 'setlocal ve=' . b:_ove
      unlet b:_ove
    endif
    return
  endif

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  " Ensure backup is off
  let save_backup = &backup
  setlocal nobackup

  " Don't create alternate files
  let save_cpo = &cpoptions
  setlocal cpoptions-=aA

  " We can't undo this!
  let save_ul = &undolevels
  setlocal undolevels=-1
  silent! undo
  silent! undo
  silent! undo
  silent! undo

  " Ensure readonly is off
  let save_ro = &readonly
  setlocal noreadonly

  " Ensure modifiable is on
  let save_modifiable = &modifiable
  setlocal modifiable

  " Save modified flag
  let curmodified = &modified

  " Save whether the first line is still the start of a fold
  let firstlinestillfold = foldlevel(1)

  " Get indent of current fold and saved fold level from the correct variables
  let tempindent = b:foldentered_indent_sum
  let tempfoldlevel = b:foldentered_foldlevel_1

  " Unlet saved variables
  let i = 0
  while i < b:foldentered_level
    let i = i + 1

    exe 'unlet b:foldentered_indent_' . i
    exe 'unlet b:foldentered_foldlevel_' . i
    exe 'unlet b:foldentered_lineoffset_' . i
  endwhile

  " Shift current fold to normal level
  if tempindent > 0
    let oldsw = &sw
    exe 'setlocal sw=' . tempindent
    silent % >
    exe 'setlocal sw=' . oldsw
  endif

  " Save the length of the current fold
  let curfoldlength = line('$')

  " Read in pre-fold area from special swap file
  let i = b:foldentered_level + 1
  while i > 1
    let i = i - 1

    let foldfilename = b:foldentered_swapfilename . '.fold.' . i . '.pre'
    if filereadable(foldfilename)
      exe 'silent 0 read ' . AdaptFileName(foldfilename)
      call delete(foldfilename)
    endif
  endwhile

  " Calculate  first and last line of current fold
  let lastfoldline = line('$')
  let firstfoldline = lastfoldline - curfoldlength + 1

  " Read in post-fold area from special swap file
  let i = b:foldentered_level + 1
  while i > 1
    let i = i - 1

    let foldfilename = b:foldentered_swapfilename . '.fold.' . i . '.post'
    if filereadable(foldfilename)
      exe 'silent $ read ' . AdaptFileName(foldfilename)
      call delete(foldfilename)
    endif
  endwhile

  " Delete info file
  call delete(b:foldentered_swapfilename . '.fold.info')

  " Unlet special variables
  unlet b:is_foldentered
  unlet b:foldentered_swapfilename
  unlet b:foldentered_level
  unlet b:foldentered_indent_sum
  unlet b:foldentered_lineoffset_sum

  " Restore fold level
  setlocal foldmethod=marker
  exe 'setlocal foldlevel=' . tempfoldlevel

  " Put cursor on beginning of fold
  exe 'normal ' . firstfoldline . 'G'

  " Ensure that current fold is closed, but surrounding fold is open
  let foldleveldiff = foldlevel(firstfoldline) - tempfoldlevel - 1

  if firstlinestillfold
    if foldleveldiff > 0
      exe 'normal ' . foldleveldiff . 'zo'
    elseif foldleveldiff < 0
      exe firstfoldline . ',' . lastfoldline . 'foldclose'
    endif
  else
    let foldleveldiff = foldleveldiff + 1
    if foldleveldiff > 0
      exe 'normal ' . foldleveldiff . 'zo'
    endif
  endif

  " Calculate new cursor position
  let curline = curline + firstfoldline - 1
  let curcol = curcol + tempindent

  " Put cursor on new position
  normal gV
  exe 'normal ' . curline . 'G' . curcol . '|'

  " Save new state in swap file
  if &swapfile
    silent preserve
  endif

  " Back to normal undo behaviour
  exe 'setlocal undolevels=' . save_ul

  " Restore cpoptions
  exe 'setlocal cpoptions=' . save_cpo

  " Restore modified flag
  if !curmodified|setlocal nomodified|endif

  " Restore magic
  if !save_magic|setlocal nomagic|endif

  " Restore backup
  if save_backup|setlocal backup|endif

  " Restore readonly
  if save_ro|setlocal readonly|endif

  " Restore modifiable
  if !save_modifiable|setlocal nomodifiable|endif

  " Restore virtualedit if necessary
  if exists('b:_ove')
    exe 'setlocal ve=' . b:_ove
    unlet b:_ove
  endif

  echomsg 'All folds left'

endfunction
"}}}

"{{{  function <SID>RecoverFolds(chk, infofn)
" Function to recover from folding swap files after a session has crashed
" Arguments: a:chk is true if called by an autocmd and false if called by a user
"            a:infofn is the name of a fold information swap file (optional)
function <SID>RecoverFolds(chk, infofn)

  " Save current cursor position
  let curline = line('.')
  let curcol = virtcol('.')

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  " Called by a user
  if !a:chk

    " Stop if we have entered a fold
    if exists('b:is_foldentered')
      echohl ErrorMsg
      echomsg 'Recovery not possible while inside a fold. Exit all folds and try again!'
      echohl None
      " Restore magic
      if !save_magic|setlocal nomagic|endif
      return
    endif

    " Stop if buffer is not modifiable
    if !&modifiable
      echohl ErrorMsg
      echomsg "E21: Cannot make changes, 'modifiable' is off"
      echohl None
      " Restore magic
      if !save_magic|setlocal nomagic|endif
      return
    endif

    " Find out name of .fold.info file
    let fn = a:infofn

    " If no argument given
    if fn =~ '^\s*$'
      " Stop if swap file is switched off
      if !&swapfile
        " Restore magic
        if !save_magic|setlocal nomagic|endif

        " Print error message 
        echohl ErrorMsg
        echomsg '.fold.info file required'
        echohl None
        " Restore magic
        if !save_magic|setlocal nomagic|endif
        return

      else
        " Create .fold.info filename from swapfile
        let fn = <SID>GetSwapfileName() . '.fold.info'

      endif

    " Check for the correct extension
    elseif fn !~ '\.fold\.info$'
      " Restore magic
      if !save_magic|setlocal nomagic|endif

      " Print error message 
      echohl ErrorMsg
      echomsg '.fold.info file required'
      echohl None
      " Restore magic
      if !save_magic|setlocal nomagic|endif
      return
    endif

    " Check whether file is readable
    if !filereadable(fn)
      " Restore magic
      if !save_magic|setlocal nomagic|endif

      " Print error message 
      echohl ErrorMsg
      echomsg "Can't access file \"" . fn . '"'
      echohl None
      " Restore magic
      if !save_magic|setlocal nomagic|endif
      return
    endif

    " Confirm recovery
    let choice = confirm("Do you want to start recovery from fold information swap file\n\""
          \ . fn . "\"?\n(You can undo this later.)",
          \ "&Recover\n&Cancel\n&Delete folding swap files", 1, 'Question')

    " Cancel
    if choice == 2 || choice == 0
      " Restore magic
      if !save_magic|setlocal nomagic|endif
      return
    endif

      let dx = choice == 3

  " Automatic check at start
  else

    " Ensure swapfile exists if option is switched on
    let &swapfile = &swapfile

    if !&swapfile
      " Restore magic
      if !save_magic|setlocal nomagic|endif
      return
    else
      " Create .fold.info filename from swapfile
      let fn = <SID>GetSwapfileName() . '.fold.info'

      if !filereadable(fn)
        " Restore magic
        if !save_magic|setlocal nomagic|endif
        return
      endif

      " Confirm recovery
      let choice = confirm("Warning: The fold information swap file\n\""
          \ . fn . "\"\nalready exists. It is likely that a previous session has crashed.\n"
          \ . "Do you want to start recovery? (You can undo this later.)",
          \ "&Recover\n&Cancel\n&Delete folding swap files", 1, 'Warning')

      " Cancel
      if choice == 2 || choice == 0
        " Restore magic
        if !save_magic|setlocal nomagic|endif
        return
      endif

      let dx = choice == 3

    endif
  endif

  " Open new window
  new

  " The new buffer is modifiable
  setlocal modifiable

  " Read in .fold.info file
  exe 'silent 0 read ' . AdaptFileName(fn)

  " Check for errors
  let err = line('$') < 3
  if !err
    let tempfoldentered_level = getline(1)
    if tempfoldentered_level !~ '^\d\+$' || tempfoldentered_level < 1
      let err = 1
    endif
    let tempindent = getline(2)
    if tempindent !~ '^\d\+$' || tempindent < 0
      let err = 1
    endif
  endif

  " Close temporary buffer
  bdelete!
  redraw

  " Delete info file
  if dx
    call delete(fn)
  endif

  " Stop if there were errors
  if err
    " Restore magic
    if !save_magic|setlocal nomagic|endif

    " Print error message 
    if !dx
      echohl ErrorMsg
      echomsg "Error in fold information swap file \"" . fn . '"'
      echohl None
    endif
    return
  endif

  if !dx

    " Ensure buffer is modifiable
    setlocal modifiable

    " Don't create alternate files
    let save_cpo = &cpoptions
    setlocal cpoptions-=aA

    " Save whether the first line is still the start of a fold
    let firstlinestillfold = foldlevel(1)

    " Shift current fold to normal level
    if tempindent > 0
      let oldsw = &sw
      exe 'setlocal sw=' . tempindent
      silent % >
      exe 'setlocal sw=' . oldsw
    endif

    " Save the length of the current fold
    let curfoldlength = line('$')
  endif

  " Get rid of extension
  let fn = strpart(fn, 0, strlen(fn) - 4)

  " Read in or delete pre-fold files
  let i = tempfoldentered_level + 1
  while i > 1
    let i = i - 1

    let foldfilename = fn . i . '.pre'
    if filereadable(foldfilename)
      if !dx
        exe 'silent 0 read ' . AdaptFileName(foldfilename)
      else
        call delete(foldfilename)
      endif
    endif
  endwhile

  if !dx

    " Calculate  first and last line of current fold
    let lastfoldline = line('$')
    let firstfoldline = lastfoldline - curfoldlength + 1
  endif

  " Read in or delete post-fold files
  let i = tempfoldentered_level + 1
  while i > 1
    let i = i - 1

    let foldfilename = fn . i . '.post'
    if filereadable(foldfilename)
      if !dx
        exe 'silent $ read ' . AdaptFileName(foldfilename)
      else
        call delete(foldfilename)
      endif
    endif
  endwhile

  " Stop if Delete was chosen
  if dx
    echomsg 'Folding swap files deleted'
    " Restore magic
    if !save_magic|setlocal nomagic|endif
    return
  endif

  " Restore fold level to zero
  setlocal foldmethod=marker
  setlocal foldlevel=0

  " Put cursor on beginning of fold
  exe 'normal ' . firstfoldline . 'G'

  " Ensure that current fold is closed, but surrounding fold is open
  let foldleveldiff = foldlevel(firstfoldline) - 1

  if firstlinestillfold
    if foldleveldiff > 0
      exe 'normal ' . foldleveldiff . 'zo'
    elseif foldleveldiff < 0
      foldclose
    endif
  else
    let foldleveldiff = foldleveldiff + 1
    if foldleveldiff > 0
      exe 'normal ' . foldleveldiff . 'zo'
    endif
  endif

  " Calculate new cursor position
  let curline = curline + firstfoldline - 1
  let curcol = curcol + tempindent

  " Put cursor on new position
  exe 'normal ' . curline . 'G' . curcol . '|'

  " Save new state in swap file
  if &swapfile
    silent preserve
  endif

  " Restore cpoptions
  exe 'setlocal cpoptions=' . save_cpo

  " Restore magic
  if !save_magic|setlocal nomagic|endif

  echomsg "Recovery completed. Save the file if its content is OK, otherwise undo recovery. If recovery was successful, you should delete the folding swap files on the next request."

endfunction
"}}}

"{{{  function <SID>UnloadFolds()
" Function to clean up when Vim is closed (called by autocmd)
function <SID>UnloadFolds()

  " Goto buffer
  if bufnr('%') != expand('<abuf>')
    exe bufwinnr(expand('<abuf>') + 0) . 'wincmd w'
  endif

  " Stop if we have not entered a fold
  if !exists('b:is_foldentered')
    return
  endif

  " Unlet saved variables and delete special swap files
  let i = 0
  while i < b:foldentered_level
    let i = i + 1

    exe 'unlet b:foldentered_indent_' . i
    exe 'unlet b:foldentered_foldlevel_' . i
    exe 'unlet b:foldentered_lineoffset_' . i
    call delete(b:foldentered_swapfilename . '.fold.' . i . '.pre')
    call delete(b:foldentered_swapfilename . '.fold.' . i . '.post')
  endwhile

  " Delete info file
  call delete(b:foldentered_swapfilename . '.fold.info')

  " Unlet special variables
  unlet b:is_foldentered
  unlet b:foldentered_swapfilename
  unlet b:foldentered_level
  unlet b:foldentered_indent_sum
  unlet b:foldentered_lineoffset_sum

endfunction
"}}}

"{{{  function <SID>FoldChangedShell()
" Function to reload a file which was changed outside Vim (called by autocmd)
function <SID>FoldChangedShell()

  if !filereadable(expand('<afile>'))

    echohl Error
    echomsg 'E211: Warning: File "' . expand('<afile>') . '" no longer available'
    echohl None

  " Ask for confirmation
  elseif confirm('W11: Warning: File "' . expand('<afile>') . "\"\nhas changed since editing started",
        \ "&OK\n&Load File", 1, 'Warning') == 2

    " Goto buffer
    if bufnr('%') != bufnr(expand('<afile>'))
      exe bufwinnr(bufnr(expand('<afile>'))) . 'wincmd w'
    endif
    " Reload file
    edit!
    if &filetype != ''
      exe 'setf ' . &filetype
    endif
    if exists('b:is_foldentered')
      normal 1G
    endif
    call <SID>UnloadFolds()
    setlocal foldlevel=0
  endif

endfunction
"}}}

"{{{  function <SID>FoldUpdateSwapfileNames()
" Function to update the names of the folding swap files when the file name of a buffer has changed
" (can be called by autocmd)
function <SID>FoldUpdateSwapfileNames()

  " Stop if swap file is switched off
  if !&swapfile|return|endif

  " Stop if we have not entered a fold
  if !exists('b:is_foldentered')
    return
  endif

  let sfn = <SID>GetSwapfileName()

  " Stop if swap file name hasn't changed
  if b:foldentered_swapfilename == sfn
    return
  endif

  " Rename existing special swap files
  let i = 0
  while i < b:foldentered_level
    let i = i + 1

    call rename(b:foldentered_swapfilename . '.fold.' . i . '.pre', sfn . '.fold.' . i . '.pre')
    call rename(b:foldentered_swapfilename . '.fold.' . i . '.post', sfn . '.fold.' . i . '.post')
  endwhile

  " Rename info file
  call rename(b:foldentered_swapfilename . '.fold.info', sfn . '.fold.info')

  " Save new swap file name
  let b:foldentered_swapfilename = sfn

endfunction
"}}}

"{{{  function <SID>ToggleOrigamiMode(off)
" Function to toggle origami mode
function <SID>ToggleOrigamiMode(off)

  if a:off

    "{{{  Upmap relevant key mappings
    if maparg('<Insert>', '') !~ '^$'
      vunmap <Left>
      vunmap <Right>
      unmap <Insert>
      iunmap <Insert>
      if maparg('<Del>', '') !~ '^$'
        unmap <Del>
        iunmap <Del>
      endif
      unmap <PageUp>
      iunmap <PageUp>
      unmap <PageDown>
      iunmap <PageDown>

      " In linewise mode
      if maparg('<Up>', '') =~ '^$'
        unmap <Home>
        iunmap <Home>
        unmap <End>
        iunmap <End>
      " In displaywise mode
      else
        noremap <Home> g<Home>
        vnoremap <Home> <Esc>g<Home>gV
        inoremap <Home> <C-O>g<Home>
        noremap <End> g<End>
        vnoremap <End> <Esc>g<End>gV
        inoremap <End> <C-O>g<End>
      endif
    endif

    echomsg "Switched origami mode off"
    let &statusline = &statusline

    "}}}

  else

    "{{{  Was not in origami mode
    if maparg('<Insert>', '') =~ '^$'

      " Going to origami:Alt mode

      "{{{  Create folds
      " Insert is Create fold
      noremap <Insert> 1\|V
      onoremap <Insert> <Esc>
      vnoremap <silent><Insert> :Foldcreate<CR>
      inoremap <Insert> <C-O>1\|<C-O>V
      "}}}

      "{{{  Delete folds
      " Del is Delete fold 
      noremap <silent><Del> :Folddel<CR>
      onoremap <Del> <Esc>
      vnoremap <silent><Del> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
            \gv:Folddel<CR>
      inoremap <silent><Del> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
            \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
            \<C-O>:Folddel<CR>
      "}}}

      "{{{  Open folds
      " End is Open fold
      noremap <silent><End> zo
      onoremap <End> <Esc>
      inoremap <silent><End> <C-O>zo
      "}}}

      "{{{  Close folds
      " PageDown is Close fold
      noremap <silent><PageDown> zc
      onoremap <PageDown> <Esc>
      inoremap <silent><PageDown> <C-O>zc
      "}}}

      "{{{  Enter folds or selections
      " Home is Enter fold or selection
      noremap <silent><Home> :Foldenter<CR>
      onoremap <Home> <Esc>
      vnoremap <silent><Home> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
            \gv:Foldenterselection<CR>
      inoremap <silent><Home> <C-O>:let b:_isininsertmode = 1\|let b:_vc = virtcol('.')\|let b:_ove = &ve\|
            \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
            \<C-O>:Foldenter<CR>
      "}}}

      "{{{  Exit folds
      " PageUp is Exit fold
      noremap <silent><PageUp> :Foldexit<CR>
      onoremap <PageUp> <Esc>
      vnoremap <silent><PageUp> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
            \gv:XYZAuxFXS<CR>
      inoremap <silent><PageUp> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
            \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
            \<C-O>:Foldexit<CR>
      "}}}

      "{{{  Manipulate indent (when stuff is selected)
      " Right is Increase indent
      vnoremap <silent><Right> >gv

      " Left is Decrease indent
      vnoremap <silent><Left> <gv
      "}}}

      echomsg "Switched to origami:Alt mode"
      let &statusline = &statusline
    "}}}

    "{{{  Was in origami:Alt mode
    elseif maparg('<Insert>', 'n') == '1|V'

      " Going to origami:Ctrl-Alt mode

      "{{{  Open folds
      " End is Open all folds
      noremap <silent><End> zR
      onoremap <End> <Esc>
      inoremap <silent><End> <C-O>zR
      "}}}

      "{{{  Close folds
      " PageDown is Close all folds
      noremap <silent><PageDown> zM
      onoremap <PageDown> <Esc>
      inoremap <silent><PageDown> <C-O>zM
      "}}}

      "{{{  Exit folds
      " PageUp is Exit all folds
      noremap <silent><PageUp> :Foldexitall<CR>
      onoremap <PageUp> <Esc>
      vnoremap <silent><PageUp> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
            \gv:XYZAuxFXAS<CR>
      inoremap <silent><PageUp> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
            \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
            \<C-O>:Foldexitall<CR>
      "}}}

      "{{{  Describe folds with first non-empty line
      " Insert is Describe fold with first non-empty line
      noremap <silent><Insert> :Folddescribe<CR>
      onoremap <Insert> <Esc>
      vnoremap <silent><Insert> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
            \gv:Folddescribe<CR>
      inoremap <silent><Insert> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
            \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
            \<C-O>:Folddescribe<CR>
      "}}}

      "{{{  View cursor line
      " Home is View cursor line
      noremap <silent><Home> zv
      onoremap <Home> <Esc>
      inoremap <silent><Home> <C-O>zv
      "}}}

      " Upmap relevant key mappings
      unmap <Del>
      iunmap <Del>

      echomsg "Switched to origami:Ctrl-Alt mode"
      let &statusline = &statusline
    "}}}

    "{{{  Was in origami:Ctrl-Alt mode
    elseif maparg('<Insert>', 'n') == ':Folddescribe<CR>'

      " Going to origami:Shift-Alt mode

      "{{{  Delete folds
      " Del is Delete folds recursively
      noremap <silent><Del> :Folddelrec<CR>
      onoremap <Del> <Esc>
      vnoremap <silent><Del> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
            \gv:Folddelrec<CR>
      inoremap <silent><Del> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
            \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
            \<C-O>:Folddelrec<CR>
      "}}}

      "{{{  Open folds
      " End is Open folds recursively
      noremap <silent><End> zO
      onoremap <End> <Esc>
      inoremap <silent><End> <C-O>zO
      "}}}

      "{{{  Close folds
      " PageDown is Close folds recursively
      noremap <silent><PageDown> zC
      onoremap <PageDown> <Esc>
      inoremap <silent><PageDown> <C-O>zC
      "}}}

      "{{{  Toggle whether a fold is commented out
      " Insert is Toggle whether a fold is commented out
      noremap <silent><Insert> :Foldtogglecomment<CR>
      onoremap <Insert> <Esc>
      vnoremap <silent><Insert> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
            \gv:Foldtogglecomment<CR>
      inoremap <silent><Insert> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
            \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
            \<C-O>:Foldtogglecomment<CR>
      "}}}

      "{{{  Re-apply fold level
      " Home is Re-apply fold level
      noremap <silent><Home> zX
      onoremap <Home> <Esc>
      inoremap <silent><Home> <C-O>zX
      "}}}

      "{{{  Reinitialise folds
      " Shift-Alt-PageUp is Reinitialise folds
      noremap <silent><PageUp> :set foldmethod=marker<CR>
      onoremap <PageUp> <Esc>
      vnoremap <silent><PageUp> <Esc>:set foldmethod=marker<CR>
      inoremap <silent><PageUp> <C-O>:set foldmethod=marker<CR>
      "}}}

      echomsg "Switched to origami:Shift-Alt mode"
      let &statusline = &statusline
    "}}}

    "{{{  Was in origami:Shift-Alt mode
    elseif maparg('<Insert>', 'n') == ':Foldtogglecomment<CR>'

      " Going to origami:Ctrl-Shift-Alt mode

      "{{{  Delete folds
      " Insert is Eliminate fold
      noremap <silent><Insert> :Foldeliminate<CR>
      onoremap <Insert> <Esc>
      vnoremap <silent><Insert> <Esc>:let b:_ove = &ve\|setlocal ve=all<CR>
            \gv:Foldeliminate<CR>
      inoremap <silent><Insert> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
            \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
            \<C-O>:Foldeliminate<CR>
      "}}}

      "{{{  Open folds
      " Ctrl-Shift-Alt-End is Increase fold level
      noremap <silent><End> zr
      onoremap <End> <Esc>
      inoremap <silent><End> <C-O>zr
      "}}}

      "{{{  Close folds
      " PageDown is Decrease fold level
      noremap <silent><PageDown> zm
      onoremap <PageDown> <Esc>
      inoremap <silent><PageDown> <C-O>zm
      "}}}

      "{{{  Disable and enable folding
      " Home is Disable folding
      noremap <silent><Home> zn
      onoremap <Home> <Esc>
      inoremap <silent><Home> <C-O>zn

      " PageUp is Enable folding
      noremap <silent><PageUp> zN
      onoremap <PageUp> <Esc>
      inoremap <silent><PageUp> <C-O>zN
      "}}}

      " Upmap relevant key mappings
      unmap <Del>
      iunmap <Del>

      echomsg "Switched to origami:Ctrl-Shift-Alt mode"
      let &statusline = &statusline
    "}}}

    "{{{  Was in origami:Ctrl-Shift-Alt mode
    else

      " Upmap relevant key mappings
      vunmap <Left>
      vunmap <Right>
      unmap <Insert>
      iunmap <Insert>
      unmap <PageUp>
      iunmap <PageUp>
      unmap <PageDown>
      iunmap <PageDown>

      " In linewise mode
      if maparg('<Up>', '') =~ '^$'
        unmap <Home>
        iunmap <Home>
        unmap <End>
        iunmap <End>
      " In displaywise mode
      else
        noremap <Home> g<Home>
        vnoremap <Home> <Esc>g<Home>gV
        inoremap <Home> <C-O>g<Home>
        noremap <End> g<End>
        vnoremap <End> <Esc>g<End>gV
        inoremap <End> <C-O>g<End>
      endif

      echomsg "Switched origami mode off"
      let &statusline = &statusline
    endif
    "}}}

  endif
endfunction
"}}}

"{{{  function <SID>ToggleShowFoldLevel()
" Function to toggle whether the current fold level is shown in the status line
function <SID>ToggleShowFoldLevel()
  let g:_fold_showfoldlevel = !g:_fold_showfoldlevel
  let &statusline = &statusline
endfunction
"}}}

"{{{  function <SID>ToggleExpandEmptyFoldText()
" Function to toggle whether an empty fold text will be expanded
function <SID>ToggleExpandEmptyFoldText()
  let g:_fold_expandemptyfoldtext = !g:_fold_expandemptyfoldtext
  redraw!
  if g:_fold_expandemptyfoldtext
    echomsg 'Expand empty fold text'
  else    
    echomsg "Don't expand empty fold text"
  endif
endfunction
"}}}

"{{{  function <SID>SaveWholeFile()
" Function to save a whole file even if the buffer contains just an entered fold (called by autocmd)
function <SID>SaveWholeFile()

  " Write the file
  let v:errmsg = ''
  let v:statusmsg = ''
  exe 'silent! write! ' . AdaptFileName(expand('<afile>'))

  " If there was an error
  if v:errmsg != ''
    echohl ErrorMsg
    echomsg v:errmsg
    echohl None
    return
  " If we have not entered a fold
  elseif !exists('b:is_foldentered')
    echomsg v:statusmsg
    return
  endif

  " Save status message
  let firstmsg = v:statusmsg

  " Save filenames
  let argfn = expand('<afile>')
  let oldfn = expand('%')

  " Ensure magic is on
  let save_magic = &magic
  setlocal magic

  " Ensure backup is off
  let save_backup = &backup
  setlocal nobackup

  " Store content of register a
  let temp_reg_a = @a

  " Yank whole buffer into register a
  silent % yank a

  " Get indent of current fold and saved fold level from the correct variables
  let tempindent = b:foldentered_indent_sum

  " Get name of swapfile
  let tempswapfilename = b:foldentered_swapfilename

  " Get current fold entered level
  let tempfelevel = b:foldentered_level 

  " Get current file format
  let tempfileformat = &fileformat

  " Open new window
  new

  " The new buffer is modifiable
  setlocal modifiable

  " Set the correct file format
  exe 'setlocal fileformat=' . tempfileformat

  " Put in current fold
  silent put a

  " Remove empty line
  silent 1 d _

  " Shift current fold to normal level
  if tempindent > 0
    let oldsw = &sw
    exe 'setlocal sw=' . tempindent
    silent % >
    exe 'setlocal sw=' . oldsw
  endif

  " Save the length of the current fold
  let curfoldlength = line('$')

  " Read in pre-fold area from special swap file
  let i = tempfelevel + 1
  while i > 1
    let i = i - 1

    let foldfilename = tempswapfilename . '.fold.' . i . '.pre'
    if filereadable(foldfilename)
      exe 'silent 0 read ' . AdaptFileName(foldfilename)
    endif
  endwhile

  " Read in post-fold area from special swap file
  let i = tempfelevel + 1
  while i > 1
    let i = i - 1

    let foldfilename = tempswapfilename . '.fold.' . i . '.post'
    if filereadable(foldfilename)
      exe 'silent $ read ' . AdaptFileName(foldfilename)
    endif
  endwhile

  " Find out whether we got a new name
  let isnewname = fnamemodify(argfn, ':p') != fnamemodify(oldfn, ':p')

  " Find out filename to write
  if isnewname
    let writefn = argfn
  else
    let writefn = tempname()
  endif

  " Save file
  let v:errmsg = ''
  exe 'silent! write! ' . AdaptFileName(writefn)

  " Close temporary buffer
  bdelete!
  redraw

  " If there was an error
  if v:errmsg != ''
    echohl ErrorMsg
    echomsg v:errmsg
    echohl None

  else

    let noerror = 1

    " We have to rename a temporary file
    if !isnewname

      " Rename temporary file
      if rename(writefn, argfn) != 0
        echohl ErrorMsg
        echomsg '"' . argfn . "\" E212: Can't open file for writing"
        echohl None
        call delete(writefn)
        let noerror = 0
      endif
    endif

    " Print status message
    if noerror

      " Find start of lines/columns part in first status message
      let ms = 0
      let lastbutonenumberstart = 0
      let lastnumberstart = 0
      while match(firstmsg, '\d\+', ms) != -1

        let lastbutonenumberstart = lastnumberstart
        let lastnumberstart = match(firstmsg, '\<\d\+', ms)

        let ms = matchend(firstmsg, '\d\+', ms)
      endwhile

      " Remove lines/columns part in first status message
      let firstmsg = strpart(firstmsg, 0, lastbutonenumberstart)

      " Find start of lines/columns part in current status message
      let ms = 0
      let lastbutonenumberstart = 0
      let lastnumberstart = 0
      while match(v:statusmsg, '\d\+', ms) != -1

        let lastbutonenumberstart = lastnumberstart
        let lastnumberstart = match(v:statusmsg, '\<\d\+', ms)

        let ms = matchend(v:statusmsg, '\d\+', ms)
      endwhile

      " Replace stuff before the lines/columns part in current status message
      let v:statusmsg = firstmsg . strpart(v:statusmsg, lastbutonenumberstart)

      " Show new status message
      echomsg v:statusmsg

    endif
  endif

  if &swapfile
  " Check whether swapfile names are up to date
    call <SID>FoldUpdateSwapfileNames()
    " Save current state in swap file
    silent preserve
  endif

  " Restore magic
  if !save_magic|setlocal nomagic|endif

  " Restore backup
  if save_backup|setlocal backup|endif

  " Restore register a
  let @a = temp_reg_a

endfunction
"}}}


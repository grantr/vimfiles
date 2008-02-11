" Vim support file containing scripts useful for programming
"
" Maintainer:	Mario Schweigler <ms44@kent.ac.uk>
" Last Change:	23 May 2003

" Only load this file once
if exists("b:did_programmingmacros")
  finish
endif
let b:did_programmingmacros = 1

"{{{  Settings
let g:_showcomments = 0
"}}}

"{{{  User defined commands

" Comment and Uncomment
command -range Comment call CommentLines(-1, 0, 0, <line1>, <line2>)
command -range Uncomment call CommentLines(-1, 1, 0, <line1>, <line2>)

" Comment out and Undo comment out
command -range Commentout call CommentLines(0, 0, 0, <line1>, <line2>)
command -range Uncommentout call CommentLines(0, 1, 0, <line1>, <line2>)

" Toggle whether file type (and its comments) are shown in the status line
command Toggleshowcomments call <SID>ToggleShowComments()

"{{{  Shortcuts for the commands
command -range CM <line1>,<line2>Comment
command -range UCM <line1>,<line2>Uncomment
command -range CO <line1>,<line2>Commentout
command -range UCO <line1>,<line2>Uncommentout

command TSC Toggleshowcomments
"}}}

"}}}

"{{{  Keyboard mappings

"{{{  Commenting
" F7 is Comment
noremap <silent><F7> :Comment<CR>
onoremap <F7> <Esc>
vnoremap <silent><F7> <Esc>:let b:_isinvisualmode = 1<CR>
      \gv:Comment<CR>
inoremap <silent><F7> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
      \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
      \<C-O>:Comment<CR>

" Shift-F7 is Uncomment
noremap <silent><S-F7> :Uncomment<CR>
onoremap <S-F7> <Esc>
vnoremap <silent><S-F7> <Esc>:let b:_isinvisualmode = 1<CR>
      \gv:Uncomment<CR>
inoremap <silent><S-F7> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
      \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
      \<C-O>:Uncomment<CR>

" F8 is Comment out
noremap <silent><F8> :Commentout<CR>
onoremap <F8> <Esc>
vnoremap <silent><F8> <Esc>:let b:_isinvisualmode = 1<CR>
      \gv:Commentout<CR>
inoremap <silent><F8> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
      \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
      \<C-O>:Commentout<CR>

" Shift-F8 is Undo comment out
noremap <silent><S-F8> :Uncommentout<CR>
onoremap <S-F8> <Esc>
vnoremap <silent><S-F8> <Esc>:let b:_isinvisualmode = 1<CR>
      \gv:Uncommentout<CR>
inoremap <silent><S-F8> <C-O>:let b:_vc = virtcol('.')\|let b:_ove = &ve\|
      \setlocal ve=all\|exe 'normal ' . b:_vc . '\|'\|unlet b:_vc<CR>
      \<C-O>:Uncommentout<CR>
"}}}

"{{{  Toggle whether comments are shown
" Ctrl-F6 toggles whether comments are shown
noremap <silent><C-F6> :Toggleshowcomments<CR>
onoremap <C-F6> <Esc>
vnoremap <silent><C-F6> <Esc>:Toggleshowcomments<CR>
inoremap <silent><C-F6> <C-O>:Toggleshowcomments<CR>
"}}}

"}}}

"{{{  function GetComment(lang, which)
" Feel free to add others! :)
" Arguments: a:lang is a string to indicate the language - use the same word as you would use for :setf
"            a:which indicates which comment you want:
" 0 is the left comment
" 1 is the right comment, if there is none (i.e. EOL ends the comment) return ''
" If there is an alternative way of commenting, use
" 2 to return the alternative left comment, and
" 3 to return the alternative right comment.
" If there is no alternative comment, 2 returns ''.
" If there are more alternatives, use (2n) for the left and (2n+1) for the right comments.
" Note that the 0, 1 couple will be used for creating folds, commenting lines etc.
" The alternatives are just there for correct display.
" NOTE: Every character is allowed except \

function GetComment(lang, which)

  " occam (filetype=occam)
  if a:lang == 'occam'
    if a:which == 0|return '--'|else|return ''|endif
  " Vim script (filetype=vim)
  elseif a:lang == 'vim'
    if a:which == 0|return '"'|else|return ''|endif
  " Basic (filetype=basic)
  elseif a:lang == 'basic'
    if a:which == 0|return "'"|else|return ''|endif
  " Java (filetype=java)
  " C (filetype=c)
  " C++ (filetype=cpp)
  elseif a:lang == 'java' || a:lang == 'c' || a:lang == 'cpp'
    if a:which == 0|return '//'|elseif a:which == 2|return '/*'|
        \elseif a:which == 3|return '*/'|else|return ''|endif
  " Pascal (filetype=pascal)
  elseif a:lang == 'pascal'
    if a:which == 0|return '(*'|elseif a:which == 1|return '*)'|
    elseif a:which == 2|return '{'|elseif a:which == 3|return '}'|else|return ''|endif
  " TeX (filetype=tex)
  elseif a:lang == 'tex' || a:lang == 'bib'
    if a:which == 0|return "%"|else|return ''|endif
  " HTML (filetype=html)
  " XML (filetype=html)
  elseif a:lang == 'html' || a:lang == 'xml'
    if a:which == 0|return '<!--'|elseif a:which == 1|return '-->'|else|return ''|endif
  " Unix shell script (filetype=sh)
  " Python (filetype=python)
  elseif a:lang == 'sh' || a:lang == 'csh' || a:lang == 'perl' || a:lang == 'python' ||
      \a:lang == 'members' || a:lang == 'news' || a:lang == 'picindex' || a:lang == 'pictures' || a:lang == 'programme'
    if a:which == 0|return '#'|else|return ''|endif
  " Assembler (filetype=asm)
  " Assembler 68000 (filetype=asm68k)
  elseif a:lang == 'asm' || a:lang == 'asm68k'
    if a:which == 0|return ';'|else|return ''|endif

  " Space for more...

  else
    return ''
 endif

endfunction
"}}}

"{{{  function CommentLines(ind, remove, foldaware, startsel, endsel)
" Put a comment marker at the beginning of the line, or remove it
" Arguments: a:ind states how to deal with indent:
"            -1 means find out about indent and put comment at beginning of non-whitespace text
"            >= 0 means Put comment at exactly this indent, even if text starts later
"            a:remove states is true for the comment to be removed, otherwise false
"            a:foldaware is true for treating fold lines specially, otherwise false
"            a:startsel is the first line of the selection
"            a:endsel is the last line of the selection
function CommentLines(ind, remove, foldaware, startsel, endsel)

  " Stop if no comments are defined for current file type
  if GetComment(&filetype, 0) == ''
    echohl ErrorMsg
    echomsg "Error: No comments defined for this file type"
    echohl None
    return
  endif

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

  " Save original cursor position
  let originalline = line('.')
  let originalcol = virtcol('.')

  " Adapt lines if on a closed fold
  if a:startsel == a:endsel && foldclosed(a:startsel) != -1
    let startsel = foldclosed(a:startsel)
    let endsel = foldclosedend(a:startsel)
  else
    let startsel = a:startsel
    let endsel = a:endsel
  endif

  " Temporarily disable folds
  let save_fe = &foldenable
  setlocal nofoldenable

  " Save shiftwidth
  let oldsw = &sw

  " Set expandtab if necessary
  if !a:remove
    if !&expandtab
      setlocal expandtab
      let was_noexpandtab_ed = 1
    endif
  endif

  " Shift one to right
  setlocal sw=1
  exe 'silent ' a:startsel ',' . a:endsel . '>'

  if a:ind != -1
    " Get rid of indent
    exe 'setlocal sw=' . (a:ind + 1)
    exe 'silent ' a:startsel ',' . a:endsel . '<'
  endif

  " For all lines
  let curline = startsel
  while curline <= endsel

    let curindent = indent(curline)

    if a:ind == -1
      " Get rid of indent
      if curindent > 0
        exe 'setlocal sw=' . curindent
        exe 'silent ' curline . '<'
      endif
    endif

    " Get current line
    let line = getline(curline)

    " Check whether this line is to be changed
    let dothisline = 1
    if a:foldaware && line =~ '^\V' . GetComment(&filetype, 0) . '\m.*' . GetFoldMarker(2, 1)
      if !a:remove || line !~ '^\V' . GetComment(&filetype, 0) . '\m\s*\V' . GetComment(&filetype, 0)
        let dothisline = 0
      endif
    endif

    if dothisline

      " Add or remove comment
      if !a:remove
        if a:ind == -1
          if line !~ '^$' || GetComment(&filetype, 1) != ''
            let line = ' ' . line
          endif
        endif
        let line = GetComment(&filetype, 0) . line . GetComment(&filetype, 1)
      else

        " Find out whether the line has a left comment
        if line =~ '^\V' . GetComment(&filetype, 0)

          " Remove comment character
          let line = strpart(line, strlen(GetComment(&filetype, 0)))

          " Remove other spaces if a:ind is -1
          if a:ind == -1
            if line =~ '\S'
              let line = strpart(line, match(line, '\S'))
            else
              let line = ''
            endif
          endif
        endif

        " Find out whether the line has a right comment
        if GetComment(&filetype, 1) != ''
          if line =~ '\V' . GetComment(&filetype, 1) . '\$'

            " Remove comment character
            let line = strpart(line, 0, strlen(line) - strlen(GetComment(&filetype, 1)))
          endif
        endif

      endif

      " Put line back in text
      call setline(curline, line)
    endif

    if a:ind == -1
      " Put indent back
      if curindent > 0
        exe 'silent ' curline . '>'
      endif
    endif

    let curline = curline + 1
  endwhile

  if a:ind != -1
    " Put indent back
    exe 'silent ' a:startsel ',' . a:endsel . '>'
  endif

  " Reset expandtab
  if !a:remove
    if exists('was_noexpandtab_ed')
      setlocal noexpandtab
    endif
  endif

  " Shift one to left
  setlocal sw=1
  exe 'silent ' a:startsel ',' . a:endsel . '<'

  " Restore shiftwidth
  exe 'setlocal sw=' . oldsw

  " Restore foldenable
  if save_fe|setlocal foldenable|endif

  " Restore cursor position
  if exists('b:_isinvisualmode')
    unlet b:_isinvisualmode
    normal gv
  else
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

"{{{  function <SID>ToggleShowComments()
" Function to toggle whether the comments of the current file type are shown in the status line
function <SID>ToggleShowComments()
  let g:_showcomments = !g:_showcomments
  let &statusline = &statusline
endfunction
"}}}


" Vim colour file
" Maintainer:	Mario Schweigler <ms44@kent.ac.uk>
" Last Change:	23 April 2003

" This colour scheme has got some similarities to the Nirvana Editor (nedit).

" First remove all existing highlighting.
set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "nirvana"

hi Normal ctermfg=Black ctermbg=LightGrey guibg=Grey93 guifg=Black

" Groups used in the 'highlight' and 'guicursor' options default value.
hi ErrorMsg term=standout ctermbg=DarkRed ctermfg=White guibg=Red guifg=White
hi IncSearch term=reverse cterm=reverse gui=reverse
hi ModeMsg term=bold cterm=bold gui=bold
hi StatusLine term=reverse,bold cterm=reverse,bold gui=reverse,bold
hi StatusLineNC term=reverse cterm=reverse gui=reverse
hi VertSplit term=reverse cterm=reverse gui=reverse
hi Visual term=reverse cterm=reverse gui=reverse guifg=Grey guibg=fg
hi VisualNOS term=underline,bold cterm=underline,bold gui=underline,bold
hi DiffText term=reverse cterm=bold ctermbg=Red gui=bold guibg=Red
hi Cursor guibg=Black guifg=White
hi lCursor guibg=Cyan guifg=NONE
hi Directory term=bold ctermfg=DarkBlue guifg=Blue
hi LineNr term=underline ctermfg=DarkGray guifg=grey45
hi MoreMsg term=bold ctermfg=DarkGreen gui=bold guifg=SeaGreen
hi NonText term=bold ctermfg=Blue gui=bold guifg=Blue guibg=grey85
hi Question term=standout ctermfg=DarkGreen gui=bold guifg=SeaGreen
hi Search term=reverse ctermbg=Yellow ctermfg=NONE guibg=Yellow guifg=NONE
hi SpecialKey term=bold ctermfg=DarkBlue guifg=Blue
hi Title term=bold ctermfg=DarkMagenta gui=bold guifg=Magenta
hi WarningMsg term=standout ctermfg=DarkRed guifg=Red
hi WildMenu term=standout ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
hi Folded term=standout ctermbg=LightGrey ctermfg=1 guibg=grey93 guifg=Blue
hi FoldColumn term=standout ctermbg=Grey ctermfg=1 guibg=grey60 guifg=Blue
hi DiffAdd term=bold ctermbg=LightBlue guibg=LightBlue
hi DiffChange term=bold ctermbg=LightMagenta guibg=LightMagenta
hi DiffDelete term=bold ctermfg=Blue ctermbg=LightCyan gui=bold guifg=Blue guibg=LightCyan

" Colours for syntax highlighting
hi Ignore ctermfg=LightGrey guifg=Grey93
hi Comment gui=italic guifg=DarkBlue
hi SpecialComment term=bold ctermfg=1 guibg=grey63 guifg=Blue
hi Delimiter term=bold ctermfg=5 gui=bold guifg=DarkCyan
hi helpExample guifg=DarkBlue


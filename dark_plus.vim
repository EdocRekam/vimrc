" VISUAL STUDIO CODE DARK+ THEME FOR GVIM
set background=dark
hi clear
if exists("syntax_on")
	syntax reset
end
let g:colors_name="dark_plus"

" BACKGROUND / FOREGROUND
hi Conceal          gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi Directory        gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi ErrorMsg         gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi FoldColumn       gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi Folded           gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi IncSearch        gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi MatchParen       gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi MoreMsg          gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi NonText          gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi Normal           gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi Pmenu            gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi PmenuSbar        gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi PmenuSel         gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi PmenuThumb       gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi Question         gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi Search           gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi SignColumn       gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi StatusLineTerm   gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi StatusLineTermNC gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi TabLine          gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi TabLineFill      gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi TabLineSel       gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi Title            gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi ToolbarButton    gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi ToolbarLine      gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi WarningMsg       gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi WildMenu         gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black

hi CursorLineNr     gui=NONE guibg=#1e1e1e guifg=#858585 ctermfg=lightgrey ctermbg=black
hi LineNr           gui=NONE guibg=#1e1e1e guifg=#858585 ctermfg=lightgrey ctermbg=black
hi SpecialKey       gui=NONE guibg=#1e1e1e guifg=#858585 ctermfg=lightgrey ctermbg=black

hi VertSplit        gui=NONE guibg=#1e1e1e guifg=#2e2e2e ctermfg=lightgrey ctermbg=black

" DIFF
hi DiffAdd          gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi DiffChange       gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi DiffDelete       gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black
hi DiffText         gui=NONE guibg=#1e1e1e guifg=#d4d4d4 ctermfg=lightgrey ctermbg=black

" STATUS BAR
hi ModeMsg          gui=NONE guibg=#68217a guifg=#ffffff
hi StatusLine       gui=NONE guibg=#68217a guifg=#ffffff
hi StatusLINENC     gui=NONE guibg=#88419a guifg=#858585


hi ColorColumn gui=NONE guibg=#2e2e2e guifg=NONE ctermfg=lightgrey ctermbg=black
hi Spellbad    gui=NONE guibg=NONE    guifg=NONE gui=underline

hi Cursor       gui=NONE guibg=#264f78 guifg=NONE
hi lCursor      gui=NONE guibg=#264f78 guifg=NONE

hi CursorColumn gui=NONE guibg=#264f78 guifg=NONE
hi CursorLine   gui=NONE guibg=#264f78 guifg=NONE
hi Visual       gui=NONE guibg=#264f78 guifg=NONE
hi VisualNOS    gui=NONE guibg=#264f78 guifg=NONE

" BLUE #569cd6
hi Boolean        gui=NONE guifg=#569cd6
hi Keyword        gui=NONE guifg=#569cd6
hi StorageClass   gui=NONE guifg=#569cd6
hi Type           gui=NONE guifg=#569cd6

" GREEN #6a9955
hi Comment        gui=NONE guifg=#6a9955

" ORANGE #ce9178
hi String         gui=NONE guifg=#ce9178

" PURPLE #c586c0
hi Conditional    gui=NONE guifg=#cd86c0
hi Exception      gui=NONE guifg=#cd86c0
hi Include        gui=NONE guifg=#cd86c0
hi Repeat         gui=NONE guifg=#cd86c0
hi Statement      gui=NONE guifg=#cd86c0

" WHITE #d4d4d4
hi Character      gui=NONE guifg=#d4d4d4
hi Debug          gui=NONE guifg=#d4d4d4
hi Define         gui=NONE guifg=#d4d4d4
hi Delimiter      gui=NONE guifg=#d4d4d4
hi Error          gui=NONE guifg=#d4d4d4
hi Float          gui=NONE guifg=#d4d4d4
hi Function       gui=NONE guifg=#d4d4d4
hi Identifier     gui=NONE guifg=#d4d4d4
hi Ignore         gui=NONE guifg=#d4d4d4
hi Label          gui=NONE guifg=#d4d4d4
hi Macro          gui=NONE guifg=#d4d4d4
hi Number         gui=NONE guifg=#d4d4d4
hi Operator       gui=NONE guifg=#d4d4d4
hi PreCondit      gui=NONE guifg=#d4d4d4
hi PreProc        gui=NONE guifg=#d4d4d4
hi Special        gui=NONE guifg=#d4d4d4
hi SpecialChar    gui=NONE guifg=#d4d4d4
hi SpecialComment gui=NONE guifg=#d4d4d4
hi Structure      gui=NONE guifg=#d4d4d4
hi Tag            gui=NONE guifg=#d4d4d4
hi Todo           gui=NONE guifg=#d4d4d4
hi Typedef        gui=NONE guifg=#d4d4d4
hi Underlined     gui=NONE guifg=#d4d4d4



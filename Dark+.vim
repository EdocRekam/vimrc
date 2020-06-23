" VISUAL STUDIO CODE DARK+ THEME FOR GVIM
set background=dark
hi clear
if exists("syntax_on")
	syntax reset
end
let g:colors_name="Dark+"

" BACKGROUND / FOREGROUND
hi Conceal          gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Directory        gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi ErrorMsg         gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi FoldColumn       gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Folded           gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi MatchParen       gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi MoreMsg          gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Normal           gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Question         gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi SignColumn       gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi StatusLineTerm   gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi StatusLineTermNC gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi TabLine          gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi TabLineFill      gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi TabLineSel       gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Title            gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi ToolbarButton    gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi ToolbarLine      gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi WarningMsg       gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi WildMenu         gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7

hi CursorLineNr     gui=NONE      guibg=#1e1e1e guifg=#858585 cterm=NONE ctermbg=0  ctermfg=8
hi LineNr           gui=NONE      guibg=#1e1e1e guifg=#858585 cterm=NONE ctermbg=0  ctermfg=8
hi SpecialKey       gui=NONE      guibg=#1e1e1e guifg=#858585 cterm=NONE ctermbg=0  ctermfg=8

hi VertSplit        gui=NONE      guibg=#1e1e1e guifg=#2e2e2e cterm=NONE ctermbg=0  ctermfg=7

" HIDE ~ BEYOND FILE
hi NonText          gui=NONE      guibg=#1e1e1e guifg=#1e1e1e cterm=NONE ctermbg=0  ctermfg=7

" DIFF
hi DiffAdd          gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi DiffChange       gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi DiffDelete       gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi DiffText         gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7

" STATUS BAR
hi ModeMsg          gui=NONE      guibg=#68217a guifg=#ffffff cterm=NONE ctermbg=0  ctermfg=7
hi StatusLine       gui=NONE      guibg=#68217a guifg=#ffffff cterm=NONE ctermbg=0  ctermfg=7
hi StatusLINENC     gui=NONE      guibg=#88419a guifg=#858585 cterm=NONE ctermbg=0  ctermfg=7

hi ColorColumn      gui=NONE      guibg=#2e2e2e guifg=NONE    cterm=NONE ctermbg=NONE ctermfg=1

" SPELLCHECK
hi SpellBad         gui=UNDERLINE guibg=NONE    guifg=NONE    cterm=bold ctermbg=0  ctermfg=NONE
hi SpellCap         gui=UNDERLINE guibg=NONE    guifg=NONE    cterm=bold ctermbg=0  ctermfg=NONE
hi SpellLocal       gui=UNDERLINE guibg=NONE    guifg=NONE    cterm=bold ctermbg=0  ctermfg=NONE
hi SpellRare        gui=UNDERLINE guibg=NONE    guifg=NONE    cterm=bold ctermbg=0  ctermfg=NONE

hi Cursor           gui=NONE      guibg=#264f78 guifg=NONE    cterm=NONE ctermbg=0  ctermfg=7
hi lCursor          gui=NONE      guibg=#264f78 guifg=NONE    cterm=NONE ctermbg=0  ctermfg=7

hi cursorcolumn     gui=NONE      guibg=#264f78 guifg=NONE    cterm=STANDOUT ctermbg=7  ctermfg=7
hi cursorline       gui=NONE      guibg=#2e2e2e guifg=NONE    cterm=NONE     ctermbg=4  ctermfg=NONE
hi visual           gui=NONE      guibg=#264f78 guifg=NONE    cterm=BOLD     ctermbg=4  ctermfg=NONE
hi visualnos        gui=NONE      guibg=#264f78 guifg=NONE    cterm=BOLD     ctermbg=4  ctermfg=NONE

" POPUP MENUS
hi Pmenu            gui=NONE      guibg=#68217A guifg=#FFFFFF cterm=NONE ctermbg=0  ctermfg=7
hi PmenuSbar        gui=NONE      guibg=#2E2E2E guifg=NONE    cterm=NONE ctermbg=0  ctermfg=7
hi PmenuThumb       gui=NONE      guibg=#FFFFFF guifg=NONE    cterm=NONE ctermbg=0  ctermfg=7
hi PmenuSel         gui=BOLD      guibg=#264F78 guifg=NONE    cterm=BOLD ctermbg=4  ctermfg=7

" SEARCH
hi incsearch        gui=NONE      guibg=#515c6a guifg=NONE    cterm=NONE ctermbg=0  ctermfg=7
hi search           gui=ITALIC    guibg=#613214 guifg=NONE    cterm=NONE ctermbg=0  ctermfg=7

" AQUA #4EC9B0
hi Identifier       gui=NONE      guibg=#1e1e1e guifg=#4EC9B0 cterm=NONE ctermbg=0  ctermfg=7

" BLUE #569CD6
hi Boolean          gui=NONE      guibg=#1e1e1e guifg=#569cd6 cterm=NONE ctermbg=0  ctermfg=6
hi Keyword          gui=NONE      guibg=#1e1e1e guifg=#569cd6 cterm=NONE ctermbg=0  ctermfg=6
hi StorageClass     gui=NONE      guibg=#1e1e1e guifg=#569cd6 cterm=NONE ctermbg=0  ctermfg=6
hi Type             gui=NONE      guibg=#1e1e1e guifg=#569cd6 cterm=NONE ctermbg=0  ctermfg=6

" GREEN #6A9955
hi Comment          gui=NONE      guibg=#1e1e1e guifg=#6a9955 cterm=NONE ctermbg=0  ctermfg=2

" ORANGE #CE9178
hi String           gui=NONE      guibg=#1e1e1e guifg=#ce9178 cterm=NONE ctermbg=0  ctermfg=3

" PURPLE #C586C0
hi Conditional      gui=NONE      guibg=#1e1e1e guifg=#cd86c0 cterm=NONE ctermbg=0  ctermfg=5
hi Exception        gui=NONE      guibg=#1e1e1e guifg=#cd86c0 cterm=NONE ctermbg=0  ctermfg=5
hi Include          gui=NONE      guibg=#1e1e1e guifg=#cd86c0 cterm=NONE ctermbg=0  ctermfg=5
hi Repeat           gui=NONE      guibg=#1e1e1e guifg=#cd86c0 cterm=NONE ctermbg=0  ctermfg=5
hi Statement        gui=NONE      guibg=#1e1e1e guifg=#cd86c0 cterm=NONE ctermbg=0  ctermfg=5

" YELLOW #DCDCAA
hi Function         gui=NONE      guibg=#1e1e1e guifg=#DCDCAA cterm=NONE ctermbg=0  ctermfg=7

" WHITE #D4D4D4
hi Character        gui=NONE      guibg=#1e1e1e guifg=#CE9178 cterm=NONE ctermbg=0  ctermfg=7
hi Debug            gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Define           gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Delimiter        gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Float            gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Ignore           gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Label            gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Macro            gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Number           gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Operator         gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi PreCondit        gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi PreProc          gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Special          gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi SpecialChar      gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi SpecialComment   gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Structure        gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Tag              gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Typedef          gui=NONE      guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7

hi Error            gui=ITALIC    guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7
hi Todo             gui=ITALIC    guibg=#1e1e1e guifg=#d4d4d4 cterm=NONE ctermbg=0  ctermfg=7

hi Underlined       gui=UNDERLINE guibg=NONE    guifg=NONE    cterm=NONE ctermbg=0  ctermfg=7


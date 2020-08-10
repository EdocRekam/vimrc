vim9script

# HIDE MENU, HIDE TOOLBAR, AUTO CLIPBOARD, KEEP WINDOW SIZE
set guioptions -=m
set guioptions -=T
set guioptions +=P
set guioptions +=k

const FONT_MIN = 10
const FONT_MAX = 36

# SET PREFERRED FONT + GVIM OPTIONS
if has("gui_gtk2") || has("gui_gtk3")
    set gfn=Inconsolata\ 15
elseif has("gui_win32")
    set gfn=Consolas:h14:cANSI:qDRAFT
en

def g:ZoomIn()
    let old = getfontname()
    let i = match(old, '[0-9][0-9]')
    let family = strcharpart(old, -1, i)
    let size = str2nr(strcharpart(old, i, 2)) + 1
    if size > FONT_MAX
        size = FONT_MIN
    en
    if has("gui_win32")
        &guifont = printf("%sh%d:cANSI:qDRAFT", family, size)
    else
        &guifont = printf("%s %d", family, size)
    en
enddef

def g:ZoomOut()
    let old = getfontname()
    let i = match(old, '[0-9][0-9]')
    let family = strcharpart(old, -1, i)
    let size = str2nr(strcharpart(old, i, 2)) - 1
    if size < FONT_MIN
        size = FONT_MAX
    en
    if has("gui_win32")
        &guifont = printf("%sh%d:cANSI:qDRAFT", family, size)
    else
        &guifont = printf("%s %d", family, size)
    en
enddef

nn <silent><C-S-LEFT> :cal g:ZoomOut()<CR>
nn <silent><C-S-RIGHT> :cal g:ZoomIn()<CR>

defcompile

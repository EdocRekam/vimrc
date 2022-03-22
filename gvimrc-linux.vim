# SET PREFERRED FONT + GVIM OPTIONS
set gfn=Inconsolata\ 14

def g:ZoomIn()
    var old = getfontname()
    var i = match(old, '[0-9][0-9]')
    var family = strcharpart(old, -1, i)
    var size = str2nr(strcharpart(old, i, 2)) + 1
    if size > FONT_MAX
        size = FONT_MIN
    endif
    &guifont = printf("%s %d", family, size)
enddef

def g:ZoomOut()
    var old = getfontname()
    var i = match(old, '[0-9][0-9]')
    var family = strcharpart(old, -1, i)
    var size = str2nr(strcharpart(old, i, 2)) - 1
    if size < FONT_MIN
        size = FONT_MAX
    endif
    &guifont = printf("%s %d", family, size)
enddef

nn <silent><C-S-LEFT> :cal g:ZoomOut()<CR>
nn <silent><C-S-RIGHT> :cal g:ZoomIn()<CR>

defcompile

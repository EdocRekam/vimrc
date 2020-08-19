set gfn=Consolas:h13:cANSI:qCLEARTYPE

def g:ZoomIn()
    let old = getfontname()
    let i = match(old, '[0-9][0-9]')
    let family = strcharpart(old, -1, i)
    let size = str2nr(strcharpart(old, i, 2)) + 1
    if size > FONT_MAX
        size = FONT_MIN
    en
    &guifont = printf("%sh%d:cANSI:qCLEARTYPE", family, size)
enddef

def g:ZoomOut()
    let old = getfontname()
    let i = match(old, '[0-9][0-9]')
    let family = strcharpart(old, -1, i)
    let size = str2nr(strcharpart(old, i, 2)) - 1
    if size < FONT_MIN
        size = FONT_MAX
    en
    &guifont = printf("%sh%d:cANSI:qCLEARTYPE", family, size)
enddef

nn <silent><C-S-LEFT> :cal g:ZoomOut()<CR>
nn <silent><C-S-RIGHT> :cal g:ZoomIn()<CR>

defcompile

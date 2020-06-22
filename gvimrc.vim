" HIDE MENU, HIDE TOOLBAR, AUTO CLIPBOARD, KEEP WINDOW SIZE
set guioptions +=M
set guioptions -=m
set guioptions -=T
set guioptions +=P
set guioptions +=k

let s:FontMin = 10
let s:FontMax = 36

" SET PREFERRED FONT + GVIM OPTIONS
if has("gui_gtk2") || has("gui_gtk3")
    set gfn=Inconsolata\ 15
elseif has("gui_win32")
    set gfn=Consolas:h11:cANSI:qDRAFT
endif

function! ZoomIn()
    let l:oldFontName = getfontname()
    let l:sizeIdx = match(oldFontName,"[0-9][0-9]")
    let l:fontFamily = strcharpart(l:oldFontName, -1, l:sizeIdx)
    let l:oldFontSize = str2nr(strcharpart(l:oldFontName, l:sizeIdx, 2))
    let l:newFontSize = l:oldFontSize + 1
    if l:newFontSize > s:FontMax
        let l:newFontSize = s:FontMin
    endif

    if has("gui_win32")
        let newFontName = printf("%sh%d:cANSI:qDRAFT", l:fontFamily, l:newFontSize)
    else
        let newFontName = printf("%s %d", l:fontFamily, l:newFontSize)
    endif
    let &guifont=l:newFontName

    unlet l:fontFamily
    unlet l:newFontSize
    unlet l:oldFontName
    unlet l:oldFontSize
    unlet l:sizeIdx
endfunction

function! ZoomOut()
    let l:oldFontName = getfontname()
    let l:sizeIdx = match(l:oldFontName,"[0-9][0-9]")
    let l:fontFamily = strcharpart(l:oldFontName, -1, l:sizeIdx)
    let l:oldFontSize = str2nr(strcharpart(l:oldFontName, l:sizeIdx, 2))
    let l:newFontSize = l:oldFontSize - 1
    if l:newFontSize < s:FontMin
        let l:newFontSize = s:FontMax
    endif

    if has("gui_win32")
        let newFontName = printf("%sh%d:cANSI:qDRAFT", l:fontFamily, l:newFontSize)
    else
        let newFontName = printf("%s %d", l:fontFamily, l:newFontSize)
    endif
    let &guifont=l:newFontName

    unlet l:fontFamily
    unlet l:newFontSize
    unlet l:oldFontName
    unlet l:oldFontSize
    unlet l:sizeIdx
endfunction


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
    set gfn=Courier_New:h10:cDEFAULT
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

    let newFontName = printf("%s %d", l:fontFamily, l:newFontSize)
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

    let l:newFontName = printf("%s %d", l:fontFamily, l:newFontSize)
    let &guifont=l:newFontName

    unlet l:fontFamily
    unlet l:newFontSize
    unlet l:oldFontName
    unlet l:oldFontSize
    unlet l:sizeIdx
endfunction


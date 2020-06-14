" HIDE TOOLBAR AND MENU
set guioptions -=T
set guioptions -=m
set guioptions +=M

" SET PREFERRED FONT + GVIM OPTIONS
if has("gui_gtk2") || has("gui_gtk3")
    set gfn=Inconsolata\ 15
elseif has("gui_win32")
    set gfn=Courier_New:h10:cDEFAULT
endif


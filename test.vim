vim9script

let MenuLoaded = 0
let MenuAccum = 0
let MenuWid = 0
let MenuId: list<number> = []

def! FilterBuffer(buf: number)
    let t = tolower(MenuOpts.title)
    let idx = 1
    for i in getbufline(buf, 0, '$')
        if stridx(tolower(i), t) != -1
            idx += 1
        else
            deletebufline(buf, idx)
        endif
    endfor
enddef

def! s:MenuCallback(winid: number, result: number): number
    if result == -1
        retu 1
    endif
    retu 1
enddef

def! RestoreBuffer()
    let items = getbufline(MenuId[0], 0, '$')
    deletebufline(MenuId[1], 1, '$')
    appendbufline(MenuId[1], 0, items)
    deletebufline(MenuId[1], '$')
enddef

def! s:MenuFilter(winid: number, key: string): number
    if key == "\<F1>"
        popup_close(winid, -1)
        retu 1
    endif

    " PASS
    if key == "\<F2>" || key == "\<F3>" || key == "\<F4>"
      \ || key == "\<F5>" || key == "\<F6>" || key == "\<F7>"
      \ || key == "\<F8>" || key == "\<F9>" || key == "\<F10>"
      \ || key == "\<F11>" || key == "\<F12>"
        popup_close(winid, -1)
        feedkeys(key)
        retu 1
    endif

    " PRINTABLE CHAR
    if 0 == match(key, '\p')
       " IGNORE THESE
        if key == ':'
            retu popup_filter_menu(winid, key)
        endif

        " ACCUMULATE
        popup_close(winid, -1)
        MenuOpts.title = MenuOpts.title .. key
        FilterBuffer(MenuId[1])
        MenuAccum += 1
        MenuWid = popup_create(MenuId[1], MenuOpts)
        retu 1
    endif

    " NONPRINTABLE
    if key == "\<BS>"
        " NOTHING TO DO
        if MenuAccum < 1
            popup_close(MenuWid, -1)
            retu 1
        endif

        " REGRESS
        popup_close(MenuWid, -1)
        RestoreBuffer()
        MenuOpts.title = Chomp(MenuOpts.title)
        FilterBuffer(MenuId[1])
        MenuAccum -= 1
        MenuWid = popup_create(MenuId[1], MenuOpts)
    else
        retu popup_filter_menu(winid, key)
    endif

    retu 1
enddef

let MenuOpts = #{
    \ callback: funcref('s:MenuCallback'),
    \ cursorline: 1,
    \ filter: funcref('s:MenuFilter'),
    \ filtermode: 'a',
    \ line: 2,
    \ mapping: 0,
    \ maxheight: 25,
    \ maxwidth: 36,
    \ title: '',
    \ wrap: 0,
    \ padding: [1, 1, 0, 1]}

def! VimDir(): string
    retu $HOME .. '/.vim/'
enddef

def! LoadMenu()
    MenuId->add(bufadd(VimDir() .. 'menu.txt'))
    MenuId->add(bufadd('ea9b0bea-e515-40ed-b1a0-f58281ff9629'))

    bufload(MenuId[0])
    setbufvar(MenuId[0], '&buftype', 'nofile')
    setbufvar(MenuId[0], '&swapfile', '0')

    bufload(MenuId[1])
    setbufvar(MenuId[1], '&buftype', 'nofile')
    setbufvar(MenuId[1], '&swapfile', '0')
enddef

def! OpenMenu()
    if 0 == MenuLoaded
        LoadMenu()
    endif

    RestoreBuffer()
    MenuWid = popup_create(MenuId[1], MenuOpts)
enddef
nnoremap <silent><F1> :call <SID>OpenMenu()<CR>


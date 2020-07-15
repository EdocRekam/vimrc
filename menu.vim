let MnuWid = 0
let MnuBuf: list<number> = []

let MnuOpt = #{}
let MnuOpt["cursorline"] = 1
let MnuOpt["filtermode"] = 'a'
let MnuOpt["line"] = 2
let MnuOpt["mapping"] = 0
let MnuOpt["maxheight"] = 25
let MnuOpt["maxwidth"] = 36
let MnuOpt["title"] = ''
let MnuOpt["wrap"] = 0
let MnuOpt["padding"] = [1, 1, 0, 1]

def! MnuFilterBuf(buf: number)
    let lines = getbufline(buf, 1)
    let title = lines[0]
    let idx = 1
    for i in getbufline(buf, 1, '$')
        if stridx(tolower(i), title) != -1
            idx += 1
        else
            deletebufline(buf, idx)
        endif
    endfor
enddef

def! MnuResetBuf()
    deletebufline(MnuBuf[1], 1, '$')
    appendbufline(MnuBuf[1], 1, getbufline(MnuBuf[0], 0, '$'))
    deletebufline(MnuBuf[1], '$')
enddef

def! MnuFilter(winid: number, key: string): number
    let rc = 1

    if key == "\<F1>"
        popup_close(winid, -1)

    # PASS THROUGH
    elsei key == "\<F2>" || key == "\<F3>" || key == "\<F4>"
      \ || key == "\<F5>" || key == "\<F6>" || key == "\<F7>"
      \ || key == "\<F8>" || key == "\<F9>" || key == "\<F10>"
      \ || key == "\<F11>" || key == "\<F12>"
        popup_close(winid, -1)
        feedkeys(key)

    # IGNORED
    elsei key == ':'
        rc = popup_filter_menu(winid, key)

    # PRINTABLE CHAR
    elsei 0 == match(key, '\p')
        let lines = getbufline(MnuBuf[1], 1)
        let title = printf('%s%s', lines[0], tolower(key))
        setbufline(MnuBuf[1], 1, title)
        MnuFilterBuf(MnuBuf[1])

    # BACKUP
    elsei key == "\<BS>"
        let lines = getbufline(MnuBuf[1], 1)
        let title = strcharpart(lines[0], 0, strchars(lines[0]) - 1)
        MnuResetBuf()
        setbufline(MnuBuf[1], 1, title)
        MnuFilterBuf(MnuBuf[1])
    else
        rc = popup_filter_menu(winid, key)
    endif
    retu rc
enddef
let MnuOpt["filter"] = funcref('MnuFilter')

def! MnuGetCmd(result: number): number
    let lines = getbufline(MnuBuf[1], result)
    let line = lines[0]
    let nr = strcharpart(line, 39, 4)
    retu str2nr(nr)
enddef

def! MnuCallback(winid: number, result: number): number
    let id = 0
    if result > 0
        id = MnuGetCmd(result)
    endif

    let ask: string
    let path: string
    if 1 == id
        ask = input('ALIGN ON: ', '=')
        Align(ask)
    # elseif 2 == id
    #    s:dotnet_build()
    # elseif 3 == id
    #    s:dotnet_restore()
    # elsei 4 == id
    #    Lower()
    # elsei 5 == id
    #    Upper()
    # elsei 6 == id
    #     NoTabs()
    # elsei 7 == id
    #    ToCrlf()
    # elsei 8 == id
    #    ToLf()
        # elsei 9 == id
        # ask = input('START: ', '0')
        # Enum(str2nr(ask))
    # elseif 10 == id
    # g:ZoomOut()
    # elseif 11 == id
    #    g:ZoomIn()
    elseif 12 == id
        GitAsyncWin('git add .', 'SO', 'ADDING')
    elseif 13 == id
        exe 'Gcommit'
    elseif 14 == id
        GitAsyncWin('git diff' .. ask, 'DIFF', '')
    elseif 15 == id
        ask = input('Remote: ', 'vso')
        GitAsyncWin('git fetch ' .. ask, 'SO', 'FETCHING')
    # elsei 16 == id
    # GitStatus()
    elsei 17 == id
        GitK()
    elseif 18 == id
        exe '!git gui&'
    # elsei 19 == id
    # GitLog()
    elseif 20 == id
        ask = input('REMOTE: ', 'vso')
        GitAsyncWin('git remote prune ' .. ask, 'SO', 'PRUNING')
    # elseif 21 == id
    #    s:csharp_use()
    # elseif 22 == id
    #    Unique()
    # elseif 23 == id
    #    Notrails()
    # elseif 24 == id
    #    Sort()
    # elseif 25 == id
    #    SortI()
    # elseif 26 == id
    #     SortD()
    # elseif 27 == id
    #    SortDI()
    # elseif 28 == id
    #    GotoDefinition()
    # elseif 29 == id
    #    s:dotnet_test()
    # elseif 30 == id
    #    s:dotnet_test(expand('<cword>'))
    # elseif 31 == id
    #    TEST THIS FILE
    elsei 32 == id
        :so $VIMRUNTIME/syntax/hitest.vim
    elsei 33 == id
        :tabclose
    elsei 34 == id
        :tabnew
    elseif 35 == id
        path = printf('%s/syntax/%s.vim', $VIMRUNTIME, &filetype)
        if filereadable(path)
            exe 'tabnew ' .. path
        endif
    elsei 36 == id
        :options
    elsei 37 == id
        set guifont=*
    # elseif 38 == id
    #     s:csharp_startserver()
    # elseif 39 == id
    #    s:csharp_fold()
    # elseif 40 == id
    #    s:csharp_nofold()
    elseif 41 == id
        path = VimDir() .. 'keys.html'
        if filereadable(path)
            exe printf("!firefox --new-window '%s'&", path)
        endif
    elsei 42 == id
        setl wrap!
    # elsei 45
    #   GitBranch()
    endif

    MnuWid = 0
    retu 1
enddef
let MnuOpt["callback"] = funcref('MnuCallback')

def! MnuLoad()
    add(MnuBuf, bufadd(VimDir() .. 'menu.txt'))
    add(MnuBuf, bufadd('ea9b0bea-e515-40ed-b1a0-f58281ff9629'))

    bufload(MnuBuf[0])
    setbufvar(MnuBuf[0], '&buftype', 'nofile')
    setbufvar(MnuBuf[0], '&swapfile', '0')

    bufload(MnuBuf[1])
    setbufvar(MnuBuf[1], '&buftype', 'nofile')
    setbufvar(MnuBuf[1], '&swapfile', '0')
enddef

def! MnuOpen()
    if 0 == len(MnuBuf)
        MnuLoad()
        MnuResetBuf()
    endif
    MnuWid = 0 == MnuWid ? popup_create(MnuBuf[1], MnuOpt) : 0
enddef
nnoremap <silent><F1> :call <SID>MnuOpen()<CR>
vnoremap <silent><F1> :call <SID>MnuOpen()<CR>

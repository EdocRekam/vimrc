let MnuWid = 0
let MnuBuf: list<number> = []

let MnuOpt = #{}
let MnuOpt["cursorline"] = 1
let MnuOpt["filtermode"] = 'a'
let MnuOpt["line"] = 2
let MnuOpt["mapping"] = 0
let MnuOpt["maxheight"] = 25
let MnuOpt["maxwidth"] = 36
let MnuOpt["wrap"] = 0
let MnuOpt["padding"] = [0, 1, 0, 1]

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

def! MnuBackspace(winid: number)
    let lines = getbufline(MnuBuf[1], 1)
    let title = strcharpart(lines[0], 0, strchars(lines[0]) - 1)
    if strchars(title) >= 0
        MnuResetBuf()
        setbufline(MnuBuf[1], 1, title)
        MnuFilterBuf(MnuBuf[1])
    endif
enddef

def! MnuPrintableChar(winid: number, key: string)
    let lines = getbufline(MnuBuf[1], 1)
    let title = printf('%s%s', lines[0], tolower(key))
    setbufline(MnuBuf[1], 1, title)
    MnuFilterBuf(MnuBuf[1])
enddef

def! MnuIgnore(winid: number)
    popup_close(winid, -1)
enddef

def! MnuFilter(winid: number, key: string): number
    let rc = 1

    if key == "\<F1>" || key == "\<ESC>"
        popup_close(winid, -1)

    # BACKUP
    elsei key == "\<BS>"
        MnuBackspace(winid)

    # IGNORED
    elsei key == ':'
        MnuIgnore(winid)
        rc = 0

    # PASS THROUGH
    elsei key == "\<F2>" || key == "\<F3>" || key == "\<F4>"
     \ || key == "\<F5>" || key == "\<F6>" || key == "\<F7>"
     \ || key == "\<F8>" || key == "\<F9>" || key == "\<F10>"
     \ || key == "\<F11>" || key == "\<F12>"
        popup_close(winid, -1)
        feedkeys(key)

    # PRINTABLE CHAR
    elsei 0 == match(key, '\p')
        MnuPrintableChar(winid, key)

    # NONPRINTABLE
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

def! MnuEnum()
    let ask = input('START: ', '0')
    if '' != ask
        Enum(str2nr(ask))
    endif
enddef

def! MnuZoom(val: number)
    if !has('gui')
        retu
    endif

    if val == 1
        g:ZoomOut()
    else
        g:ZoomIn()
    endif
enddef

def! MnuFetch()
    let ask = input('Remote: ', 'vso')
    if '' != ask
        GitAsyncWin('git fetch ' .. ask, 'SO', 'FETCHING')
    endif
enddef

def! MnuPrune()
    let ask = input('REMOTE: ', 'vso')
    if '' != ask
        GitAsyncWin('git remote prune ' .. ask, 'SO', 'PRUNING')
    endif
enddef

def! MnuSyntax()
    let path = printf('%s/syntax/%s.vim', $VIMRUNTIME, &filetype)
    if filereadable(path)
        exe 'tabnew ' .. path
    endif
enddef

def! MnuCheatsheet()
    let path = VimDir() .. 'keys.html'
    if filereadable(path)
        exe printf("!firefox --new-window '%s'&", path)
    endif
enddef

def! MnuCallback(winid: number, result: number): number
    let id = 0
    if result > 0
        id = MnuGetCmd(result)
    endif

    if 1 == id
        let ask = input('ALIGN ON: ', '=')
        Align(ask)
    elseif 2 == id
        DotnetBuild()
    elseif 3 == id
        DotnetRestore()
    elsei 4 == id
        Lower()
    elsei 5 == id
        Upper()
    elsei 6 == id
        NoTabs()
    elsei 7 == id
        ToCrlf()
    elsei 8 == id
        ToLf()
    elsei 9 == id
        MnuEnum()
    elseif 10 == id
        MnuZoom(1)
    elseif 11 == id
        MnuZoom(0)
    elseif 12 == id
        GitAsyncWin('git add .', 'SO', 'ADDING')
    elseif 13 == id
        GitCommit()
    elseif 14 == id
        GitAsyncWin('git diff', 'DIFF', '')
    elseif 15 == id
        MnuFetch()
    elsei 16 == id
        GitStatus()
    elsei 17 == id
        GitK()
    elseif 18 == id
        exe '!git gui&'
    elsei 19 == id
        InnerGitLog(GitHead())
    elsei 20 == id
        MnuPrune()
    elseif 21 == id
        CsUse()
    elseif 22 == id
        Unique()
    elseif 23 == id
        NoTrails()
    elseif 24 == id
        Sort()
    elseif 25 == id
        SortI()
    elseif 26 == id
        SortD()
    elseif 27 == id
        SortDI()
    elseif 28 == id
        GotoDef()
    elseif 29 == id
        DotnetTest()
    elseif 30 == id
        DotnetTest(expand('<cword>'))
    elsei 32 == id
        :so $VIMRUNTIME/syntax/hitest.vim
    elsei 33 == id
        :tabclose
    elsei 34 == id
        :tabnew
    elseif 35 == id
        MnuSyntax()
    elsei 36 == id
        :options
    elsei 37 == id
        set guifont=*
    elseif 38 == id
        CsStartServer()
    elseif 39 == id
        CsFold()
    elseif 40 == id
        CsNoFold()
    elseif 41 == id
        MnuCheatsheet()
    elsei 42 == id
        setl wrap!
    elsei 44 == id
        tabnew ~/.vimrc
    elsei 45 == id
        GitBranch()
    endif

    MnuWid = 0
    retu 1
enddef
let MnuOpt["callback"] = funcref('MnuCallback')

def! MnuLoad()
    add(MnuBuf, bufadd(VimDir() .. 'menu.txt'))
    add(MnuBuf, bufadd('ea9b0beae51540edb1a0'))

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

    if 0 == MnuWid
        MnuWid = popup_create(MnuBuf[1], MnuOpt)
        win_execute(MnuWid, '2')
    endif
enddef
nnoremap <silent><F1> :call <SID>MnuOpen()<CR>
vnoremap <silent><F1> :call <SID>MnuOpen()<CR>

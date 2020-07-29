let MnuWid = 0
let Mnu0 = 0
let Mnu1 = 1

let MnuOpt = #{}
let MnuOpt["cursorline"] = 1
let MnuOpt["filtermode"] = 'a'
let MnuOpt["line"] = 2
let MnuOpt["mapping"] = 0
let MnuOpt["maxheight"] = 25
let MnuOpt["maxwidth"] = 36
let MnuOpt["wrap"] = 0
let MnuOpt["padding"] = [0, 1, 0, 1]

def MnuFilterBuf(buf: number)
    let lines = getbufline(buf, 1)
    let title = lines[0]
    let idx = 1
    for i in getbufline(buf, 1, '$')
        if stridx(tolower(i), title) != -1
            idx += 1
        else
            deletebufline(buf, idx)
        en
    endfor
enddef

def MnuResetBuf()
    deletebufline(Mnu1, 1, '$')
    appendbufline(Mnu1, 1, getbufline(Mnu0, 0, '$'))
    deletebufline(Mnu1, '$')
enddef

def MnuBackspace(winid: number)
    let lines = getbufline(Mnu1, 1)
    let title = strcharpart(lines[0], 0, strchars(lines[0]) - 1)
    if strchars(title) >= 0
        MnuResetBuf()
        setbufline(Mnu1, 1, title)
        MnuFilterBuf(Mnu1)
    en
enddef

def MnuPrintableChar(winid: number, key: string)
    let lines = getbufline(Mnu1, 1)
    let title = printf('%s%s', lines[0], tolower(key))
    setbufline(Mnu1, 1, title)
    MnuFilterBuf(Mnu1)
enddef

def MnuIgnore(winid: number)
    popup_close(winid, -1)
enddef

def MnuFilter(winid: number, key: string): number
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
    en

    retu rc
enddef
let MnuOpt["filter"] = funcref('MnuFilter')

def MnuGetCmd(result: number): number
    let lines = getbufline(Mnu1, result)
    let line = lines[0]
    let nr = strcharpart(line, 39, 4)
    retu str2nr(nr)
enddef

def MnuEnum()
    let ask = input('START: ', '0')
    if '' != ask
        Enum(str2nr(ask))
    en
enddef

def MnuZoom(val: number)
    if !has('gui')
        retu
    en

    if val == 1
        g:ZoomOut()
    else
        g:ZoomIn()
    en
enddef

def MnuSyntax()
    let pat = printf('%s/syntax/%s.vim', $VIMRUNTIME, &filetype)
    if filereadable(pat)
        exe 'tabnew ' .. pat
    en
enddef

def MnuCheatsheet()
    let pat = VimDir() .. 'keys.html'
    if filereadable(pat)
        exe printf("!firefox --new-window '%s'&", pat)
    en
enddef

def MnuCallback(winid: number, result: number): number
    let id = 0
    if result > 0
        id = MnuGetCmd(result)
    en

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
    elseif 14 == id
        GWin('git diff', 'DIFF', '')
    elsei 16 == id
        GitStatus()
    elsei 17 == id
        GitK()
    elseif 18 == id
        exe 'sil !git gui&'
    elsei 19 == id
        GLog(Head)
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
    en

    MnuWid = 0
    retu 1
enddef
let MnuOpt["callback"] = funcref('MnuCallback')

def MnuLoad()
    Mnu0 = bufadd(VimDir() .. 'menu.txt')
    bufload(Mnu0)
    Sbo(Mnu0)

    Mnu1 = bufadd('ea9b0beae51540edb1a0')
    bufload(Mnu1)
    Sbo(Mnu1)
enddef

def MnuOpen()
    if 0 == Mnu0
        MnuLoad()
        MnuResetBuf()
    en

    if 0 == MnuWid
        MnuWid = popup_create(Mnu1, MnuOpt)
        win_execute(MnuWid, ':2')
    en
enddef
nnoremap <silent><F1> :cal <SID>MnuOpen()<CR>
vnoremap <silent><F1> :cal <SID>MnuOpen()<CR>

defcompile

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
    let t = get(getbufline(buf, 1), 0)
    let idx = 1
    for i in getbufline(buf, 1, '$')
        if stridx(tolower(i), t) != -1
            idx += 1
        else
            deletebufline(buf, idx)
        en
    endfo
enddef

def MnuResetBuf()
    deletebufline(Mnu1, 1, '$')
    appendbufline(Mnu1, 1, getbufline(Mnu0, 0, '$'))
    deletebufline(Mnu1, '$')
enddef

def MnuBackspace(wid: number)
    let l = get(getbufline(Mnu1, 1), 0)
    let t = strcharpart(l, 0, strchars(l) - 1)
    if strchars(t) >= 0
        MnuResetBuf()
        setbufline(Mnu1, 1, t)
        MnuFilterBuf(Mnu1)
    en
enddef

def MnuPrintableChar(wid: number, k: string)
    let t = printf('%s%s', get(getbufline(Mnu1, 1), 0), tolower(k))
    setbufline(Mnu1, 1, t)
    MnuFilterBuf(Mnu1)
enddef

def MnuFilter(wid: number, k: string): number
    let rc = 1

    if k == "\<F1>" || k == "\<ESC>"
        popup_close(wid, -1)

    # PASS THESE ON TO SYSTEM
    elsei k == "\<Down>" || k == "\<Up>"
        rc = popup_filter_menu(wid, k)

    # BACKUP
    elsei k == "\<BS>"
        MnuBackspace(wid)

    # IGNORED
    elsei k == ':'
        popup_close(wid, -1)
        rc = 0

    # PASS THROUGH
    elsei k == "\<F2>" || k == "\<F3>" || k == "\<F4>"
     \ || k == "\<F5>" || k == "\<F6>" || k == "\<F7>"
     \ || k == "\<F8>" || k == "\<F9>" || k == "\<F10>"
     \ || k == "\<F11>" || k == "\<F12>"
        popup_close(wid, -1)
        feedkeys(k)

    # PRINTABLE CHAR
    elsei 0 == match(k, '\p')
        MnuPrintableChar(wid, k)

    # NONPRINTABLE
    else
        rc = popup_filter_menu(wid, k)
    en

    retu rc
enddef
let MnuOpt["filter"] = funcref('MnuFilter')

def MnuGetCmd(id: number): number
    let l = get(getbufline(Mnu1, id), 0)
    retu str2nr(strcharpart(l, 39, 4))
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

# VIM SYNTAX FILE
def F35()
    let pat = printf('%s/syntax/%s.vim', $VIMRUNTIME, &filetype)
    if filereadable(pat)
        exe 'tabnew ' .. pat
    en
enddef

# MENU CHEAT SHEET
def F41()
    let f = VimDir() .. 'keys.html'
    if filereadable(f)
        job_start('firefox --new-window ' .. f)
    en
enddef

def MnuCallback(wid: number, result: number): number
    let id = 0
    if result > 0
        id = MnuGetCmd(result)
    en

    if 1 == id
        Align(input('ALIGN ON: ', '='))
    elseif 2 == id
        # DOTNET BUILD
        F2()
    elseif 3 == id
        # DOTNET RESTORE
        F3()
    elsei 4 == id
        # CONVERT SELECTION TO LOWER
        norm gvugv
    elsei 5 == id
        # CONVERT SELECTION TO UPPER
        norm gvUgv
    elsei 6 == id
        # EXPAND TAB TO SPACE
        F6()
    elsei 7 == id
        # CONVERT LINE ENDINGS TO CRLF
        F7()
    elsei 8 == id
        # CONVERT LINE ENDINGS TO LF
        F8()
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
        job_start('git gui')
    elsei 19 == id
        GLog(Head)
    elseif 21 == id
        # USE CSHARP SETTINGS
        F21()
    elseif 22 == id
        # REMOVE DUPLICATES
        F22()
    elseif 23 == id
        # REMOVE TRAILING WHITESPACE
        F23()
    elseif 24 == id
        # SORT ASCENDING
        F24()
    elseif 25 == id
        # SORT ASCENDING IGNORE CASE
        F25()
    elseif 26 == id
        # SORT DESCENDING
        F26()
    elseif 27 == id
        # SORT DESCENDING IGNORE CASE
        F27()
    elseif 28 == id
        GotoDef()
    elseif 29 == id
        # RUN ALL DOTNET UNIT TESTS
        F29()
    elseif 30 == id
        F29(T9())
    elsei 32 == id
        :so $VIMRUNTIME/syntax/hitest.vim
    elseif 35 == id
        # OPEN VIM SYNTAX FILE
        F35()
    elsei 36 == id
        :options
    elsei 37 == id
        set guifont=*
    elseif 38 == id
        exe ':OmniSharpStartServer'
    elseif 39 == id
        # TURN ON CSHARP CODE FOLDING
        F39()
    elseif 40 == id
        # DISABLE CSHARP CODE FOLDING
        F40()
    elseif 41 == id
        # MENU CHEAT SHEET
        F41()
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
    T3(Mnu0)
    bufload(Mnu0)

    Mnu1 = bufadd('ea9b0beae51540edb1a0')
    T3(Mnu1)
    bufload(Mnu1)
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
no <silent><F1> <ESC>:sil cal <SID>MnuOpen()<CR>

defcompile

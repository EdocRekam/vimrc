var MnuWid = 0
var Mnu0 = 0
var Mnu1 = 1

var MnuOpt = {}
MnuOpt["cursorline"] = 1
MnuOpt["filtermode"] = 'a'
MnuOpt["line"] = 2
MnuOpt["mapping"] = 0
MnuOpt["maxheight"] = 25
MnuOpt["maxwidth"] = 36
MnuOpt["wrap"] = 0
MnuOpt["padding"] = [0, 1, 0, 1]

def MnuFilterBuf(buf = 0)
    var t = get(getbufline(buf, 1), 0)
    var idx = 1
    for i in getbufline(buf, 1, '$')
        if stridx(tolower(i), t) != -1
            idx += 1
        else
            deletebufline(buf, idx)
        endif
    endfor
enddef

def MnuResetBuf()
    deletebufline(Mnu1, 1, '$')
    appendbufline(Mnu1, 1, getbufline(Mnu0, 0, '$'))
    deletebufline(Mnu1, '$')
enddef

def MnuBackspace(wid = 0)
    var l = get(getbufline(Mnu1, 1), 0)
    var t = strcharpart(l, 0, strchars(l) - 1)
    if strchars(t) >= 0
        MnuResetBuf()
        setbufline(Mnu1, 1, t)
        MnuFilterBuf(Mnu1)
    endif
enddef

def MnuPrintableChar(wid = 0, k = '')
    var t = printf('%s%s', get(getbufline(Mnu1, 1), 0), tolower(k))
    setbufline(Mnu1, 1, t)
    MnuFilterBuf(Mnu1)
enddef

def MnuFilter(wid = 0, k = ''): number
    var rc = 1

    if k == "\<F1>" || k == "\<ESC>"
        popup_close(wid, -1)

    # PASS THESE ON TO SYSTEM
    elseif k == "\<Down>" || k == "\<Up>"
        if (popup_filter_menu(wid, k))
            rc = 1
        else
            rc = 0
        endif

    # BACKUP
    elseif k == "\<BS>"
        MnuBackspace(wid)

    # IGNORED
    elseif k == ':'
        popup_close(wid, -1)
        rc = 0

    # PASS THROUGH
    elseif k == "\<F2>" || k == "\<F3>" || k == "\<F4>"
     \ || k == "\<F5>" || k == "\<F6>" || k == "\<F7>"
     \ || k == "\<F8>" || k == "\<F9>" || k == "\<F10>"
     \ || k == "\<F11>" || k == "\<F12>"
        popup_close(wid, -1)
        feedkeys(k)

    # PRINTABLE CHAR
    elseif 0 == match(k, '\p')
        MnuPrintableChar(wid, k)

    # NONPRINTABLE
    else
        if (popup_filter_menu(wid, k))
            rc = 1
        else
            rc = 0
        endif
    endif

    return rc
enddef
MnuOpt["filter"] = funcref('MnuFilter')

def MnuGetCmd(id = 0): number
    var l = get(getbufline(Mnu1, id), 0)
    return str2nr(strcharpart(l, 39, 4))
enddef

def MnuEnum()
    var ask = input('START: ', '0')
    if '' != ask
        Enum(str2nr(ask))
    endif
enddef

def MnuZoom(val = 0)
    if !has('gui')
        return
    endif

    if val == 1
        g:ZoomOut()
    else
        g:ZoomIn()
    endif
enddef

# VIM SYNTAX FILE
def F35()
    var pat = printf('%s/syntax/%s.vim', $VIMRUNTIME, &filetype)
    if filereadable(pat)
        exe 'tabnew ' .. pat
    endif
enddef

# MENU CHEAT SHEET
def F41()
    var f = VimDir() .. 'keys.html'
    if filereadable(f)
        job_start('firefox --new-window ' .. f)
    endif
enddef

def MnuCallback(wid = 0, result = 0): number
    var id = 0
    if result > 0
        id = MnuGetCmd(result)
    endif

    if 1 == id
        Align(input('ALIGN ON: ', '='))
    elseif 2 == id
        # DOTNET BUILD
        F2()
    elseif 3 == id
        # DOTNET RESTORE
        F3()
    elseif 4 == id
        # CONVERT SELECTION TO LOWER
        norm gvugv
    elseif 5 == id
        # CONVERT SELECTION TO UPPER
        norm gvUgv
    elseif 6 == id
        # EXPAND TAB TO SPACE
        F6()
    elseif 7 == id
        # CONVERT LINE ENDINGS TO CRLF
        F7()
    elseif 8 == id
        # CONVERT LINE ENDINGS TO LF
        F8()
    elseif 9 == id
        MnuEnum()
    elseif 10 == id
        MnuZoom(1)
    elseif 11 == id
        MnuZoom(0)
    elseif 12 == id
        # SET TAB TITLE
        F12()
    elseif 13 == id
        # REMOVE BOM
        F13()
    elseif 14 == id
        GWin('git diff', 'DIFF', '')
    elseif 16 == id
        GitStatus()
    elseif 17 == id
        GitK()
    elseif 18 == id
        job_start('git gui')
    elseif 19 == id
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
    elseif 32 == id
        :so $VIMRUNTIME/syntax/hitest.vim
    elseif 35 == id
        # OPEN VIM SYNTAX FILE
        F35()
    elseif 36 == id
        :options
    elseif 37 == id
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
    elseif 42 == id
        setl wrap!
    elseif 44 == id
        tabnew ~/.vimrc
    elseif 45 == id
        GitBranch()
    endif

    MnuWid = 0
    return 1
enddef
MnuOpt["callback"] = funcref('MnuCallback')

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
    endif

    if 0 == MnuWid
        MnuWid = popup_create(Mnu1, MnuOpt)
        win_execute(MnuWid, ':2')
    endif
enddef
no <silent><F1> <ESC>:sil cal <SID>MnuOpen()<CR>

defcompile

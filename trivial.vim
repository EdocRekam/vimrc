# MAP SPECIFIED KEY TO FUNCTION IN NORMAL MODE
def T0(k = '', f = '')
    exe 'nn <silent><' .. k .. '> :cal <SID>' .. f .. '()<CR>'
enddef

# EXPAND CURSOR UNDER STRING TO FILE. SYNTAX SUGAR
def T1(): string
    return expand('<cfile>')
enddef

# CREATE A SYNTAX REGION STARTING/ENDING ON A COLUMN OR LINE
def T2(grp = '', x = 0, y = 0, t = 'c', extra = 'contained display oneline')
    var f = 'sy region %s start="%s" end="%s" %s'
    var z = x + y
    exe printf(f, grp, '\%' .. x .. t, '\%' .. z .. t, extra)
enddef

# SET COMMON BUFFER OPTIONS FOR GIT FUNCTIONS
def T3(h: number)
    setbufvar(h, '&buflisted', '0')
    setbufvar(h, '&buftype', 'nofile')
    setbufvar(h, '&ff', 'unix')
    setbufvar(h, '&swapfile', '0')
enddef

# APPEND Y TO X IF IT DOES NOT EXIST; OTHERWISE X
def T4(x: string, y: string): string
    return stridx(x, y) >= 0 ? x : printf('%s %s', x, y)
enddef

# UPDATE AND SOURCE CURRENT FILE
def T5()
    up
    so %
enddef
T0('S-F5', 'T5')

# SOURCE SESSION.VIM IF PRESENT
def T6()
    if filereadable('session.vim')
        so session.vim
    endif
enddef
au VimEnter * ++once : cal T6()

# RETURN X OR THE LENGTH OF VAL; WHICHEVER IS GREATER
def T7(x = 0, val = ''): number
    var y = strchars(val)
    return y > x ? y : x
enddef

# RETURN THE CURRENT SELECTION AS ARRAY
def T8(): list<string>
    return getline("'<", "'>")
enddef

# RETURN WORD UNDER CURSOR - SYNTAX SUGAR
def T9(): string
    return expand('<cword>')
enddef

var _T10 = 'H'
def T10()
    _T10 = _T10 == 'H' ? 'K' : 'H'
    exe 'winc ' .. _T10
enddef
T0('S-F12', 'T10')

# FIND v IN FILES
def T11(v: string)
    if 0 == strchars(v)
        return
    endif
    :try
        if 34 == strgetchar(v, 0)
            exe 'lv /\C' .. trim(v, '"') .. '/gj **'
        else
            exe 'lv /\c' .. v .. '/gj **'
        endif
        lopen 35
    :catch
    :endtry
enddef
command! -nargs=1 Find :cal <SID>T11('<args>')

# RENAME WORD UNDER CURSOR ALL FILE OCCURRENCES WITH INPUT
def T12(): void
    var v = input('Value: ')
    if '' != v
        exe '%s/' .. T9() .. '/' .. v .. '/g'
    endif
enddef
T0('F2', 'T12')

# SWITCH ALL SPACING TO X
def T13(v = '4')
    exe printf("setl tabstop=%d | setl softtabstop=%d | setl shiftwidth=%d", v, v, v)
enddef
command! -nargs=1 Tabs :cal <SID>T13('<args>')

# MAP KEY
# NORMAL MODE
# LOCAL BUFFER
# MAPKEY(KEY, FUNCTION_NAME, NUMBER1, NUMBER2, STRING1)
#
def T14(k = '', f = '', n1 = 0, n2 = 0, s1 = '')
    exe printf("nn <silent><buffer><%s> :cal <SID>%s(%d, %d, '%s')<CR>", k, f, n1, n2, s1)
enddef

def SCB(d: list<string>, c: channel, msg = '')
    d->add(msg)
enddef

# RUN SYSTEM COMMAND STORE RESULT IN LIST
def S(cmd: any): list<string>
    var data = ['']
    var F = funcref(SCB, [data])
    var j = job_start(cmd, {out_cb: F, err_cb: F})
    while 'run' == j->job_status()
        sleep 25m
    endwhile
    if data->len() > 1
        data->remove(0)
    endif
    return data
enddef

# WRITE MSG TO END OF BUFFER
def Say(hBuf: number, msg: any)
    var c = get(get(getbufinfo(hBuf), 0), 'linecount')
    var l = strchars(get(getbufline(hBuf, '$'), 0))
    appendbufline(hBuf, l > 1 ? c : c - 1, msg)
enddef

# CALLBACK FOR JOB THAT ECHOS TEXT
def SayCb(h: number, c: channel, msg = '')
    Say(h, msg)
enddef

def SayEx(handle = 0, cmd = '')
    var F = funcref(SayCb, [handle])
    job_start(cmd, {out_cb: F, err_cb: F})
enddef

# EXPAND TAB TO SPACE
def F6()
    up
    setl expandtab
    retab
    up
enddef

# CONVERT LINE ENDINGS TO CRLF
def F7()
   up
   e ++ff=unix
   setl ff=dos
   up
enddef

# CONVERT LINE ENDINGS TO LF
def F8()
    up
    e ++ff=dos
    setl ff=unix
    up
enddef

# SET TAB TITLE
def F12()
    var i = input('TITLE: ', '')
    if '' != i
        settabvar(tabpagenr(), 'title', i)
    endif
enddef

# CONVERT TO UTF-8 NO BOM
def F13()
    setl nobomb
    w ++enc=utf8
enddef

# REMOVE DUPLICATES FROM CURRENT SELECTION
def F22()
    var src = T8()
    var dst: list<string>
    for l in src
        if index(dst, l, 0, 0) < 0
            add(dst, l)
        endif
    endfor
    var x = len(src) - len(dst)
    while x > 0
        add(dst, '')
        x -= 1
    endwhile
    setline("'<", dst)
    norm gv
enddef

# REMOVE TRAILING WHITESPACE FROM FILE
def F23()
    :%s/\s\+$//e
enddef

# SORT SELECTION ASCENDING
def F24()
    setline("'<", T8()->sort())
enddef

# SORT SELECTION ASCENDING (IGNORE CASE)
def F25()
    var val = T8()
    sort(val, "1")
    setline("'<", val)
enddef

# SORT SELECTION DESCENDING
def F26()
    setline("'<", T8()->sort()->reverse())
enddef

# SORT SELECTION DESCENDING (IGNORE CASE)
def F27()
    setline("'<", T8()->sort("1")->reverse())
enddef


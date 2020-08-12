# MAP SPECIFIED KEY TO FUNCTION IN NORMAL MODE
def T0(k = '', f = '')
    exe 'nn <silent><' .. k .. '> :cal <SID>' .. f .. '()<CR>'
enddef

# EXPAND CURSOR UNDER STRING TO FILE. SYNTAX SUGAR
def T1(): string
    retu expand('<cfile>')
enddef

# CREATE A SYNTAX REGION STARTING/ENDING ON A COLUMN OR LINE
def T2(grp: string, x: number, y: number, t = 'c', extra = 'contained display oneline')
    let f = 'sy region %s start="%s" end="%s" %s'
    let z = x + y
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
    en
enddef
au VimEnter * ++once : cal T6()

# RETURN X OR THE LENGTH OF VAL; WHICHEVER IS GREATER
def T7(x: number, val: string): number
    let y = strchars(val)
    return y > x ? y : x
enddef

# RETURN THE CURRENT SELECTION AS ARRAY
def T8(): list<string>
    retu getline("'<", "'>")
enddef

# RETURN WORD UNDER CURSOR - SYNTAX SUGAR
def T9(): string
    retu expand('<cword>')
enddef

let _T10 = 'H'
def T10()
    _T10 = _T10 == 'H' ? 'K' : 'H'
    exe 'winc ' .. _T10
enddef
T0('S-F12', 'T10')

# FIND v IN FILES
def T11(v: string)
    if 0 == strchars(v)
        retu
    en
    :try
        if 34 == strgetchar(v, 0)
            exe 'lv /\C' .. trim(v, '"') .. '/gj **'
        el
            exe 'lv /\c' .. v .. '/gj **'
        en
        lopen 35
    :catch
    :endtry
enddef
command! -nargs=1 Find :cal <SID>T11('<args>')

# WRITE MSG TO END OF BUFFER
def Say(h: number, msg: any)
    let c = get(get(getbufinfo(h), 0), 'linecount')
    let l = strchars(get(getbufline(h, '$'), 0))
    appendbufline(h, l > 1 ? c : c - 1, msg)
enddef

# CALLBACK FOR JOB THAT ECHOS TEXT
def SayCallback(h: number, c: channel, msg: string)
    Say(h, msg)
enddef

def SayShell(h: number, cmd: string)
    let f = funcref(SayCallback, [h])
    job_start(cmd, #{out_cb: f, err_cb: f})
enddef


def Rename(): void
    let v = input('Value: ')
    if '' != v
        exe '%s/' .. T9() .. '/' .. v .. '/g'
    en
enddef
T0('F2', 'Rename')

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
   :e ++ff=unix
   setl ff=dos
   up
enddef

# CONVERT LINE ENDINGS TO LF
def F8()
    up
    :e ++ff=dos
    setl ff=unix
    up
enddef

# REMOVE DUPLICATES FROM CURRENT SELECTION
def F22()
    let src = T8()
    let dst: list<string>
    for l in src
        if index(dst, l, 0, 0) < 0
            add(dst, l)
        en
    endfo
    let x = len(src) - len(dst)
    wh x > 0
        add(dst, '')
        x -= 1
    endw
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
    setline("'<", T8()->sort(1))
enddef

# SORT SELECTION DESCENDING
def F26()
    setline("'<", T8()->sort()->reverse())
enddef

# SORT SELECTION DESCENDING (IGNORE CASE)
def F27()
    setline("'<", T8()->sort(1)->reverse())
enddef


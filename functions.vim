def Align(value: string)
    if '' == value
        retu
    en

    let nr = line("'<")
    let colAlign = 0
    for line in getline(nr, "'>")
        let col = stridx(line, value)
        if col > colAlign
            colAlign = col + 1
        en
    endfo
    let cnt = 0
    for line in getline(nr, "'>")
        let col = stridx(line, value)
        let diff = colAlign - col
        let fmt = '%s%' .. printf('%d', diff) .. 's%s'
        let front = strcharpart(line, 0, col)
        let back = strcharpart(line, col, strchars(line))
        line = printf(fmt, front, ' ', back)
        setline(nr, line)
        nr += 1
        cnt += 1
    endfo
    norm gv
enddef

def Enum(base = 0)
    let nr = line("'<")
    let cnt = base
    for line in getline(nr, "'>")
        line = printf('%04d %s', cnt, line)
        setline(nr, line)
        nr += 1
        cnt += 1
    endfo
    norm gv
enddef

def Widest(rows: list<list<string>>, col = 0, min = 0, max = 85): number
    let c = min
    for r in rows
        let len = strchars(r[col])
        if len > c
            c = len
            if c > max
                retu max
            en
        en
    endfo
    retu c
enddef

def OpenWin(t = '', blank = 1): number
    let h = bufnr(t)
    let ids = win_findbuf(h)
    if empty(ids)
        exe 'new ' .. t
        norm gg\<c-w>J
        resize 20
        h = bufnr(t)
        T3(h)
    else
        win_gotoid(get(ids, 0))
        if blank
            sil norm ggvGD
        en
    en
    retu h
enddef

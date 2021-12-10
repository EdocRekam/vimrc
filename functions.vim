def Align(value: string)
    if '' == value
        retu
    en

    var nr = line("'<")
    var colAlign = 0
    for line in getline(nr, "'>")
        var col = stridx(line, value)
        if col > colAlign
            colAlign = col + 1
        en
    endfo
    var cnt = 0
    for line in getline(nr, "'>")
        var col = stridx(line, value)
        var diff = colAlign - col
        var fmt = '%s%' .. printf('%d', diff) .. 's%s'
        var front = strcharpart(line, 0, col)
        var back = strcharpart(line, col, strchars(line))
        var newline = printf(fmt, front, ' ', back)
        setline(nr, newline)
        nr += 1
        cnt += 1
    endfo
    norm gv
enddef

def Enum(base = 0)
    var nr = line("'<")
    var cnt = base
    for line in getline(nr, "'>")
        var newline = printf('%04d %s', cnt, line)
        setline(nr, newline)
        nr += 1
        cnt += 1
    endfo
    norm gv
enddef

def Widest(rows: list<list<string>>, col = 0, min = 0, max = 85): number
    var c = min
    for r in rows
        var len = strchars(r[col])
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
    var h = bufnr(t)
    var ids = win_findbuf(h)
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

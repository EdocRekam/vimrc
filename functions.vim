def! Align(value: string)
    if '' == value
        retu
    endif

    let nr = line("'<")
    let colAlign = 0
    for line in getline(nr, "'>")
        let col = stridx(line, value)
        if col > colAlign
            colAlign = col + 1
        endif
    endfor
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
    endfor
    norm gv
enddef

def! Enum(base: number = 0)
    let nr = line("'<")
    let cnt = base
    for line in getline(nr, "'>")
        line = printf('%04d %s', cnt, line)
        setline(nr, line)
        nr += 1
        cnt += 1
    endfor
    norm gv
enddef

def! Widest(rows: list<list<string>>, col: number, min: number, max: number ): number
    let c = min
    for r in rows
        let len = strchars(r[col])
        if len > c
            c = len
            if c > max
                retu max
            endif
        endif
    endfor
    retu c
enddef

def! OpenWin(title: string, blank = 1): number
    let h = bufnr(title)
    let ids = win_findbuf(h)
    if empty(ids)
        exe 'sil new ' .. title
        exe "norm gg\<c-w>J"
        resize 20
        h = bufnr(title)
        Hide(h)
    else
        win_gotoid(get(ids, 0))
        if blank
            exe 'sil norm ggvGD'
        endif
    endif
    retu h
enddef


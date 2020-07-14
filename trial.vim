
def! Align(criteria: string)
    let nr = line("'<")
    let colAlign = 0
    for line in getline(nr, "'>")
        let col = stridx(line, criteria)
        if col > colAlign
            colAlign = col + 1
        endif
    endfor
    let cnt = 0
    for line in getline(nr, "'>")
        let col = stridx(line, criteria)
        let diff = colAlign - col
        let fmt = '%s%' .. printf('%d', diff) .. 's%s'
        let front = strcharpart(line, 0, col)
        let back = strcharpart(line, col, strlen(line))
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

def! Longest(rows: list<list<string>>, col: number, min: number, max: number ): number
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

def! OpenTab(title: string): number
    let ids = win_findbuf(bufnr(title))
    if empty(ids)
        exe 'sil tabe ' .. title
        setl buftype=nofile
        setl noswapfile
    else
        win_gotoid(get(ids, 0))
        exe 'sil norm ggvGD'
    endif
    retu tabpagenr()
enddef

def! OpenWin(title: string, blank = 1): number
    let ids = win_findbuf(bufnr(title))
    if empty(ids)
        exe 'sil new ' .. title
        exe "norm gg\<c-w>J"
        resize 20
        setl buftype=nofile
        setl noswapfile
    else
        win_gotoid(get(ids, 0))
        if blank
            exe 'sil norm ggvGD'
        endif
    endif
    retu tabpagenr()
enddef

def! OpenWinVert(title: string): number
    let ids = win_findbuf(bufnr(title))
    if empty(ids)
        exe 'sil vnew ' .. title
        setl buftype=nofile
        setl noswapfile
    else
        win_gotoid(get(ids, 0))
        exe 'sil norm ggvGD'
    endif
    retu tabpagenr()
enddef

def! OpenWinShell(title: string, args: list<any>)
    OpenWin(title)
    exe 'sil -1read !' .. call('printf', args)
enddef

def! Shell(args: list<string>): string
    retu system(call('printf', args))
enddef

def! ShellList(args: list<string>): list<string>
    retu systemlist(call('printf', args))
enddef

def! Write(args: list<any>)
    setline('.', [ call('printf', args), '' ])
    norm G
enddef

def! WriteShell(args: list<any>)
    exe 'sil -1read !' .. call('printf', args)
    norm G
enddef

def! s:WriteShellCallback(bufnr: number, chan: number, msg: string)
    appendbufline(bufnr, '$', '# ' .. msg)
enddef

def! WriteShellAsync(cmd: string)
    job_start(cmd, #{out_cb: funcref("s:WriteShellCallback", [bufnr()])})
enddef

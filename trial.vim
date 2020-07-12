
def! s:align(criteria: string)
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

def! s:enum(base: number = 0)
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

def! s:opentab(title: string): number
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

def! s:openwin(title: string): number
    let ids = win_findbuf(bufnr(title))
    if empty(ids)
        exe 'sil new ' .. title
        setl buftype=nofile
        setl noswapfile
    else
        win_gotoid(get(ids, 0))
        exe 'sil norm ggvGD'
    endif
    retu tabpagenr()
enddef

def! s:openwin_shell(title: string, args: list<any>)
    s:openwin(title)
    exe 'sil -1read !' .. call('printf', args)
    exe "norm gg\<c-w>J"
enddef

def! s:hell_list(args: list<string>): list<string>
    retu systemlist(call('printf', args))
enddef

def! s:write(args: list<any>)
    setline('.', [ call('printf', args), '' ])
    norm G
enddef

def! s:write_shell(args: list<any>)
    exe 'sil -1read !' .. call('printf', args)
    norm G
enddef


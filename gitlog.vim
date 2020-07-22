
def! GitLogPath(pat: string)
    " OpenTab('TRACE')

    let l = [
        printf('COMMIT   %-80s DATE       AUTHOR', pat),
        repeat('-', 130)]
    Say(0, l)

    " SayShell(h, ["git log --pretty=format:'%s' -- '%s'",
    "     '\%<(8)\%h \%<(80,trunc)\%s \%cs \%an',
    "     pat])

    exe '3'
    normal 1|
    setl colorcolumn=
    GColor()

    exe printf("noremap <silent><buffer><2-LeftMouse> :cal <SID>git_trace_nav('%s')<CR>", pat)
    exe printf("nnoremap <silent><buffer><F4> :cal <SID>git_trace_nav('%s')<CR>", pat)
    exe printf("nnoremap <silent><buffer><F5> :cal <SID>git_log_file('%s')<CR>", pat)
enddef

def! GLogRefresh(h: number, commit: string)
    let now = reltime()
    deletebufline(h, 1, '$')

    let rs: list<list<string>>
    for i in systemlist("git log -n50 --pretty='%t | %h | %s | %as | %an' " .. commit)
        add(rs, split(i, ' | '))
    endfor
    let lens = [
        Widest(rs, 0, 7, 100),
        Widest(rs, 1, 7, 100),
        Widest(rs, 2, 50, 100),
        11,
        Widest(rs, 4, 7, 100)]

    let f = '%-' .. lens[0] .. 's  %-' .. lens[1] .. 's  %-' .. lens[2] .. 's  %-' .. lens[3] .. 's  %s'
    let hdr = printf(f, 'TREE', 'COMMIT', commit, 'DATE', 'AUTHOR')
    let hl = lens[0] + lens[1] + lens[2] + lens[3] + lens[4] + 8
    let sep = repeat('-', hl)

    let l = [hdr, sep]
    for i in rs
        add(l, printf(f, i[0], i[1], i[2], i[3], i[4]))
    endfor

    # BRANCHES
    extend(l, ['', printf(f, 'TREE', 'COMMIT', 'TAG', 'DATE', 'AUTHOR'), sep])
    for i in systemlist('git rev-parse --short --tags HEAD')
        let line = trim(system("git log -n1 --pretty='%t | %h | %D | %as | %an' " .. i))
        let r = split(line, ' | ')
        add(l, printf(f, r[0], r[1], r[2], r[3], r[4]))
    endfor

    extend(l, ['', '',
    '<F4>  INSPECT    <F5>  VIEW BRANCHES', 
    '<F6>  GIT GUI    <F7>  REFRESH',
    '                 <SHIFT+F7> GITK (UNDER CURSOR)',
    '', '', 'Time:' .. reltimestr(reltime(now, reltime()))])
    Say(h, l)

    # POSITION
    let winid = win_getid(1)
    win_execute(winid, printf('norm %s|', lens[1] + 3))
    win_execute(winid, '3')
enddef

def! GLog(obj: string)
    let now = reltimestr(reltime())

    # BOTTOM -------------------------------------------------------------
    exe 'tabnew Log - ' .. now
    settabvar(tabpagenr(), 'title', obj)
    let hB = bufnr()
    Say(hB, 'Ready...')
    Hide(hB)
    setbufvar(hB, '&colorcolumn', '')

    # TOP ----------------------------------------------------------------
    exe 'split ' .. obj .. ' - ' .. now
    let hT = bufnr()
    setbufvar(hT, '&colorcolumn', '')
    :2resize 20
    GLogRefresh(hT, obj)
    GColor()
    Hide(hT)

    # LOCAL KEY BINDS
    let cmd = 'nnoremap <silent><buffer>'
    exe printf("%s<F3> :exe 'sil bw! %d %d'<CR> ", cmd, hT, hB)
    exe printf('%s<F4> :cal <SID>GLogNav()<CR>', cmd)
    exe printf("%s<F7> :cal <SID>GLogRefresh(%d, '%s')<CR>", cmd, hT, obj)
    exe printf("%s<2-LeftMouse> :cal <SID>GLNav()<CR>", cmd)
enddef

def! GitLog()
    GHead()
    let hint = expand('<cfile>')
    GLog(strchars(hint) > 5 ? hint : 'HEAD')
enddef
nnoremap <silent><F7> :cal <SID>GitLog()<CR>

def! GLogNav()
    let col = col('.')
    if col > 0 && col < 11
        GLog(expand('<cword>'))
    elseif col > 10 && col < 21
        GLog(expand('<cword>'))
    else
        GLog(expand('<cfile>'))
    endif
enddef

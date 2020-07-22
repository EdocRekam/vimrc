def! GRemotes(): string
    let l: string
    for r in systemlist('git remote')
        l = printf('%s  %s', l, r)
    endfor
    retu 'Remotes:' .. l
enddef

def! GBranRefresh(h: number)
    let now = reltime()
    deletebufline(h, 1, '$')

    let rs: list<list<string>>
    for i in systemlist("git branch -a --format='%(objectname:short) %(refname)'")
        let p = split(i)
        let commit = p[0]
        let ref = substitute(p[1], 'refs/remotes/', '', '')
        ref = substitute(ref, 'refs/heads/', '', '')
        let r = [ commit, ref]
        let cmd = "git log -n1 --pretty='%<(78,trunc)%s | %as | %an' " .. commit
        extend(r, split(trim(system(cmd)), ' | '))
        add(rs, r)
    endfor
    let lens = [
        Widest(rs, 0, 7),
        Widest(rs, 1, 10),
        Widest(rs, 2, 7),
        11,
        Widest(rs, 4, 7)]

    let f = '%-' .. lens[0] .. 's  %-' .. lens[1] .. 's  %-' .. lens[2] .. 's  %-' .. lens[3] .. 's  %s'
    let hdr = printf(f, 'COMMIT', 'BRANCH', 'SUBJECT', 'DATE', 'AUTHOR')
    let hl = lens[0] + lens[1] + lens[2] + lens[3] + lens[4] + 8
    let sep = repeat('-', hl)

    let l = [hdr, sep]
    for r in rs
        add(l, printf(f, r[0], r[1], r[2], r[3], r[4]))
    endfor

    extend(l, ['','',
    '<INS> ADD BRANCH   <HOME> CLEAN',
    '<DEL> DEL BRANCH   <END>  RESET (HARD)',
    '<F4>  CHECKOUT     <F5>   REFRESH',
    '<SHIFT+F7> GITK (UNDER CURSOR)',
    '', GRemotes(), '',
    '<CTRL+P> PRUNE (UNDER CURSOR) <CTRL+T> PULL TAGS', ''
    'BRANCH: ' .. g:head, sep, ''])

    for i in systemlist('git log -n5')
        add(l, substitute(i, '^\s\s\s\s$', '', ''))
    endfor
    extend(l, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])
    Say(h, l)

    # POSITION
    let winid = win_getid(1)
    win_execute(winid, printf('norm %s|', lens[0] + 3))
    win_execute(winid, '3')
enddef

def! GBranShellExit(hT: number, hB: number, chan: number, code: number)
    GBranRefresh(hT)
enddef

def! GBranShell(hT: number, hB: number, cmd: string)
    Say(hB, cmd)
    win_execute(win_getid(2), 'norm G')
    let f = funcref("s:SayCallback", [hB])
    let e = funcref("s:GBranShellExit", [hT, hB])
    job_start(cmd, #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def! GBranClean(hT: number, hB: number)
    GBranShell(hT, hB, 'git clean -xdf -e *.swp')
enddef

def! GBranDel(hT: number, hB: number)
    GBranShell(hT, hB, 'git branch -d ' .. expand('<cfile>'))
enddef

def! GBranNav(hT: number, hB: number)
    if col('.') < 10
        GitLog()
    else
        GBranShell(hT, hB, 'git checkout ' .. expand('<cfile>:t'))
    endif
enddef

def! GBranNew(hT: number, hB: number)
    GBranShell(hT, hB, 'git branch ' .. expand('<cfile>'))
enddef

def! GBranPrune(hT: number, hB: number)
    GBranShell(hT, hB, 'git remote prune ' .. expand('<cword>'))
enddef

def! GBranReset(hT: number, hB: number)
    GBranShell(hT, hB, 'git reset --hard ' .. expand('<cfile>'))
enddef

def! GBranTags(hT: number, hB: number)
    GBranShell(hT, hB, 'git fetch --tags ' .. expand('<cword>'))
enddef

def! GitBranch()
    let now = reltimestr(reltime())
    GHead()

    # BOTTOM -------------------------------------------------------------
    exe 'tabnew BranchB' .. now
    settabvar(tabpagenr(), 'title', 'BRANCH')
    let hB = bufnr()
    Say(hB, 'Ready...')
    Hide(hB)
    setbufvar(hB, '&colorcolumn', '')

    # TOP ----------------------------------------------------------------
    exe 'split BranchT' .. now
    let hT = bufnr()
    setbufvar(hT, '&colorcolumn', '')
    :2resize 20
    GBranRefresh(hT)
    GColor()
    Hide(hT)

    # LOCAL KEY BINDS
    let cmd = 'nnoremap <silent><buffer>'
    exe printf('%s<c-t> :cal <SID>GBranTags(%d, %d)<CR>', cmd, hT, hB)
    exe printf('%s<c-p> :cal <SID>GBranPrune(%d, %d)<CR>', cmd, hT, hB)
    exe printf('%s<INS> :cal <SID>GBranNew(%d, %d)<CR>', cmd, hT, hB)
    exe printf('%s<DEL> :cal <SID>GBranDel(%d, %d)<CR>', cmd, hT, hB)
    exe printf('%s<HOME> :cal <SID>GBranClean(%d, %d)<CR>', cmd, hT, hB)
    exe printf('%s<END> :cal <SID>GBranReset(%d, %d)<CR>', cmd, hT, hB)
    exe printf("%s<F3> :exe 'sil bw! %d %d'<CR> ", cmd, hT, hB)
    exe printf('%s<F4> :cal <SID>GBranNav(%d, %d)<CR>', cmd, hT, hB)
    exe printf('%s<F5> :cal <SID>GBranRefresh(%d, %d)<CR>', cmd, hT, hB)
enddef
nnoremap <silent><F5> :cal <SID>GitBranch()<CR>


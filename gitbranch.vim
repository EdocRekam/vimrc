def! GitRemotes(): string
    let l: string
    for r in systemlist('git remote')
        l = printf('%s  %s', l, r)
    endfor
    retu 'Remotes:' .. l
enddef

def! GitBranchMsg(h: number, msg: any)
    let c = get(get(getbufinfo(h), 0), 'linecount')
    let l = strlen(get(getbufline(h, '$'), 0))
    appendbufline(h, l > 1 ? c : c - 1, msg)
enddef

def! GitBranchRefresh(h: number)
    let now = reltime()
    deletebufline(h, 1, '$')

    let rs: list<list<string>>
    for br in systemlist("git branch -a --format='%(objectname:short) %(refname)'")
        let p = split(br)
        let commit = p[0]
        let ref = substitute(p[1], 'refs/remotes/', '', '')
        ref = substitute(ref, 'refs/heads/', '', '')
        let r = [ commit, ref]
        let cmd = "git log -n1 --pretty='%<(78,trunc)%s | %as | %an' " .. commit
        let line = Chomp(system(cmd))
        extend(r, split(line, ' | '))
        add(rs, r)
    endfor
    let lens = [
        Longest(rs, 0, 7, 100),
        Longest(rs, 1, 10, 100),
        Longest(rs, 2, 7, 100),
        11,
        Longest(rs, 4, 7, 100)]

    let f = '%-' .. lens[0] .. 's  %-' .. lens[1] .. 's  %-' .. lens[2] .. 's  %-' .. lens[3] .. 's  %-' .. lens[4] .. 's'
    let hdr = printf(f, 'COMMIT', 'BRANCH', 'SUBJECT', 'DATE', 'AUTHOR')
    let hl = strchars(hdr)
    let sep = repeat('-', hl)

    GitBranchMsg(h, [hdr, sep])
    for r in rs
        GitBranchMsg(h, printf(f, r[0], r[1], r[2], r[3], r[4]))
    endfor

    GitBranchMsg(h, ['','',
    '<INS> ADD BRANCH   <HOME> CLEAN',
    '<DEL> DEL BRANCH   <END>  RESET (HARD)',
    '<F4>  CHECKOUT     <F5>   REFRESH',
    '<SHIFT+F7> GITK (UNDER CURSOR)',
    '', GitRemotes(), '',
    '<CTRL+P> PRUNE (UNDER CURSOR) <CTRL+T> PULL TAGS', ''
    'BRANCH: ' .. g:head, sep, ''])

    GitBranchMsg(h, systemlist('git log -n5'))
    GitBranchMsg(h, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])

    # POSITION
    let winid = win_getid(1)
    win_execute(winid, printf('norm %s|', lens[0] + 3))
    win_execute(winid, '3')
enddef

def! GitBranchShellCallback(h: number, chan: number, msg: string)
    let c = get(get(getbufinfo(h), 0), 'linecount')
    let l = strlen(get(getbufline(h, '$'), 0))
    appendbufline(h, l > 1 ? c : c - 1, msg)
enddef

def! GitBranchShellExit(h: number, chan: number, code: number)
    GitBranchRefresh(gettabvar(tabpagenr(), 'hT'))
enddef

def! GitBranchShell(h: number, cmd: string)
    GitBranchMsg(h, cmd)
    win_execute(2, 'norm G')
    let f = funcref("s:GitBranchShellCallback", [h])
    let e = funcref("s:GitBranchShellExit", [h])
    job_start(cmd, #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def! GitBranchClean(h: number)
    GitBranchShell(h, 'git clean -xdf -e *.swp')
enddef

def! GitBranchDel(h: number)
    GitBranchShell(h, 'git branch -d ' .. expand('<cfile>'))
enddef

def! GitBranchNav(h: number)
    if col('.') < 10
        GitLog()
    else
        GitBranchShell(h, 'git checkout ' .. expand('<cfile>:t'))
    endif
enddef

def! GitBranchNew(h: number)
    GitBranchShell(h, 'git branch ' .. expand('<cfile>'))
enddef

def! GitBranchPrune(h: number)
    GitBranchShell(h, 'git remote prune ' .. expand('<cword>'))
enddef

def! GitBranchReset(h: number)
    GitBranchShell(h, 'git reset --hard ' .. expand('<cfile>'))
enddef

def! GitBranchQuit(hT: number, hB: number)
    exe 'silent bw! ' .. hT .. ' ' .. hB
enddef

def! GitBranch()
    GitHead()

    # TOP ----------------------------------------------------------------
    let hT = bufadd('Git Branch')
    bufload(hT)
    setbufvar(hT, '&buflisted', '0')
    setbufvar(hT, '&buftype', 'nofile')
    setbufvar(hT, '&swapfile', '0')

    # BOTTOM -------------------------------------------------------------
    let hB = bufadd('Git Branch - Messages')
    bufload(hB)
    setbufvar(hB, '&buflisted', '0')
    setbufvar(hB, '&buftype', 'nofile')
    setbufvar(hB, '&swapfile', '0')
    GitBranchMsg(hB, 'Ready...')

    # TAB ----------------------------------------------------------------
    exe 'tabnew Git Branch - Messages'
    let hTab = tabpagenr()
    settabvar(hTab, 'hT', hT)
    settabvar(hTab, 'hB', hB)
    settabvar(hTab, 'title', 'BRANCH')

    exe 'split Git Branch'
    exe '2resize 20'
    GitBranchRefresh(hT)

    # SYNTAX
    setbufvar(hT, '&colorcolumn', '')
    setbufvar(hB, '&colorcolumn', '')
    GitColors()

    # LOCAL KEY BINDS
    exe printf('nnoremap <silent><buffer><c-t> :cal <SID>GitFetchTags(%d)<CR>', hB)
    exe printf('nnoremap <silent><buffer><c-p> :cal <SID>GitBranchPrune(%d)<CR>', hB)
    exe printf('nnoremap <silent><buffer><INS> :cal <SID>GitBranchNew(%d)<CR>', hB)
    exe printf('nnoremap <silent><buffer><DEL> :cal <SID>GitBranchDel(%d)<CR>', hB)
    exe printf('nnoremap <silent><buffer><HOME> :cal <SID>GitBranchClean(%d)<CR>', hB)
    exe printf('nnoremap <silent><buffer><END> :cal <SID>GitBranchReset(%d)<CR>', hB)
    exe printf('nnoremap <silent><buffer><F3> :cal <SID>GitBranchQuit(%d, %d)<CR>', hT, hB)
    exe printf('nnoremap <silent><buffer><F4> :cal <SID>GitBranchNav(%d)<CR>', hB)
    exe printf('nnoremap <silent><buffer><F5> :cal <SID>GitBranchRefresh(%d)<CR>', hT)
enddef
nnoremap <silent><F5> :cal <SID>GitBranch()<CR>


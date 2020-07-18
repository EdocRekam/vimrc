def! GitStatusMsg(h: number, msg: any)
    let c = get(get(getbufinfo(h), 0), 'linecount')
    let l = strlen(get(getbufline(h, '$'), 0))
    appendbufline(h, l > 1 ? c : c - 1, msg)
enddef

def! GitStatusRefresh(h: number)
    deletebufline(h, 1, '$')
    let now = reltime()
    GitStatusMsg(h, systemlist('git status'))
    GitStatusMsg(h, ['', '',
    '<INS> ADD ALL    <HOME>           <PGUP>     PUSH',
    '<DEL> UNSTAGE    <END>  COMMIT    <PGDN>     FETCH',
    '<F6>  GIT GUI    <F7>       GIT LOG (COMMIT UNDER CURSOR)',
    '<F8>  REFRESH    <SHIFT+F7> GIK (UNDER CURSOR)',
    '', repeat('-', 75)])
    GitStatusMsg(h, systemlist('git log -n5'))
    GitStatusMsg(h, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])
enddef

def! GitStatusShellCallback(h: number, chan: number, msg: string)
    let c = get(get(getbufinfo(h), 0), 'linecount')
    let l = strlen(get(getbufline(h, '$'), 0))
    appendbufline(h, l > 1 ? c : c - 1, msg)
enddef

def! GitStatusShellExit(h: number, chan: number, code: number)
    let hStat = gettabvar(tabpagenr(), 'hStat')
    GitStatusRefresh(hStat)
    norm gg
enddef

def! GitStatusShell(h: number, cmd: string)
    GitStatusMsg(h, cmd)
    let f = funcref("s:GitStatusShellCallback", [h])
    let e = funcref("s:GitStatusShellExit", [h])
    job_start(cmd, #{out_cb: f,
    err_cb: f,
    exit_cb: e})
enddef

def! GitStatusPush(h: number)
    GitStatusMsg(h, 'PUSHING')
    GitStatusShell(h, 'git push')
enddef

def! GitStatusUnstage(h: number)
    GitStatusShell(h, 'git restore --staged ' .. expand('<cfile>'))
enddef

def! GitStatusFetch(h: number)
    GitStatusMsg(h, 'FETCHING')
    GitStatusShell(h, 'git fetch')
enddef

def! GitStatusQuit(hStat: number, hMsg: number)
    exe 'silent bw! ' .. hStat .. ' ' .. hMsg
enddef

def! GitStatusAdd(hStat: number, hMsg: number)
    GitStatusMsg(hMsg, 'ADDING ALL FILES')
    GitStatusShell(hMsg, 'git add .')
enddef

def! GitStatus()
    GitHead()

    # TOP ----------------------------------------------------------------
    let hStat = bufadd('Git Status')
    bufload(hStat)
    setbufvar(hStat, '&buflisted', '0')
    setbufvar(hStat, '&buftype', 'nofile')
    setbufvar(hStat, '&colorcolumn', '')
    setbufvar(hStat, '&swapfile', '0')
    GitStatusRefresh(hStat)

    # BOTTOM -------------------------------------------------------------
    let hMsg = bufadd('Git Status - Messages')
    bufload(hMsg)
    setbufvar(hMsg, '&buflisted', '0')
    setbufvar(hMsg, '&buftype', 'nofile')
    setbufvar(hMsg, '&colorcolumn', '')
    setbufvar(hMsg, '&swapfile', '0')

    # TAB ----------------------------------------------------------------
    exe 'tabnew Git Status - Messages'
    let hTab = tabpagenr()
    settabvar(hTab, 'hStat', hStat)
    settabvar(hTab, 'hMsg', hMsg)
    settabvar(hTab, 'title', 'STATUS')

    exe 'split Git Status'
    exe '2resize 20'

    # SYNTAX
    GitColors()

    # LOCAL KEY BINDS
    exe printf("nnoremap <silent><buffer><F3> :cal <SID>GitStatusQuit(%d, %d)<CR>", hStat, hMsg)
    exe printf("nnoremap <silent><buffer><F8> :cal <SID>GitStatusRefresh(%d)<CR>", hStat)
    exe printf('nnoremap <silent><buffer><DEL> :cal <SID>GitStatusUnstage(%d)<CR>', hMsg)
    exe printf('nnoremap <silent><buffer><INS> :cal <SID>GitStatusAdd(%d,%d)<CR>', hStat, hMsg)
    exe printf('nnoremap <silent><buffer><PageDown> :cal <SID>GitStatusFetch(%d)<CR>', hMsg)
    exe printf('nnoremap <silent><buffer><PageUp> :cal <SID>GitStatusPush(%d)<CR>', hMsg)
    nnoremap <silent><buffer><END> :cal <SID>GitCommit()<CR>
enddef
nnoremap <silent><F8> :cal <SID>GitStatus()<CR>


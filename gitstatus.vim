def! GitStatusMsg(h: number, msg: any)
    let c = get(get(getbufinfo(h), 0), 'linecount')
    let l = strlen(get(getbufline(h, '$'), 0))
    appendbufline(h, l > 1 ? c : c - 1, msg)
enddef

def! GitStatusRefresh(h: number)
    let now = reltime()
    deletebufline(h, 1, '$')
    GitStatusMsg(h, systemlist('git status'))
    GitStatusMsg(h, ['',
    '<INS>  ADD ALL   <HOME>  ------  <PGUP>  PUSH',
    '<DEL>  UNSTAGE   <END>   COMMIT  <PGDN>  FETCH',
    '',
    '<F6>   GIT GUI   <F7>    GIT LOG (UNDER CURSOR)',
    '<F8>   REFRESH   <S+F7>  GITK (UNDER CURSOR)',
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
    GitStatusRefresh(gettabvar(tabpagenr(), 'hS'))
    norm gg
enddef

def! GitStatusShell(h: number, cmd: string)
    GitStatusMsg(h, cmd)
    win_execute(2, 'norm G')
    let f = funcref("s:GitStatusShellCallback", [h])
    let e = funcref("s:GitStatusShellExit", [h])
    job_start(cmd, #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def! GitStatusAdd(h: number)
    GitStatusShell(h, 'git add .')
enddef

def! GitStatusFetch(h: number)
    GitStatusShell(h, 'git fetch')
enddef

def! GitStatusPush(h: number)
    GitStatusShell(h, 'git push')
enddef

def! GitStatusUnstage(h: number)
    GitStatusShell(h, 'git restore --staged ' .. expand('<cfile>'))
enddef

def! GitStatusQuit(hS: number, hM: number)
    exe 'silent bw! ' .. hS .. ' ' .. hM
enddef

def! GitStatus()
    GitHead()

    # TOP ----------------------------------------------------------------
    let hS = bufadd('Git Status')
    bufload(hS)
    setbufvar(hS, '&buflisted', '0')
    setbufvar(hS, '&buftype', 'nofile')
    setbufvar(hS, '&colorcolumn', '')
    setbufvar(hS, '&swapfile', '0')
    GitStatusRefresh(hS)

    # BOTTOM -------------------------------------------------------------
    let hM = bufadd('Git Status - Messages')
    bufload(hM)
    setbufvar(hM, '&buflisted', '0')
    setbufvar(hM, '&buftype', 'nofile')
    setbufvar(hM, '&colorcolumn', '')
    setbufvar(hM, '&swapfile', '0')
    GitStatusMsg(hM, 'Ready...')

    # TAB ----------------------------------------------------------------
    exe 'tabnew Git Status - Messages'
    let hT = tabpagenr()
    settabvar(hT, 'hS', hS)
    settabvar(hT, 'hM', hM)
    settabvar(hT, 'title', 'STATUS')

    exe 'split Git Status'
    exe '2resize 20'

    # SYNTAX
    GitColors()

    # LOCAL KEY BINDS
    exe printf("nnoremap <silent><buffer><F3> :cal <SID>GitStatusQuit(%d, %d)<CR>", hS, hM)
    exe printf("nnoremap <silent><buffer><F8> :cal <SID>GitStatusRefresh(%d)<CR>", hS)
    exe printf('nnoremap <silent><buffer><DEL> :cal <SID>GitStatusUnstage(%d)<CR>', hM)
    exe printf('nnoremap <silent><buffer><INS> :cal <SID>GitStatusAdd(%d)<CR>', hM)
    exe printf('nnoremap <silent><buffer><PageDown> :cal <SID>GitStatusFetch(%d)<CR>', hM)
    exe printf('nnoremap <silent><buffer><PageUp> :cal <SID>GitStatusPush(%d)<CR>', hM)
    nnoremap <silent><buffer><END> :cal <SID>GitCommit()<CR>
enddef
nnoremap <silent><F8> :cal <SID>GitStatus()<CR>


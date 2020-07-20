
def! GStatRefresh(hT: number)
    let now = reltime()
    deletebufline(hT, 1, '$')
    let l = systemlist('git status')
    extend(l, ['',
    '<INS>  ADD ALL   <HOME>  ------  <PGUP>  PUSH',
    '<DEL>  UNSTAGE   <END>   COMMIT  <PGDN>  FETCH',
    '',
    '<F6>   GIT GUI   <F7>    GIT LOG (UNDER CURSOR)',
    '<F8>   REFRESH   <S+F7>  GITK (UNDER CURSOR)',
    '', repeat('-', 75)])
    extend(l, systemlist('git log -n5'))
    extend(l, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])
    Say(hT, l)
enddef

def! GStatShellCallback(h: number, chan: number, msg: string)
    let c = get(get(getbufinfo(h), 0), 'linecount')
    let l = strlen(get(getbufline(h, '$'), 0))
    appendbufline(h, l > 1 ? c : c - 1, msg)
enddef

def! GStatShellExit(hT: number, hB: number, chan: number, code: number)
    GStatRefresh(hT)
    win_execute(win_getid(2), 'norm gg')
enddef

def! GStatShell(hT: number, hB: number, cmd: string)
    Say(hT, cmd)
    let f = funcref("s:GStatShellCallback", [hT, hB])
    let e = funcref("s:GStatShellExit", [hT, hB])
    job_start(cmd, #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def! GStatAdd(hT: number, hB: number)
    GStatShell(hT, hB, 'git add .')
enddef

def! GStatFetch(hT: number, hB: number)
    GStatShell(hT, hB, 'git fetch')
enddef

def! GStatPush(hT: number, hB: number)
    GStatShell(hT, hB, 'git push')
enddef

def! GStatUnstage(hT: number, hB: number)
    GStatShell(hT, hB, 'git restore --staged ' .. expand('<cfile>'))
enddef

def! GStatQuit(hT: number, hB: number)
    exe 'sil bw! ' .. hT .. ' ' .. hB
enddef

def! GitStatus()
    GitHead()

    # TOP ----------------------------------------------------------------
    let hT = bufadd('Git Status')
    bufload(hT)
    setbufvar(hT, '&buflisted', '0')
    setbufvar(hT, '&buftype', 'nofile')
    setbufvar(hT, '&swapfile', '0')
    GStatRefresh(hT)

    # BOTTOM -------------------------------------------------------------
    let hB = bufadd('Git Status - Messages')
    bufload(hB)
    setbufvar(hB, '&buflisted', '0')
    setbufvar(hB, '&buftype', 'nofile')
    setbufvar(hB, '&swapfile', '0')
    Say(hB, 'Ready...')

    # TAB ----------------------------------------------------------------
    exe 'tabnew Git Status - Messages'
    let hTab = tabpagenr()
    settabvar(hTab, 'hT', hT)
    settabvar(hTab, 'hB', hB)
    settabvar(hTab, 'title', 'STATUS')

    exe 'split Git Status'
    exe '2resize 20'

    # SYNTAX
    setbufvar(hT, '&colorcolumn', '80')
    setbufvar(hB, '&colorcolumn', '')
    GitColors()

    # LOCAL KEY BINDS
    exe printf('nnoremap <silent><buffer><F3> :cal <SID>GStatQuit(%d, %d)<CR>', hT, hB)
    exe printf('nnoremap <silent><buffer><F8> :cal <SID>GStatRefresh(%d)<CR>', hT)
    exe printf('nnoremap <silent><buffer><DEL> :cal <SID>GStatUnstage(%d, %d)<CR>', hT, hB)
    exe printf('nnoremap <silent><buffer><INS> :cal <SID>GStatAdd(%d, %d)<CR>', hT, hB)
    exe printf('nnoremap <silent><buffer><PageDown> :cal <SID>GStatFetch(%d, %d)<CR>', hT, hB)
    exe printf('nnoremap <silent><buffer><PageUp> :cal <SID>GStatPush(%d, %d)<CR>', hT, hB)
    nnoremap <silent><buffer><END> :cal <SID>GitCommit()<CR>
enddef
nnoremap <silent><F8> :cal <SID>GitStatus()<CR>


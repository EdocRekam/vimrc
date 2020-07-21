
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
    '', repeat('-', 80)])

    for i in systemlist('git log -n5')
        add(l, substitute(i, '^\s\s\s\s$', '', ''))
    endfor
    extend(l, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])
    Say(hT, l)
    win_execute(win_getid(1), 'norm gg')
enddef

def! GStatShellExit(hT: number, hB: number, chan: number, code: number)
    GStatRefresh(hT)
enddef

def! GStatShell(hT: number, hB: number, cmd: string)
    Say(hB, cmd)
    let f = funcref("s:SayCallback", [hB])
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

def! GitStatus()
    GHead()

    # TOP ----------------------------------------------------------------
    let tT = 'Git Status'
    let hT = bufadd(tT)
    bufload(hT)
    GStatRefresh(hT)

    # BOTTOM -------------------------------------------------------------
    let tB = tT .. ' - Messages'
    let hB = bufadd(tB)
    bufload(hB)
    Say(hB, 'Ready...')

    # TAB ----------------------------------------------------------------
    exe 'tabnew ' .. tB
    settabvar(tabpagenr(), 'title', 'STATUS')

    exe 'split ' .. tT
    exe '2resize 20'

    Hide(hT)
    Hide(hB)

    # SYNTAX
    setbufvar(hT, '&colorcolumn', '80')
    setbufvar(hB, '&colorcolumn', '')
    GColor()

    # LOCAL KEY BINDS
    let cmd = 'nnoremap <silent><buffer>'
    exe printf("%s<F3> :exe 'sil bw! %d %d'<CR> ", cmd, hT, hB)
    exe printf('%s<F8> :cal <SID>GStatRefresh(%d)<CR>', cmd, hT)
    exe printf('%s<DEL> :cal <SID>GStatUnstage(%d, %d)<CR>', cmd, hT, hB)
    exe printf('%s<INS> :cal <SID>GStatAdd(%d, %d)<CR>', cmd, hT, hB)
    exe printf('%s<PageDown> :cal <SID>GStatFetch(%d, %d)<CR>', cmd, hT, hB)
    exe printf('%s<PageUp> :cal <SID>GStatPush(%d, %d)<CR>', cmd, hT, hB)
    nnoremap <silent><buffer><END> :cal <SID>GitCommit()<CR>
enddef
nnoremap <silent><F8> :cal <SID>GitStatus()<CR>


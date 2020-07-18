" COMMIT TEMPLATE
let ct = '.git/GITGUI_MSG'

def! GitCommitShellCallback(h: number, chan: number, msg: string)
    let c = get(get(getbufinfo(h), 0), 'linecount')
    let l = strlen(get(getbufline(h, '$'), 0))
    appendbufline(h, l > 1 ? c : c - 1, msg)
enddef

def! GitCommitShellExit(h: number, chan: number, code: number)
    if 0 == code && filereadable(ct)
        delete(ct)
    endif
enddef

def! GitCommitShell(h: number, cmd: string)
    let f = funcref("s:GitCommitShellCallback", [h])
    let e = funcref("s:GitCommitShellExit", [h])
    job_start(cmd, #{out_cb: f,
    err_cb: f,
    exit_cb: e})
enddef

def! GitCommitMsg(h: number, msg: any)
    let c = get(get(getbufinfo(h), 0), 'linecount')
    let l = strlen(get(getbufline(h, '$'), 0))
    appendbufline(h, l > 1 ? c : c - 1, msg)
enddef

def! GitCommitQuit(hMsg: number, hCommit: number)
    if 1 == getbufvar(hMsg, '&modifiable')
        exe printf('au! BufWritePost <buffer=%d>', hMsg)
        exe 'silent g/^#.*/d'
        exe 'silent write ' .. ct
    endif
    exe 'silent bw! ' .. hMsg .. ' ' .. hCommit
enddef

def! GitCommitGo()
    let hMsg = gettabvar(tabpagenr(), 'hMsg', 0)
    let hCommit = gettabvar(tabpagenr(), 'hCommit', 0)

    let cmd = 'git commit --cleanup=strip -F ' .. ct
    GitCommitMsg(hCommit, 'Switching to read-only mode.')
    GitCommitMsg(hCommit, cmd)
    setbufvar(hMsg, '&modifiable', 0)
    GitCommitShell(hCommit, cmd)
enddef

def! GitCommit()
    let now = reltime()

    # TOP ----------------------------------------------------------------
    let hMsg = bufadd(ct)
    bufload(hMsg)
    setbufvar(hMsg, '&syntax', 'gitcommit')
    exe printf('au! BufWritePost <buffer=%d> ++once :cal GitCommitGo()', hMsg)

    GitCommitMsg(hMsg, [
    '# Please enter the commit message for your changes. Lines starting',
    "# with '#' will be ignored, and an empty message aborts the commit.",
    '#'])

    for l in systemlist('git status')
        GitCommitMsg(hMsg, printf('#%s%s', '' == l ? '' : ' ', l))
    endfor
    GitCommitMsg(hMsg, ['#',
    '# PRESS <F3> TO ABORT OR CLOSE COMMIT WINDOW'])

    # BOTTOM -------------------------------------------------------------
    let hCommit = bufadd('COMMIT')
    bufload(hCommit)
    setbufvar(hCommit, '&buflisted', '0')
    setbufvar(hCommit, '&buftype', 'nofile')
    setbufvar(hCommit, '&colorcolumn', '')
    setbufvar(hCommit, '&swapfile', '0')
    GitCommitMsg(hCommit, 'Waiting for save ...')

    # TAB ----------------------------------------------------------------
    tabnew COMMIT
    let hTab = tabpagenr()
    settabvar(hTab, 'hCommit', hCommit)
    settabvar(hTab, 'hMsg', hMsg)
    settabvar(hTab, 'title', 'COMMIT')

    split .git/GITGUI_MSG
    exe printf("nnoremap <silent><buffer><F3> :cal <SID>GitCommitQuit(%d, %d)<CR>", hMsg, hCommit)
    exe '2resize 20'

    # PERFORMANCE
    GitCommitMsg(hMsg, '# Time:' .. reltimestr(reltime(now, reltime())))
enddef


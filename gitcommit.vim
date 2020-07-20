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
    job_start(cmd, #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def! GitCommitQuit(hT: number, hB: number)
    if 1 == getbufvar(hT, '&modifiable')
        exe printf('au! BufWritePost <buffer=%d>', hT)
        exe 'silent g/^#.*/d'
        exe 'silent write ' .. ct
    endif
    exe 'silent bw! ' .. hT .. ' ' .. hB
enddef

def! GitCommitGo()
    let hT = gettabvar(tabpagenr(), 'hT', 0)
    let hB = gettabvar(tabpagenr(), 'hB', 0)

    let cmd = 'git commit --cleanup=strip -F ' .. ct
    Say(hB, 'Switching to read-only mode.')
    Say(hB, cmd)
    setbufvar(hT, '&modifiable', 0)
    GitCommitShell(hB, cmd)
enddef

def! GitCommit()
    let now = reltime()

    # TOP ----------------------------------------------------------------
    let hT = bufadd(ct)
    bufload(hT)
    setbufvar(hT, '&syntax', 'gitcommit')
    exe printf('au! BufWritePost <buffer=%d> ++once :cal GitCommitGo()', hT)

    Say(hT, [
    '# Please enter the commit message for your changes. Lines starting',
    "# with '#' will be ignored, and an empty message aborts the commit.",
    '#'])

    for l in systemlist('git status')
        Say(hT, printf('#%s%s', '' == l ? '' : ' ', l))
    endfor
    Say(hT, ['#',
    '# PRESS <F3> TO ABORT OR CLOSE COMMIT WINDOW'])

    # BOTTOM -------------------------------------------------------------
    let hB = bufadd('COMMIT')
    bufload(hB)
    setbufvar(hB, '&buflisted', '0')
    setbufvar(hB, '&buftype', 'nofile')
    setbufvar(hB, '&colorcolumn', '')
    setbufvar(hB, '&swapfile', '0')
    Say(hB, 'Waiting for save ...')

    # TAB ----------------------------------------------------------------
    tabnew COMMIT
    let hTab = tabpagenr()
    settabvar(hTab, 'hB', hB)
    settabvar(hTab, 'hT', hT)
    settabvar(hTab, 'title', 'COMMIT')

    split .git/GITGUI_MSG
    exe printf("nnoremap <silent><buffer><F3> :cal <SID>GitCommitQuit(%d, %d)<CR>", hT, hB)
    exe '2resize 20'

    # PERFORMANCE
    Say(hT, '# Time:' .. reltimestr(reltime(now, reltime())))
enddef


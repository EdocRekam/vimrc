" COMMIT TEMPLATE
let ct = '.git/GITGUI_MSG'

def! GComShellExit(h: number, chan: number, code: number)
    if 0 == code && filereadable(ct)
        delete(ct)
    endif
enddef

def! GComShell(h: number, cmd: string)
    let f = funcref("s:SayCallback", [h])
    let e = funcref("s:GComShellExit", [h])
    job_start(cmd, #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def! GComQuit(hT: number, hB: number)
    if 1 == getbufvar(hT, '&modifiable')
        exe printf('au! BufWritePost <buffer=%d>', hT)
        exe 'sil g/^#.*/d'
        exe 'sil write ' .. ct
    endif
    exe 'sil bw! ' .. hT .. ' ' .. hB
enddef

def! GComGo(hT: number, hB: number)
    let cmd = 'git commit --cleanup=strip -F ' .. ct
    Say(hB, 'Switching to read-only mode.')
    Say(hB, cmd)
    setbufvar(hT, '&modifiable', 0)
    GComShell(hB, cmd)
enddef

def! GitCommit()
    let now = reltime()

    # BOTTOM -------------------------------------------------------------
    exe 'tabnew Commit - ' .. reltimestr(now)
    settabvar(tabpagenr(), 'title', 'COMMIT')
    let hB = bufnr()
    Hide(hB)
    setbufvar(hB, '&colorcolumn', '')
    Say(hB, 'Waiting for save ...')

    # TOP ----------------------------------------------------------------
    let pad = filereadable(ct) ? 0 : 1
    exe 'split ' .. ct
    let hT = bufnr()
    setbufvar(hT, '&syntax', 'gitcommit')
    :2resize 20'

    if pad
        Say(hT, ['', ''])
    endif

    Say(hT, [
    '# Please enter the commit message for your changes. Lines starting',
    "# with '#' will be ignored, and an empty message aborts the commit.",
    '#'])

    for i in systemlist('git status')
        Say(hT, printf('#%s%s', '' == i ? '' : ' ', i))
    endfor
    Say(hT, ['#', '# PRESS <F3> TO ABORT OR CLOSE COMMIT WINDOW'])
    norm gg
    :star

    exe printf('au! BufWritePost <buffer=%d> ++once :cal GComGo(%d, %d)', hT, hT, hB)
    exe printf("nnoremap <silent><buffer><F3> :cal <SID>GComQuit(%d, %d)<CR>", hT, hB)

    # PERFORMANCE
    Say(hT, '# Time:' .. reltimestr(reltime(now, reltime())))
enddef


# COMMIT TEMPLATE
let ct = '.git/GITGUI_MSG'

def GCShellExit(h: number, j: job, code: number)
    if 0 == code && filereadable(ct)
        delete(ct)
    endif
enddef

def GCShell(h: number, cmd: string)
    let f = funcref("s:SayCallback", [h])
    let e = funcref("s:GCShellExit", [h])
    job_start(cmd, #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def GCQuit(hT: number, hB: number)
    if 1 == getbufvar(hT, '&modifiable')
        exe printf('au! BufWritePost <buffer=%d>', hT)
        exe 'sil g/^#.*/d | write ' .. ct
    endif
    exe 'sil bw! ' .. hT .. ' ' .. hB
enddef

def GCGo(hT: number, hB: number)
    let cmd = 'git commit --cleanup=strip -F ' .. ct
    Say(hB, 'Switching to read-only mode.')
    Say(hB, cmd)
    setbufvar(hT, '&modifiable', 0)
    GCShell(hB, cmd)
enddef

def GitCommit()
    let now = reltime()

    # BOTTOM -------------------------------------------------------------
    exe 'tabnew Commit - ' .. reltimestr(now)
    settabvar(tabpagenr(), 'title', 'COMMIT')
    let hB = bufnr()
    Sbo(hB)
    setbufvar(hB, '&colorcolumn', '')
    Say(hB, 'Waiting for save ...')

    # TOP ----------------------------------------------------------------
    exe 'split ' .. ct
    let hT = bufnr()
    setbufvar(hT, '&syntax', 'gitcommit')
    :2resize 20'

    # MISSING COMMIT TEMPLATE MEANS THIS IS A NEW COMMIT SO PREFIX
    # TWO BLANK LINKS
    if 0 == filereadable(ct)
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

    # POSITION
    norm gg
    :star

    exe printf('au! BufWritePost <buffer=%d> ++once :cal GCGo(%d, %d)', hT, hT, hB)
    exe printf("nnoremap <silent><buffer><F3> :cal <SID>GCQuit(%d, %d)<CR>", hT, hB)

    # PERFORMANCE
    Say(hT, '# Time:' .. reltimestr(reltime(now, reltime())))
enddef


# COMMIT TEMPLATE
var ct = '.git/GITGUI_MSG'

# EXIT JOB CALLBACK - DELETE COMMIT TEMPLATE IS EXIT CODE IS 0
def GC1(j: job, c = 0)
    if 0 == c && filereadable(ct)
        delete(ct)
    en
enddef

# F3 QUIT - THE USER SAVED COMMIT MESSAGE IF THE TOP WINDOW IS
# LOCKED; OTHERWISE STRIP COMMENTS FROM COMMIT MESSAGE AND STASH IT
# FOR FURTHER RECALL. CLOSE TOP/BOTTOM WINDOWS
def GC2(hT = 0, hB = 0)
    if 1 == getbufvar(hT, '&modifiable')
        exe 'au! BufWritePost <buffer=' .. hT .. '>'
        win_execute(win_getid(1), 'g/^#.*$/d')
        :up
    en
    exe 'bw! ' .. hT .. ' ' .. hB
enddef

# RUN THIS WHEN THE COMMIT MESSAGE WAS SAVED. THIS MEANS WE CAN LOCK
# THE TOP WINDOW AND RUN THE ACTUAL COMMIT
def GC3(hT = 0, hB = 0)
    # LOCK TOP WINDOW
    Say(hB, 'Switching to read-only mode.')
    stopi
    setbufvar(hT, '&modifiable', 0)

    var c = 'git commit --cleanup=strip -F ' .. ct
    Say(hB, c)
    var F = funcref(SayCb, [hB])
    job_start(c, {out_cb: F, err_cb: F, exit_cb: GC1})
enddef

def GitCommit()
    # NOW
    var n = reltime()

    # BOTTOM -------------------------------------------------------------
    exe 'tabnew Commit - ' .. reltimestr(n)
    settabvar(tabpagenr(), 'title', 'COMMIT')
    var hB = bufnr()
    T3(hB)
    setbufvar(hB, '&colorcolumn', '')
    Say(hB, 'Waiting for save ...')

    # TOP ----------------------------------------------------------------
    exe 'split ' .. ct
    var hT = bufnr()
    setbufvar(hT, '&syntax', 'gitcommit')
    :2resize 20

    # MISSING COMMIT TEMPLATE MEANS THIS IS A NEW COMMIT SO PREFIX
    # TWO BLANK LINKS
    if 0 == filereadable(ct)
        Say(hT, ['', ''])
    en

    Say(hT, [
    '# Please enter the commit message for your changes. Lines starting',
    "# with '#' will be ignored, and an empty message aborts the commit.",
    '#'])

    for i in S('git status')
        Say(hT, printf('#%s%s', '' == i ? '' : ' ', i))
    endfo
    Say(hT, ['#', '# PRESS <F3> TO ABORT OR CLOSE COMMIT WINDOW'])

    # POSITION
    norm gg
    star

    exe printf('au! BufWritePost <buffer=%d> ++once :cal GC3(%d, %d)', hT, hT, hB)
    G1(hT, hB, 'F3', 'GC2')

    # PERFORMANCE
    Say(hT, '# Time:' .. reltimestr(reltime(n, reltime())))
enddef


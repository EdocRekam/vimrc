
def! GSRef(hT: number, b = 1)
    # GET THE CURRENT TIME FOR SPEED METRIC
    let now = reltime()

    # CLEAR BUFFER AND EXISTING SYNTAX (b == 1)
    if b
        deletebufline(hT, 1, '$')
        sy clear M
    endif

    let l = systemlist('git status')

    Region('M', len(l) + 2, 5, 'l', 'contains=@NoSpell,P,MC,MK')
    extend(l, ['',
    '<INS>  ADD ALL   |  <HOME>  ---------  |  <PGUP>  PUSH      |',
    '<DEL>  UNSTAGE   |  <END>   COMMIT     |  <PGDN>  FETCH     |',
    '                 |                     |                    |',
    '<F1>   MENU      |  <F2>    ---------  |  <F3>    CLOSE     |  <F4>  INSPECT',
    '<F5>   BRANCH    |  <F6>    GUI        |  <F7>    LOG/GITK  |  <F8>  REFRESH',
    '', repeat('-', 79)])

    for i in systemlist('git log -n5')
        add(l, substitute(i, '^\s\s\s\s$', '', ''))
    endfor
    extend(l, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])
    Say(hT, l)
    win_execute(win_getid(1), 'norm gg')
enddef

def! GSeXit(hT: number, hB: number, chan: number, code: number)
    GSRef(hT)
enddef

def! GSex(hT: number, hB: number, cmd: string)
    Say(hB, cmd)
    let f = funcref("s:SayCallback", [hB])
    let e = funcref("s:GSeXit", [hT, hB])
    job_start(cmd, #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def! GSAdd(hT: number, hB: number)
    GSex(hT, hB, 'git add .')
enddef

def! GSFet(hT: number, hB: number)
    GSex(hT, hB, 'git fetch')
enddef

def! GSPsh(hT: number, hB: number)
    GSex(hT, hB, 'git push')
enddef

def! GSUns(hT: number, hB: number)
    GSex(hT, hB, 'git restore --staged ' .. expand('<cfile>'))
enddef

def! GSIns(hB: number)
    let o = expand('<cfile>')
    if strchars(o) > 5
        Say(hB, "call GLog('" .. o .. "')")
        GLog(o)
    endif
enddef

def! GitStatus()
    GHead()

    # OPEN EXISTING WINDOW
    let hT = bufnr('Git Status')
    if -1 != hT
        win_gotoid(get(hT->win_findbuf(), 0))
        GSRef(hT)
    else
        # BOTTOM ---------------------------------------------------------
        exe 'tabnew Git Status - Messages'
        settabvar(tabpagenr(), 'title', 'STATUS')
        let hB = bufnr()
        Say(hB, 'Ready...')
        Hide(hB)
        setbufvar(hB, '&colorcolumn', '')

        # TOP ------------------------------------------------------------
        exe 'split Git Status'
        hT = bufnr()
        setbufvar(hT, '&colorcolumn', '80')
        :ownsyntax gitstatus
        :2resize 20
        GSRef(hT, 0)
        Hide(hT)

        # SYNTAX
        sy match L "modified:.*$" display
        GColor()

        # LABELS
        sy keyword LBL author commit date

        # LOCAL KEY BINDS
        let cmd = 'nnoremap <silent><buffer>'
        exe printf("%s<F3> :exe 'sil bw! %d %d'<CR>", cmd, hT, hB)
        exe printf('%s<F4> :cal <SID>GSIns(%d)<CR>', cmd, hB)
        exe printf('%s<F8> :cal <SID>GSRef(%d)<CR>', cmd, hT)
        exe printf('%s<DEL> :cal <SID>GSUns(%d, %d)<CR>', cmd, hT, hB)
        exe printf('%s<INS> :cal <SID>GSAdd(%d, %d)<CR>', cmd, hT, hB)
        exe printf('%s<PageDown> :cal <SID>GSFet(%d, %d)<CR>', cmd, hT, hB)
        exe printf('%s<PageUp> :cal <SID>GSPsh(%d, %d)<CR>', cmd, hT, hB)
        nnoremap <silent><buffer><END> :cal <SID>GitCommit()<CR>
    endif
enddef
nnoremap <silent><F8> :cal <SID>GitStatus()<CR>


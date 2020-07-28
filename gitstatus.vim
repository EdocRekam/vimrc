
def GSRef(hT: number, b = 1)
    # GET THE CURRENT TIME FOR SPEED METRIC
    let now = reltime()

    # CLEAR BUFFER AND EXISTING SYNTAX (b == 1)
    if b
        deletebufline(hT, 1, '$')
        sy clear M
    en

    let l = systemlist('git status')

    Region('M', len(l) + 2, 5, 'l', 'contains=@NoSpell,P,MC,MK')
    extend(l, ['',
    '<INS>  ADD ALL  |  <S-HOME> RESTORE  |  <PGUP>  PUSH      |',
    '<DEL>  UNSTAGE  |  <END>    COMMIT   |  <PGDN>  FETCH     |',
    '                |                    |                    |',
    '<F1>   MENU     |  <F2>     -------  |  <F3>    CLOSE     |  <F4>  INSPECT',
    '<F5>   BRANCH   |  <F6>     GUI      |  <F7>    LOG/GITK  |  <F8>  REFRESH',
    '', repeat('-', 79)])

    for i in systemlist('git log -n5')
        add(l, substitute(i, '^\s\s\s\s$', '', ''))
    endfor
    extend(l, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])
    Say(hT, l)
    win_execute(win_getid(1), 'norm gg')
enddef

def GSeXit(hT: number, hB: number, j: job, code: number)
    GSRef(hT)
enddef

def GSex(hT: number, hB: number, cmd: string)
    Say(hB, cmd)
    let f = funcref("s:SayCallback", [hB])
    let e = funcref("s:GSeXit", [hT, hB])
    job_start(cmd, #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def GSAdd(hT: number, hB: number)
    GSex(hT, hB, 'git add .')
enddef

def GSFet(hT: number, hB: number)
    GSex(hT, hB, 'git fetch')
enddef

def GSPsh(hT: number, hB: number)
    GSex(hT, hB, 'git push')
enddef

def GSRes(hT: number, hB: number)
    let o = expand('<cfile>')
    if filereadable(o)
        GSex(hT, hB, 'git restore ' .. o)
    en
enddef

def GSUns(hT: number, hB: number)
    let o = expand('<cfile>')
    if filereadable(o)
        GSex(hT, hB, 'git restore --staged ' .. o)
    en
enddef

def GSIg(hT: number, hB: number)
    let o = expand('<cfile>')
    :tabnew .gitignore
    if filereadable(o)
        append('$', o)
    en
    norm G
enddef

def GSIns(hB: number)
    let o = expand('<cfile>')
    if filereadable(o)
        exe 'tabnew ' .. o
        let hR = bufnr()

        exe 'vsplit HEAD:' .. o
        let hL = bufnr()
        Hide(hL)
        GShow(hL, 'HEAD', o)
        win_execute(win_getid(2), 'norm gg')

        # LOCAL KEY BINDS
        exe printf("nnoremap <silent><buffer><F3> :exe 'sil bw! %d %d'<CR> ", hL, hR)
    en
enddef

def GitStatus()
    GHead()

    # OPEN EXISTING WINDOW
    let hT = bufnr('Git Status')
    if -1 != hT
        win_gotoid(get(hT->win_findbuf(), 0))
        GSRef(hT)
    else
        # BOTTOM ---------------------------------------------------------
        tabnew Git Status - Messages
        settabvar(tabpagenr(), 'title', 'STATUS')
        let hB = bufnr()
        Say(hB, 'Ready...')
        Hide(hB)
        setbufvar(hB, '&colorcolumn', '')

        # TOP ------------------------------------------------------------
        split Git Status
        hT = bufnr()
        setbufvar(hT, '&colorcolumn', '80')
        ownsyntax gitstatus
        :2resize 20
        GSRef(hT, 0)
        Hide(hT)

        # SYNTAX
        sy match L "modified:.*$" display
        sy match DiffDelete "deleted:.*$" display
        GColor()

        # LABELS
        sy keyword LBL author commit date

        # LOCAL KEY BINDS
        let m = 'nnoremap <silent><buffer><'
        exe printf("%sF3> :exe 'sil bw! %d %d'<CR>", m, hT, hB)
        exe printf('%sF4> :cal <SID>GSIns(%d)<CR>', m, hB)
        exe printf('%sF8> :cal <SID>GSRef(%d)<CR>', m, hT)
        exe printf('%sc-i> :cal <SID>GSIg(%d, %d)<CR>', m, hT, hB)
        exe printf('%sDEL> :cal <SID>GSUns(%d, %d)<CR>', m, hT, hB)
        exe printf('%sINS> :cal <SID>GSAdd(%d, %d)<CR>', m, hT, hB)
        exe printf('%sS-HOME> :cal <SID>GSRes(%d, %d)<CR>', m, hT, hB)
        exe printf('%sPageDown> :cal <SID>GSFet(%d, %d)<CR>', m, hT, hB)
        exe printf('%sPageUp> :cal <SID>GSPsh(%d, %d)<CR>', m, hT, hB)
        nnoremap <silent><buffer><END> :cal <SID>GitCommit()<CR>
    en
enddef
nnoremap <silent><F8> :cal <SID>GitStatus()<CR>

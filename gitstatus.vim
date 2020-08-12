
def GSRef(hT: number, hB: number, b = 1)
    # GET THE CURRENT TIME FOR SPEED METRIC
    let now = reltime()

    # CLEAR BUFFER AND EXISTING SYNTAX (b == 1)
    if b
        deletebufline(hT, 1, '$')
        sy clear M LOG
    en

    let l = systemlist('git status')

    T2('M', len(l) + 2, 5, 'l', 'contains=@NoSpell,P,MC,MK')
    extend(l, ['',
    '<INS>  ADD ALL  |  <S-HOME> RESTORE  |  <PGUP>  PUSH      |',
    '<DEL>  UNSTAGE  |  <END>    COMMIT   |  <PGDN>  FETCH     |',
    '                |                    |                    |',
    '<F1>   MENU     |  <F2>     AMEND    |  <F3>    CLOSE     |  <F4>  INSPECT',
    '<F5>   BRANCH   |  <F6>     GUI      |  <F7>    LOG/GITK  |  <F8>  REFRESH',
    '', 'Remotes: ' .. R, repeat('-', 79)])

    let log = systemlist('git log --date=short -n5')
    T2('LOG', len(l) + 1, len(log), 'l', 'contains=A,D,LBL,L,P')
    for i in log
        add(l, substitute(i, '^\s\s\s\s$', '', ''))
    endfo

    extend(l, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])
    Say(hT, l)
    win_execute(win_getid(1), ':1')
enddef

def GSeXit(hT: number, hB: number, j: job, code: number)
    GSRef(hT, hB)
enddef

def GSex(hT: number, hB: number, cmd: string)
    Say(hB, cmd)
    let f = funcref(SayCb, [hB])
    let e = funcref(GSeXit, [hT, hB])
    job_start(cmd, #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def GSAdd(hT: number, hB: number)
    GSex(hT, hB, 'git add .')
enddef

# SCRIPT VARIABLE `ct` DEFINED IN `gitcommit.vim`
def GCAmd(hT: number, hB: number)
    let log = systemlist("git log -n1 --format='%s%n%n%b'")
    GSex(hT, hB, 'git reset --soft HEAD^')
    writefile(log, ct)
enddef

def GSFet(hT: number, hB: number)
    let o = T9()
    GSex(hT, hB, IsR(o) ? 'git fetch ' .. o .. ' ' .. Head : 'git fetch')
enddef

def GSPsh(hT: number, hB: number)
    let o = T9()
    GSex(hT, hB, IsR(o) ? 'git push -u ' .. o .. ' ' .. Head : 'git push')
enddef

def GSRes(hT: number, hB: number)
    let o = T1()
    if filereadable(o)
        GSex(hT, hB, 'git restore ' .. o)
    en
enddef

def GSUns(hT: number, hB: number)
    let o = T1()
    if filereadable(o)
        GSex(hT, hB, 'git restore --staged ' .. o)
    en
enddef

def GSIg(hT: number, hB: number)
    let o = T1()
    :tabnew .gitignore
    if filereadable(o)
        append('$', o)
    en
    norm G
enddef

# INSPECT THE FILE UNDER CURSOR (BEFORE|AFTER)
def GSIns(hT: number, hB: number)
    let o = T1()
    if filereadable(o)
        # RIGHT = AFTER
        exe 'tabnew ' .. o
        let hR = bufnr()
        settabvar(tabpagenr(), 'title', 'B:A')

        # LEFT = BEFORE
        exe 'vsplit B:' .. o
        let hL = bufnr()
        T3(hL)
        GShow(hL, 'HEAD', o)
        windo :1
        windo set scb

        # LOCAL KEY BINDS
        G0(hL, hR)
    en
enddef

def GitStatus()
    # HEAD
    G8()

    # OPEN EXISTING WINDOW
    let hT = bufnr('Git Status')
    if -1 != hT
        win_gotoid(get(hT->win_findbuf(), 0))
        GSRef(hT, 0, 1)
    else
        # BOTTOM ---------------------------------------------------------
        tabnew Git Status - Messages
        settabvar(tabpagenr(), 'title', 'STATUS')
        let hB = bufnr()
        Say(hB, 'Ready...')
        T3(hB)
        setbufvar(hB, '&colorcolumn', '')

        # TOP ------------------------------------------------------------
        split Git Status
        hT = bufnr()
        setbufvar(hT, '&colorcolumn', '80')
        ownsyntax gitstatus
        :2resize 20
        GSRef(hT, hB, 0)
        T3(hT)

        # SYNTAX
        sy match D "deleted:.*$" display
        sy match LBL "modified:.*$" display
        sy match MC "new file:.*$" display
        G7()

        # LABELS
        sy keyword LBL author commit date

        # LOCAL KEY BINDS
        G0(hT, hB)
        G1(hT, hB, 'F2', 'GCAmd')
        G1(hT, hB, 'F4', 'GSIns')
        G1(hT, hB, 'F8', 'GSRef')
        G1(hT, hB, 'c-i', 'GSIg')
        G1(hT, hB, 'DEL', 'GSUns')
        G1(hT, hB, 'INS', 'GSAdd')
        G1(hT, hB, 'S-HOME', 'GSRes')
        G1(hT, hB, 'PageDown', 'GSFet')
        G1(hT, hB, 'PageUp', 'GSPsh')

        nn <silent><buffer><END> :cal <SID>GitCommit()<CR>
    en
enddef
T0('F8', 'GitStatus')

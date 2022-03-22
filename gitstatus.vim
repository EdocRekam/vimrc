
def GSRef(hT = 0, hB = 0, b = 1)
    # GET THE CURRENT TIME FOR SPEED METRIC
    var n = reltime()

    # CLEAR BUFFER AND EXISTING SYNTAX (b == 1)
    if b
        deletebufline(hT, 1, '$')
        sy clear M LOG
    endif

    var l = S('git status')

    T2('M', len(l) + 2, 5, 'l', 'contains=@NoSpell,P,MC,MK')
    extend(l, ['',
    '<INS>  ADD ALL  |  <S-HOME> RESTORE  |  <PGUP>  PUSH      |',
    '<DEL>  UNSTAGE  |  <END>    COMMIT   |  <PGDN>  FETCH     |',
    '                |                    |                    |',
    '<F1>   MENU     |  <F2>     AMEND    |  <F3>    CLOSE     |  <F4>  INSPECT',
    '<F5>   BRANCH   |  <F6>     GUI      |  <F7>    LOG/GITK  |  <F8>  REFRESH',
    '', 'Remotes: ' .. R, repeat('-', 79)])

    var log = S('git log --date=short -n5')
    T2('LOG', len(l) + 1, len(log), 'l', 'contains=A,D,LBL,L,P')
    for i in log
        add(l, substitute(i, '^\s\s\s\s$', '', ''))
    endfor

    extend(l, ['', '', 'Time:' .. reltimestr(reltime(n, reltime()))])
    Say(hT, l)
    win_execute(win_getid(1), ':1')
enddef

def GSeXit(hT: number, hB: number, j: job, c = 0)
    GSRef(hT, hB)
enddef

def GSex(hT = 0, hB = 0, cmd = '')
    Say(hB, cmd)
    var F = funcref(SayCb, [hB])
    var E = funcref(GSeXit, [hT, hB])
    job_start(cmd, {out_cb: F, err_cb: F, exit_cb: E})
enddef

def GSAdd(hT = 0, hB = 0)
    GSex(hT, hB, 'git add .')
enddef

# SCRIPT VARIABLE `ct` DEFINED IN `gitcommit.vim`
def GCAmd(hT = 0, hB = 0)
    var log = S(['git', 'log', '-n1', '--format=%s%n%n%b'])
    GSex(hT, hB, 'git reset --soft HEAD^')
    writefile(log, ct)
enddef

def GSFet(hT = 0, hB = 0)
    var o = T9()
    GSex(hT, hB, IsR(o) ? 'git fetch ' .. o .. ' ' .. Head : 'git fetch')
enddef

def GSPsh(hT = 0, hB = 0)
    var o = T9()
    GSex(hT, hB, IsR(o) ? 'git push -u ' .. o .. ' ' .. Head : 'git push')
enddef

def GSRes(hT = 0, hB = 0)
    var o = T1()
    if filereadable(o)
        GSex(hT, hB, 'git restore ' .. o)
    endif
enddef

def GSUns(hT = 0, hB = 0)
    var o = T1()
    if filereadable(o)
        GSex(hT, hB, 'git restore --staged ' .. o)
    endif
enddef

# OPEN .gitignore IN TAB
def GSIg(hT = 0, hB = 0)
    var o = T1()
    tabnew .gitignore
    if filereadable(o)
        append('$', o)
    endif
    norm G
enddef

# INSPECT THE FILE UNDER CURSOR (BEFORE|AFTER)
def GSIns(hT = 0, hB = 0)
    var o = T1()
    if filereadable(o)
        # RIGHT = AFTER
        exe 'tabnew ' .. o
        var hR = bufnr()
        settabvar(tabpagenr(), 'title', 'B:A')

        # LEFT = BEFORE
        exe 'vsplit B:' .. o
        var hL = bufnr()
        T3(hL)
        GS1(hL, 'HEAD', o)
        windo :1
        windo set scb

        # LOCAL KEY BINDS
        G0(hL, hR)
    endif
enddef

def GitStatus()
    # HEAD
    G8()

    # OPEN EXISTING WINDOW
    var hT = bufnr('Git Status')
    if -1 != hT
        win_gotoid(get(hT->win_findbuf(), 0))
        GSRef(hT, 0, 1)
    else
        # BOTTOM ---------------------------------------------------------
        tabnew Git Status - Messages
        settabvar(tabpagenr(), 'title', 'STATUS')
        var hB = bufnr()
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
        sy match LBL "both modified:.*$" display
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
    endif
enddef
T0('F8', 'GitStatus')

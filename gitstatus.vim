
def GSRef(hT: number, hB: number, b = 1)
    # GET THE CURRENT TIME FOR SPEED METRIC
    let now = reltime()

    # CLEAR BUFFER AND EXISTING SYNTAX (b == 1)
    if b
        deletebufline(hT, 1, '$')
        sy clear M LOG
    en

    let l = systemlist('git status')

    Region('M', len(l) + 2, 5, 'l', 'contains=@NoSpell,P,MC,MK')
    extend(l, ['',
    '<INS>  ADD ALL  |  <S-HOME> RESTORE  |  <PGUP>  PUSH      |',
    '<DEL>  UNSTAGE  |  <END>    COMMIT   |  <PGDN>  FETCH     |',
    '                |                    |                    |',
    '<F1>   MENU     |  <F2>     AMEND    |  <F3>    CLOSE     |  <F4>  INSPECT',
    '<F5>   BRANCH   |  <F6>     GUI      |  <F7>    LOG/GITK  |  <F8>  REFRESH',
    '', 'Remotes: ' .. R, repeat('-', 79)])

    let log = systemlist('git log --date=short -n5')
    Region('LOG', len(l) + 1, len(log), 'l', 'contains=A,D,LBL,L,P')
    for i in log
        add(l, substitute(i, '^\s\s\s\s$', '', ''))
    endfor

    extend(l, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])
    Say(hT, l)
    win_execute(win_getid(1), 'norm gg')
enddef

def GSeXit(hT: number, hB: number, j: job, code: number)
    GSRef(hT, hB)
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

# SCRIPT VARIABLE `ct` DEFINED IN `gitcommit.vim`
def GCAmd(hT: number, hB: number)
    let log = systemlist("git log -n1 --format='%s%n%n%b'")
    GSex(hT, hB, 'git reset --soft HEAD^')
    writefile(log, ct)
enddef

def GSFet(hT: number, hB: number)
    let o = expand('<cword>')
    GSex(hT, hB, IsR(o) ? 'git fetch ' .. o .. ' ' .. Head : 'git fetch')
enddef

def GSPsh(hT: number, hB: number)
    let o = expand('<cword>')
    GSex(hT, hB, IsR(o) ? 'git push -u ' .. o .. ' ' .. Head : 'git push')
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

# INSPECT THE FILE UNDER CURSOR (BEFORE|AFTER)
def GSIns(hT: number, hB: number)
    let o = expand('<cfile>')
    if filereadable(o)
        # RIGHT = AFTER
        exe 'tabnew ' .. o
        let hR = bufnr()
        settabvar(tabpagenr(), 'title', 'B:A')

        # LEFT = BEFORE
        exe 'vsplit B:' .. o
        let hL = bufnr()
        Sbo(hL)
        GShow(hL, 'HEAD', o)
        windo :1
        windo set scb

        # LOCAL KEY BINDS
        MapClose(hL, hR)
    en
enddef

def GitStatus()
    GHead()

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
        Sbo(hB)
        setbufvar(hB, '&colorcolumn', '')

        # TOP ------------------------------------------------------------
        split Git Status
        hT = bufnr()
        setbufvar(hT, '&colorcolumn', '80')
        ownsyntax gitstatus
        :2resize 20
        GSRef(hT, hB, 0)
        Sbo(hT)

        # SYNTAX
        sy match L "modified:.*$" display
        sy match DiffDelete "deleted:.*$" display
        GColor()

        # LABELS
        sy keyword LBL author commit date

        # LOCAL KEY BINDS
        MapClose(hT, hB)
        MapKey(hT, hB, 'F2', 'GCAmd')
        MapKey(hT, hB, 'F4', 'GSIns')
        MapKey(hT, hB, 'F8', 'GSRef')
        MapKey(hT, hB, 'c-i', 'GSIg')
        MapKey(hT, hB, 'DEL', 'GSUns')
        MapKey(hT, hB, 'INS', 'GSAdd')
        MapKey(hT, hB, 'S-HOME', 'GSRes')
        MapKey(hT, hB, 'PageDown', 'GSFet')
        MapKey(hT, hB, 'PageUp', 'GSPsh')

        nnoremap <silent><buffer><END> :cal <SID>GitCommit()<CR>
    en
enddef
nnoremap <F8> :sil cal <SID>GitStatus()<CR>

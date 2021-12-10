# REFRESH TOP WINDOW CONTENTS
#
# h  BUFFER NUMBER TO WRITE TO
# b  SHOULD WE CLEAR FIRST 0|1
def GBRef(h = 0, b = 1)
    # GET THE CURRENT TIME FOR SPEED METRIC
    var now = reltime()

    # CLEAR BUFFER AND EXISTING SYNTAX (b == 1)
    if b
        deletebufline(h, 1, '$')
        sy clear C LOG M S T
    en

    # LONGEST STRINGS IN EACH COLUMN / START WITH MINIMUM LENGTHS
    var L0 = 7
    var L1 = 10
    var L2 = 20
    var L3 = 10
    var L4 = 10

    var rs: list<list<string>>
    for i in S(['git', 'branch', '-a', '--format=%(objectname:short) | %(refname) | %(subject) | %(authordate:short) | %(authorname)'])
        var p = split(i, ' | ')

        # HANDLE BAD REF
        if len(p) != 5
            :continue
        en

        # SHORTEN REF NAME
        var ref = substitute(p[1], 'refs/remotes/', '', '')
        ref = substitute(ref, 'refs/heads/', '', '')

        # FIX SUBJECT LENGTH+FORMAT
        var s = p[2]->strcharpart(0, 85)->tr("\t", " ")

        # SYNTAX: BRANCH KEYWORDS
        var p1 = split(ref, '/')
        for br in p1
            if !IsR(br)
                Ab(br)
            en
        endfo

        # SYNTAX: AUTHOR NAMES
        for at in split(p[4])
            A = T4(A, at)
        endfo

        # UPDATE COLUMN LENGTHS
        L0 = T7(L0, p[0])
        L1 = T7(L1, ref)
        L2 = T7(L2, s)
        L4 = T7(L4, p[4])
        add(rs, [ p[0], ref, s, p[3], p[4]])
    endfo

    var f = printf('%%-%ds  %%-%ds  %%-%ds  %%-%ds  %%s', L0, L1, L2, L3)
    var hl = L0 + L1 + L2 + L3 + L4 + 8
    var sep = repeat('-', hl)
    var l = [ printf(f, 'COMMIT', 'BRANCH', 'SUBJECT', 'DATE', 'AUTHOR'), sep]
    for i in rs
        add(l, printf(f, i[0], i[1], i[2], i[3], i[4]))
    endfo

    # DYNAMIC SYNTAX GROUPS
    #    THESE SYNTAX GROUPS ARE CALCULATED ON THE FLY. PERFORMANCE IS
    #    BETTER SINCE THE DYNAMIC CALCULATION RESULTS IN FEWER REGEX
    #
    #     C  COMMIT
    #     B  BRANCH
    #     S  SUBJECT
    #     D  DATE
    #     A  AUTHOR
    T2('C', 1, L0 + L1 + 3)
    T2('S', L0 + L1 + 4, L2 + 1, 'c', 'contained display contains=L,P oneline')

    #     T  TOP LINES
    #     M  MENU
    #     R  REMOTES
    var rc = len(l)
    T2('T', 3, len(rs), 'l', 'contains=C,S,D,A,R')
    T2('M', rc + 3, 5, 'l', 'contains=@NoSpell,P,MC,MK')
    T2('M', rc + 11, 1, 'l', 'contains=@NoSpell,P,MC,MK')
    T2('R', rc + 9, 1, 'l', 'contains=@NoSpell display oneline')

    # ADD MENU + REMOTES + BRANCH NAME
    extend(l, ['', '',
    '  <S+INS>  CREATE   |  <S+HOME>  CLEAN  |  <S-PGUP>  PUSH      |',
    '  <S+DEL>  DELETE   |  <S+END>   RESET  |  <S-PGDN>  FETCH     |',
    '                    |                   |                      |',
    '  <F1>     MENU     |  <F2>      -----  |  <F3>      CLOSE     |  <F4>  CHECKOUT',
    '  <F5>     REFRESH  |  <F6>      GUI    |  <F7>      LOG/GITK  |  <F8>  STATUS',
    '', 'REMOTE:' .. R,
    '', '<CTRL+P> PRUNE (UNDER CURSOR) <CTRL+T> FETCH TAGS',
    '', 'BRANCH: ' .. Head, sep, ''])

    # ADD LAST FIVE LOG ENTRIES
    var log = S('git log --date=short -n5')
    T2('LOG', len(l) + 1, len(log), 'l', 'contains=A,D,L,P')
    for i in log
        add(l, substitute(i, '^\s\s\s\s$', '', ''))
    endfo
    extend(l, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])

    # FINALLY PRINT EVERYTHING TO THE BUFFER
    Say(h, l)

    # POSITION CURSOR
    win_execute(win_getid(1), printf(':3 | norm %s|', L0 + 3))
enddef

def GBExeExit(hT: number, hB: number, j: job, c = 0)
    G8()
    GBRef(hT, 1)
enddef

def GBExe(hT = 0, hB = 0, cmd = '')
    Say(hB, cmd)
    win_execute(win_getid(2), 'norm G')
    var F = funcref(SayCb, [hB])
    var E = funcref(GBExeExit, [hT, hB])
    job_start(cmd, {out_cb: F, err_cb: F, exit_cb: E})
enddef

def GBCln(hT = 0, hB = 0)
    GBExe(hT, hB, 'git clean -xdf -e *.swp')
enddef

def GBDel(hT = 0, hB = 0)
    GBExe(hT, hB, 'git branch -d ' .. T1())
enddef

def GBFet(hT = 0, hB = 0)
    var o = T9()
    GBExe(hT, hB, IsR(o) ? 'git fetch ' .. o .. ' ' .. Head : 'git fetch')
enddef

def GBNav(hT = 0, hB = 0)
    if col('.') < 10
        GitLog()
    el
        GBExe(hT, hB, 'git checkout ' .. Sr(T1()))
    en
enddef

def GBNew(hT = 0, hB = 0)
    GBExe(hT, hB, 'git branch ' .. T1())
enddef

def GBPsh(hT = 0, hB = 0)
    var o = T9()
    GBExe(hT, hB, IsR(o) ? 'git push ' .. o .. ' ' .. Head : 'git push')
enddef

def GBPru(hT = 0, hB = 0)
    GBExe(hT, hB, 'git remote prune ' .. T9())
enddef

def GBRes(hT = 0, hB = 0)
    GBExe(hT, hB, 'git reset --hard ' .. T1())
enddef

def GBTag(hT = 0, hB = 0)
    GBExe(hT, hB, 'git fetch --tags ' .. T9())
enddef

def GitBranch()
    # NOW
    var n = reltimestr(reltime())
    G8()

    # BOTTOM -------------------------------------------------------------
    exe 'tabnew BranchB' .. n
    settabvar(tabpagenr(), 'title', 'BRANCH')
    var hB = bufnr()
    Say(hB, 'Ready...')
    T3(hB)
    setbufvar(hB, '&colorcolumn', '')

    # TOP ----------------------------------------------------------------
    exe 'split BranchT' .. n
    var hT = bufnr()
    setbufvar(hT, '&colorcolumn', '')
    :ownsyntax gitbranch
    :2resize 20
    GBRef(hT, 0)
    T3(hT)

    # SYNTAX
    G7()

    # LABELS
    sy keyword LBL author branch commit date merge remote subject

    # LOCAL KEY BINDS
    G0(hT, hB)
    G1(hT, hB, 'F4', 'GBNav')
    G1(hT, 1, 'F5', 'GBRef')
    G1(hT, hB, 'c-p', 'GBPru')
    G1(hT, hB, 'c-t', 'GBTag')
    G1(hT, hB, 's-DEL', 'GBDel')
    G1(hT, hB, 's-END', 'GBRes')
    G1(hT, hB, 's-HOME', 'GBCln')
    G1(hT, hB, 's-INS', 'GBNew')
    G1(hT, hB, 's-PageDown', 'GBFet')
    G1(hT, hB, 's-PageUp', 'GBPsh')
enddef
nn <F5> :sil cal <SID>GitBranch()<CR>

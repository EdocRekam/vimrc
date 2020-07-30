# REFRESH TOP WINDOW CONTENTS
#
# h  BUFFER NUMBER TO WRITE TO
# b  SHOULD WE CLEAR FIRST 0|1
def GBRef(h: number, b = 1)
    # GET THE CURRENT TIME FOR SPEED METRIC
    let now = reltime()

    # CLEAR BUFFER AND EXISTING SYNTAX (b == 1)
    if b
        deletebufline(h, 1, '$')
        sy clear A B C D LOG M S T R
    en

    # UNIQUE LIST OF KEYWORDS AND AUTHORS FOR FAST SYNTAX, E.G. LITERALS
    # ARE FASTER THAN REGEX
    let K = ''

    # LONGEST STRINGS IN EACH COLUMN / START WITH MINIMUM LENGTHS
    let L0 = 7
    let L1 = 10
    let L2 = 20
    let L3 = 10
    let L4 = 10

    let rs: list<list<string>>
    for i in systemlist("git branch -a --format='%(objectname:short) | %(refname) | %(subject) | %(authordate:short) | %(authorname)'")
        let p = split(i, ' | ')

        # HANDLE BAD REF
        if len(p) != 5
            :continue
        en

        # SHORTEN REF NAME
        let ref = substitute(p[1], 'refs/remotes/', '', '')
        ref = substitute(ref, 'refs/heads/', '', '')

        # FIX SUBJECT LENGTH+FORMAT
        let s = p[2]->strcharpart(0, 85)->tr("\t", " ")

        # BUILD UNIQUE REMOTE LIST
        let p1 = split(ref, '/')
        if len(p1) > 1
            R = Appendif(R, p1[0])
        en

        # SYNTAX: BRANCH KEYWORDS
        for kw in p1
            K = Appendif(K, kw)
        endfor

        # SYNTAX: AUTHOR NAMES
        for at in split(p[4])
            A = Appendif(A, at)
        endfor

        # UPDATE COLUMN LENGTHS
        L0 = AddIf(L0, p[0])
        L1 = AddIf(L1, ref)
        L2 = AddIf(L2, s)
        L4 = AddIf(L4, p[4])
        add(rs, [ p[0], ref, s, p[3], p[4]])
    endfor

    let f = printf('%%-%ds  %%-%ds  %%-%ds  %%-%ds  %%s', L0, L1, L2, L3)
    let hl = L0 + L1 + L2 + L3 + L4 + 8
    let sep = repeat('-', hl)
    let l = [ printf(f, 'COMMIT', 'BRANCH', 'SUBJECT', 'DATE', 'AUTHOR'), sep]
    for i in rs
        add(l, printf(f, i[0], i[1], i[2], i[3], i[4]))
    endfor

    # DYNAMIC SYNTAX GROUPS
    #    THESE SYNTAX GROUPS ARE CALCULATED ON THE FLY. PERFORMANCE IS
    #    BETTER SINCE THE DYNAMIC CALCULATION RESULTS IN FEWER REGEX
    #
    #     C  COMMIT
    #     B  BRANCH
    #     S  SUBJECT
    #     D  DATE
    #     A  AUTHOR
    Region('C', 1, L0)
    exe 'sy keyword B ' .. K
    Region('S', L0 + L1 + 4, L2 + 1, 'c', 'contained display contains=L,P oneline')
    Region('D', L0 + L1 + L2 + 7, 10)

    #     T  TOP LINES
    #     M  MENU
    #     R  REMOTES
    let rc = len(l)
    Region('T', 3, rc - 2, 'l', 'contains=C,B,S,D,A')
    Region('M', rc + 3, 5, 'l', 'contains=@NoSpell,P,MC,MK')
    Region('M', rc + 11, 1, 'l', 'contains=@NoSpell,P,MC,MK')
    Region('R', rc + 9, 1, 'l', 'contains=@NoSpell display oneline')

    # ADD MENU + REMOTES + BRANCH NAME
    extend(l, ['', '',
    '  <S+INS>  CREATE   |  <S+HOME>  CLEAN  |  <PGUP>    --------  |',
    '  <S+DEL>  DELETE   |  <S+END>   RESET  |  <S-PGDN>  FETCH     |',
    '                    |                   |                      |',
    '  <F1>     MENU     |  <F2>      -----  |  <F3>      CLOSE     |  <F4>  CHECKOUT',
    '  <F5>     REFRESH  |  <F6>      GUI    |  <F7>      LOG/GITK  |  <F8>  STATUS',
    '', 'REMOTE:' .. R,
    '', '<CTRL+P> PRUNE (UNDER CURSOR) <CTRL+T> FETCH TAGS',
    '', 'BRANCH: ' .. Head, sep, ''])

    # ADD LAST FIVE LOG ENTRIES
    let log = systemlist('git log --date=short -n5')
    Region('LOG', len(l) + 1, len(log), 'l', 'contains=A,D,LBL,L,P')
    for i in log
        add(l, substitute(i, '^\s\s\s\s$', '', ''))
    endfor
    extend(l, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])

    # FINALLY PRINT EVERYTHING TO THE BUFFER
    Say(h, l)

    # POSITION CURSOR
    win_execute(win_getid(1), printf(':3 | norm %s|', L0 + 3))
enddef

def GBExeExit(hT: number, hB: number, j: job, code: number)
    GBRef(hT, 1)
enddef

def GBExe(hT: number, hB: number, cmd: string)
    Say(hB, cmd)
    win_execute(win_getid(2), 'norm G')
    let f = funcref("s:SayCallback", [hB])
    let e = funcref("s:GBExeExit", [hT, hB])
    job_start(cmd, #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def GBCln(hT: number, hB: number)
    GBExe(hT, hB, 'git clean -xdf -e *.swp')
enddef

def GBDel(hT: number, hB: number)
    GBExe(hT, hB, 'git branch -d ' .. expand('<cfile>'))
enddef

def GBFet(hT = 0, hB = 0)
    let o = expand('<cword>')
    GBExe(hT, hB, IsR(o) ? 'git fetch ' .. o .. ' ' .. Head : 'git fetch')
enddef

def GBNav(hT: number, hB: number)
    if col('.') < 10
        GitLog()
    else
        GBExe(hT, hB, 'git checkout ' .. expand('<cfile>:t'))
    en
enddef

def GBNew(hT: number, hB: number)
    GBExe(hT, hB, 'git branch ' .. expand('<cfile>'))
enddef

def GBPru(hT: number, hB: number)
    GBExe(hT, hB, 'git remote prune ' .. expand('<cword>'))
enddef

def GBRes(hT: number, hB: number)
    GBExe(hT, hB, 'git reset --hard ' .. expand('<cfile>'))
enddef

def GBTag(hT: number, hB: number)
    GBExe(hT, hB, 'git fetch --tags ' .. expand('<cword>'))
enddef

def GitBranch()
    let now = reltimestr(reltime())
    GHead()

    # BOTTOM -------------------------------------------------------------
    exe 'tabnew BranchB' .. now
    settabvar(tabpagenr(), 'title', 'BRANCH')
    let hB = bufnr()
    Say(hB, 'Ready...')
    Sbo(hB)
    setbufvar(hB, '&colorcolumn', '')

    # TOP ----------------------------------------------------------------
    exe 'split BranchT' .. now
    let hT = bufnr()
    setbufvar(hT, '&colorcolumn', '')
    :ownsyntax gitbranch
    :2resize 20
    GBRef(hT, 0)
    Sbo(hT)

    # SYNTAX
    GColor()

    # LABELS
    sy keyword LBL author branch commit date merge remote subject

    # LOCAL KEY BINDS
    MapClose(hT, hB)
    MapKey(hT, hB, 'F4', 'GBNav')
    MapKey(hT, 1, 'F5', 'GBRef')
    MapKey(hT, hB, 'c-p', 'GBPru')
    MapKey(hT, hB, 'c-t', 'GBTag')
    MapKey(hT, hB, 's-DEL', 'GBDel')
    MapKey(hT, hB, 's-END', 'GBRes')
    MapKey(hT, hB, 's-HOME', 'GBCln')
    MapKey(hT, hB, 's-INS', 'GBNew')
    MapKey(hT, hB, 's-PageDown', 'GBFet')
enddef
nnoremap <F5> :sil cal <SID>GitBranch()<CR>

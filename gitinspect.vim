# GIT INSPECT EXAMINES A SPECIFIC COMMIT TO
#
# LIST WHAT FILES WERE MODIFIED
# DIFF BEFORE/AFTER
def GInsCols(): list<number>
    let l: list<number> = gettabvar(tabpagenr(), 'lens')
    let c: list<number> = [l[0] + 3,
         l[0] + l[1] + 5,
         l[0] + l[1] + l[2] + 7,
         l[0] + l[1] + l[2] + l[3] + 9]

    add(c, c[3] + 5)
    add(c, c[3] + 10)
    add(c, c[3] + 15)
    add(c, c[3] + 20)
    add(c, c[3] + 25)
    add(c, c[3] + 30)

    retu c
enddef

def GInsHitTest(): number
    let cs: list<number> = GInsCols()
    let c = col('.')
    let r = 1
    if c < cs[9] && c >= cs[8]
        r = 10
    elsei c < cs[8] && c >= cs[7]
        r = 9
    elsei c < cs[7] && c >= cs[6]
        r = 8
    elsei c < cs[6] && c >= cs[5]
        r = 7
    elsei c < cs[5] && c >= cs[4]
        r = 6
    elsei c < cs[4] && c >= cs[3]
        r = 5
    elsei c < cs[3] && c >= cs[2]
        r = 4
    elsei c < cs[2] && c >= cs[1]
        r = 3
    elsei c < cs[1] && c >= cs[0]
        r = 2
    en

    retu r
enddef

def GINav(hT: number, hB: number, obj: string)
    let cs: list<number> = GInsCols()

    let lin = getline('.')
    let pat = trim(strcharpart(lin, 0, cs[0] - 1))
    let bef = trim(strcharpart(lin, cs[0] - 1, cs[1] - cs[0] - 1))
    let aft = trim(strcharpart(lin, cs[1] - 1, cs[2] - cs[1] - 1))
    let hed = trim(strcharpart(lin, cs[2] - 1, cs[3] - cs[2] - 1))

    let c = GInsHitTest()

    # FILE
    if c == 1 && filereadable(pat)
        exe 'tabnew ' .. pat

    # BEFORE
    elsei c == 2
        GitShow(bef, pat)

    # AFTER
    elsei c == 3
        GitShow(aft, pat)

    # HEAD
    elsei c == 4
        GitShow(hed, pat)

    # BEFORE:AFTER
    elsei c == 5 && bef != 'DELETED' && aft != 'DELETED'
        GitShow2(bef, pat, aft, pat)
        :windo diffthis

    # BEFORE:HEAD
    elsei c == 6 && bef != 'DELETED' && hed != 'DELETED'
        GitShow2(bef, pat, hed, pat)
        :windo diffthis

    # AFTER:HEAD
    elsei c == 7 && aft != 'DELETED' && hed != 'DELETED'
        GitShow2(aft, pat, hed, pat)
        :windo diffthis

    # BEFORE-AFTER
    elsei c == 8 && bef != 'DELETED' && aft != 'DELETED'
        GitShow2(bef, pat, aft, pat)

    # BEFORE-HEAD
    elsei c == 9 && bef != 'DELETED' && hed != 'DELETED'
        GitShow2(bef, pat, hed, pat)

    # AFTER-HEAD
    elsei c == 10 && aft != 'DELETED' && hed != 'DELETED'
        GitShow2(aft, pat, hed, pat)

    en
enddef

# REFRESH TOP WINDOW CONTENTS
#
# hT   TOP WINDOW BUFFER
# hB   BOTTOM WINDOW BUFFER
# obj  THE COMMIT TO INSPECT
# b    CLEAR THE SCREEN BEFORE PRINTING
def GIRef(hT: number, hB: number, obj: string, bl = 1)

    # GET THE CURRENT TIME FOR SPEED METRIC
    let now = reltime()

    # CLEAR BUFFER AND EXISTING SYNTAX (b == 1)
    if bl
        deletebufline(hT, 1, '$')
        sy clear A F BAH M T R
    en

    # LONGEST STRINGS IN EACH COLUMN / START WITH MINIMUM LENGTHS
    let L0 = 24 | let L1 = 6 | let L2 = 6 | let L3 = 6 | let L4 = 13
    let L5 = 13

    let rs: list<list<string>>
    for i in S('git diff --numstat ' .. obj .. '~1 ' .. obj)

        # SAMPLE OUTPUT
        # ADD(A)  DEL(B)  PATH(C)
        # 16      111     git.vim
        # 46      54      gitbranch.vim
        # 20      30      gitcommit.vim
        # 83      0       gitinspect.vim
        # 120     0       gitlog.vim
        # 26      36      gitstatus.vim
        # 3       1       install
        # 1       1       menu.vim
        # 5       0       session.vim
        let bc = split(i)

        # NUM LINES DELETED FROM FILE
        let b = str2nr(bc[1])

        # FILE PATH
        let c = bc[2]

        # COMMIT OF PATH AFTER MODIFICATION
        let aft = ''

        # COMMIT OF PATH BEFORE MODIFICATION
        let bef = ''

        # LOOK AT THE OBJECT - FILE LAST THREE CHANGES
        #   ONE PAST ENTRY MEANS FILE WAS ADDED IN THIS `obj` COMMIT
        #   TWO PAST ENTRY MEANS ?
        #   THREE PAST ENTRY MEANS ?
        let past = S("git log -n3 --pretty='%h | %an' " .. obj .. ' -- ' .. c)
        if len(past) == 1
            bef = 'ADDED'
            aft = obj
        else
            bef = get(split(past[1], ' | '), 0)
            if b > 1
                aft = obj
            else
                system('git show ' .. obj .. ':' .. c)
                aft = v:shell_error ? 'DELETED' : obj
            en
        en

        # DIG OUT AUTHORS FROM PAST (IF POSSIBLE)
        for at in split(get(split(get(past, 1), ' | '), 1))
            A = T4(A, at)
        endfo

        # IF FILE EXISTS MEANS THAT ITS STILL IN LATEST HEAD
        let hed = filereadable(c) ? Head : 'DELETED'

        # UPDATE COLUMN LENGTHS
        L0 = T7(L0, c)
        L1 = T7(L1, bef)
        L2 = T7(L2, aft)
        L3 = T7(L3, hed)
        settabvar(tabpagenr(), 'lens', [L0, L1, L2, L3, L4, L5])

        add(rs, [c, bef, aft, hed])
    endfo

    let f = printf('%%-%ds  %%-%ds  %%-%ds  %%-%ds  %%-%ds  %%s', L0, L1, L2, L3, L4)
    let hl = L0 + L1 + L2 + L3 + 36
    let sep = repeat('-', hl)

    let l = [ printf(f, 'FILE', 'BEFORE', 'AFTER', 'HEAD', 'COMPARE', 'SIDE BY SIDE'), sep]
    for i in rs
        add(l, printf(f, i[0], i[1], i[2], i[3], 'B:A  B:H  A:H', 'B-A  B-H  A-H'))
    endfo

    # DYNAMIC SYNTAX GROUPS
    #    THESE SYNTAX GROUPS ARE CALCULATED ON THE FLY. PERFORMANCE IS
    #    BETTER SINCE THE DYNAMIC CALCULATION RESULTS IN FEWER REGEX
    #
    #     F    FILE
    #     BAH  BEFORE + AFTER + HEAD + PADDING
    #     AUTHORS FOUND IN LOGS
    T2('F', 1, L0)
    T2('BAH', L0 + 3, L1 + L2 + L3 + L4 + L5 + 8)

    #     T  TOP LINES
    #     M  MENU
    #     R  REMOTES
    let rc = len(l)
    T2('T', 3, rc - 2, 'l', 'contains=F,BAH')
    T2('M', rc + 3, 2, 'l', 'contains=@NoSpell,P,MC,MK')

    extend(l, [sep, '',
    '<F1> MENU      | <F2> -------  | <F3> CLOSE    | <F4> INSPECT',
    '<F5> BRANCH    | <F6> GUI      | <F7> LOG/GITK | <F8> STATUS',
    ''])

    # LOG ENTRY
    extend(l, S('git log -n1 ' .. obj))

    # PERFORMANCE
    extend(l, ['', 'Time:' .. reltimestr(reltime(now, reltime()))])

    # FINALLY PRINT IT
    Say(hT, l)

    # POSITION
    win_execute(win_getid(1), ':3')
enddef

def GitInspect(obj: string)
    # FIND HEAD
    G8()

    # BOTTOM -------------------------------------------------------------
    let tT = 'I:' .. obj
    let tB = tT .. ' - Messages'
    exe 'tabnew ' .. tB
    settabvar(tabpagenr(), 'title', tT)
    let hB = bufnr()
    Say(hB, 'Ready...')
    T3(hB)
    setbufvar(hB, '&colorcolumn', '')

    # TOP ----------------------------------------------------------------
    exe 'split ' .. tT
    let hT = bufnr()
    setbufvar(hT, '&colorcolumn', '')
    :ownsyntax gitinspect
    :2resize 20
    GIRef(hT, hB, obj, 0)
    T3(hT)

    # SYNTAX
    G7()

    # LABELS
    sy keyword LBL after author before by commit compare date file head side

    # COLOR
    hi link BAH Keyword

    # LOCAL KEY BINDS
    G0(hT, hB)
    let cmd = 'nn <silent><buffer><'
    exe printf("%s2-LeftMouse> :cal <SID>GINav(%d, %d, '%s')<CR>", cmd, hT, hB, obj)
    exe printf("%sF4> :cal <SID>GINav(%d, %d, '%s')<CR>", cmd, hT, hB, obj)
    exe printf("%sF6> :cal <SID>GIRef(%d, %d, '%s')<CR>", cmd, hT, hB, obj)
enddef

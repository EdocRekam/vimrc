# REFRESH TOP WINDOW CONTENTS
#
# h  BUFFER NUMBER TO WRITE TO
# b  SHOULD WE CLEAR FIRST 0|1
def GLRef(h = 0, hB = 0, obj = '', b = 1)
    # GET THE CURRENT TIME FOR SPEED METRIC
    var n = reltime()

    # CLEAR BUFFER AND EXISTING SYNTAX (b == 1)
    if b
        deletebufline(h, 1, '$')
        sy clear TC S D A K T M
    endif

    # UNIQUE LIST OF KEYWORDS AND AUTHORS FOR FAST SYNTAX, E.G. LITERALS
    # ARE FASTER THAN REGEX
    var K = obj

    # LONGEST STRINGS IN EACH COLUMN / START WITH MINIMUM LENGTHS
    var L0 = 7
    var L1 = 7
    var L2 = 50
    var L3 = 10
    var L4 = 7

    var rs: list<list<string>>
    var log = S(['git', 'log', '-n50', '--pretty=%t | %h | %s | %as | %an', obj])
    var nlog = len(log)
    for i in log
        var r = split(i, ' | ')

        # FIX SUBJECT LENGTH+FORMAT
        var s = r[2]->strcharpart(0, 85)->tr("\t", " ")

        # UPDATE COLUMN LENGTHS
        L0 = T7(L0, r[0])
        L1 = T7(L1, r[1])
        L2 = T7(L2, s)
        L4 = T7(L4, r[4])
        settabvar(tabpagenr(), 'L', [L0, L1, L2, L3, L4])

        # SYNTAX: AUTHOR NAMES
        for at in split(r[4])
            A = T4(A, at)
        endfor

        add(rs, [ r[0], r[1], s, r[3], r[4]])
    endfor

    var f = printf('%%-%ds  %%-%ds  %%-%ds  %%-%ds  %%s', L0, L1, L2, L3)
    var sep = repeat('-', L0 + L1 + L2 + L3 + L4 + 8)

    # l REPRESENTS ALL THE LINES SENT TO THE BUFFER
    var l = [ printf(f, 'TREE', 'COMMIT', obj, 'DATE', 'AUTHOR'), sep]
    for i in rs
        add(l, printf(f, i[0], i[1], i[2], i[3], i[4]))
    endfor

    # BRANCHES
    extend(l, ['', printf(f, 'TREE', 'COMMIT', 'TAG', 'DATE', 'AUTHOR'), sep])

    var br = S('git rev-parse --short --tags HEAD')
    var nbr = len(br)
    for i in br
        var line = get(S(['git', 'log', '-n1', '--pretty=%t | %h | %D | %as | %an', i]), 0)
        var r = split(line, ' | ')

        add(l, printf(f, r[0], r[1], r[2], r[3], r[4]))
    endfor

    extend(l, ['', '',
    '<F1>  MENU    |  <F2> -----  |  <F3>  CLOSE         |  <F4>  INSPECT',
    '<F5>  BRANCH  |  <F6> GUI    |  <F7>  REFRESH/GITK  |  <F8>  STATUS',
    '', '', 'Time:' .. reltimestr(reltime(n, reltime()))])
    Say(h, l)

    # DYNAMIC SYNTAX GROUPS
    #    THESE SYNTAX GROUPS ARE CALCULATED ON THE FLY. PERFORMANCE IS
    #    BETTER SINCE THE DYNAMIC CALCULATION RESULTS IN FEWER REGEX
    #
    #     TC TREE + COMMIT
    #     S  SUBJECT
    #     D  DATE
    #     A  AUTHOR
    #     K  KEYWORDS
    T2('TC', 1, L0 + L1 + 2, 'c', 'contains=@NoSpell contained display oneline')
    T2('S', L0 + L1 + 5, L2 + 1, 'c', 'contains=K,P contained display oneline')
    T2('D', L0 + L1 + L2 + 7, 10)
    exe 'sy keyword K ' .. K

    T2('M', nlog + nbr + 8, 2, 'l', 'contains=@NoSpell,P,MC,MK')
    T2('T', 3, nlog, 'l', 'contains=TC,S,D,A')
    T2('T', nlog + 6, nbr, 'l', 'contains=TC,S,D,A')

    # POSITION
    win_execute(win_getid(1), printf(':3 | norm %s|', L1 + 3))
enddef

def GLog(obj = '')
    var n = reltimestr(reltime())

    # BOTTOM -------------------------------------------------------------
    exe 'tabnew Log - ' .. n
    settabvar(tabpagenr(), 'title', obj)
    var hB = bufnr()
    Say(hB, 'Ready...')
    T3(hB)
    setbufvar(hB, '&colorcolumn', '')

    # TOP ----------------------------------------------------------------
    exe 'split ' .. obj .. ':' .. n
    var hT = bufnr()
    setbufvar(hT, '&colorcolumn', '')
    :2resize 20
    GLRef(hT, hB, obj, 0)
    T3(hT)

    # BASIC SYNTAX/COLOR
    G7()

    # LABELS
    sy keyword Identifier author commit date tag tree

    # LOCAL KEY BINDS
    G0(hT, hB)
    T14('F4', 'GLNav', hT, hB, obj)
    T14('F7', 'GLRef', hT, hB, obj)
    T14('2-LeftMouse', 'GLNav', hT, hB, obj)
enddef

def GitLog()
    G8()
    var o = T1()
    GLog(strchars(o) > 5 ? o : 'HEAD')
enddef
nn <F7> :sil cal <SID>GitLog()<CR>

def GLNav(hT = 0, hB = 0, o = '')
    var L = gettabvar(tabpagenr(), 'L')
    if col('.') > L[0] + L[1] + 4
        GLog(get(split(getline('.')), 1))
    else
        GitInspect(T9())
    endif
enddef

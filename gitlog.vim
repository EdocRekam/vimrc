
" REFRESH TOP WINDOW CONTENTS
"
" h  BUFFER NUMBER TO WRITE TO
" b  SHOULD WE CLEAR FIRST 0|1
def! GLRef(h: number, obj: string, b = 1)
    # GET THE CURRENT TIME FOR SPEED METRIC
    let now = reltime()

    # CLEAR BUFFER AND EXISTING SYNTAX (b == 1)
    if b
        deletebufline(h, 1, '$')
        sy clear TC S D A K T M
    endif

    # UNIQUE LIST OF KEYWORDS AND AUTHORS FOR FAST SYNTAX, E.G. LITERALS
    # ARE FASTER THAN REGEX
    let A = ''
    let K = obj

    # LONGEST STRINGS IN EACH COLUMN / START WITH MINIMUM LENGTHS
    let L0 = 7
    let L1 = 7
    let L2 = 50
    let L3 = 10
    let L4 = 7

    let rs: list<list<string>>
    let log = systemlist("git log -n50 --pretty='%t | %h | %s | %as | %an' " .. obj)
    let nlog = len(log)
    for i in log
        let r = split(i, ' | ')

        # FIX SUBJECT LENGTH+FORMAT
        let s = r[2]->strcharpart(0, 85)->tr("\t", " ")

        # UPDATE COLUMN LENGTHS
        L0 = AddIf(L0, r[0])
        L1 = AddIf(L1, r[1])
        L2 = AddIf(L2, s)
        L4 = AddIf(L4, r[4])
        settabvar(tabpagenr(), 'L', [L0, L1, L2, L3, L4])

        add(rs, [ r[0], r[1], s, r[3], r[4]])
    endfor

    let f = printf('%%-%ds  %%-%ds  %%-%ds  %%-%ds  %%s', L0, L1, L2, L3)
    let hdr = printf(f, 'TREE', 'COMMIT', obj, 'DATE', 'AUTHOR')
    let sep = repeat('-', L0 + L1 + L2 + L3 + L4 + 8)

    let l = [hdr, sep]
    for i in rs
        add(l, printf(f, i[0], i[1], i[2], i[3], i[4]))
    endfor

    # BRANCHES
    extend(l, ['', printf(f, 'TREE', 'COMMIT', 'TAG', 'DATE', 'AUTHOR'), sep])

    let br = systemlist('git rev-parse --short --tags HEAD')
    let nbr = len(br)
    for i in br
        let line = trim(system("git log -n1 --pretty='%t | %h | %D | %as | %an' " .. i))
        let r = split(line, ' | ')

        # SYNTAX: AUTHOR NAMES
        for at in split(r[4])
            A = Appendif(A, at)
        endfor

        add(l, printf(f, r[0], r[1], r[2], r[3], r[4]))
    endfor

    extend(l, ['', '',
    '<F1>  MENU    |  <F2> -----  |  <F3>  CLOSE         |  <F4>  INSPECT',
    '<F5>  BRANCH  |  <F6> GUI    |  <F7>  REFRESH/GITK  |  <F8>  STATUS',
    '', '', 'Time:' .. reltimestr(reltime(now, reltime()))])
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
    Region('TC', 1, L0 + L1 + 2, 'c', 'contains=@NoSpell contained display oneline')
    Region('S', L0 + L1 + 5, L2 + 1, 'c', 'contains=K,P contained display oneline')
    Region('D', L0 + L1 + L2 + 7, 10)
    exe 'sy keyword A ' .. A .. ' | sy keyword K ' .. K

    Region('M', nlog + nbr + 8, 2, 'l', 'contains=@NoSpell,P,MC,MK')
    Region('T', 3, nlog, 'l', 'contains=TC,S,D,A')
    Region('T', nlog + 6, nbr, 'l', 'contains=TC,S,D,A')

    # POSITION
    let winid = win_getid(1)
    win_execute(winid, printf('norm %s|', L1 + 3))
    win_execute(winid, '3')
enddef

def! GLog(obj: string)
    let now = reltimestr(reltime())

    # BOTTOM -------------------------------------------------------------
    exe 'tabnew Log - ' .. now
    settabvar(tabpagenr(), 'title', obj)
    let hB = bufnr()
    Say(hB, 'Ready...')
    Hide(hB)
    setbufvar(hB, '&colorcolumn', '')

    # TOP ----------------------------------------------------------------
    exe 'split ' .. obj .. ':' .. now
    let hT = bufnr()
    setbufvar(hT, '&colorcolumn', '')
    :2resize 20
    GLRef(hT, obj, 0)
    Hide(hT)

    # BASIC SYNTAX/COLOR
    GColor()

    # LABELS
    sy keyword Identifier author commit date tag tree

    # LOCAL KEY BINDS
    let m = 'nnoremap <silent><buffer><'
    exe printf("%sF3> :exe 'sil bw! %d %d'<CR> ", m, hT, hB)
    exe printf('%sF4> :cal <SID>GLNav()<CR>', m)
    exe printf("%sF7> :cal <SID>GLRef(%d, '%s')<CR>", m, hT, obj)
    exe printf("%s2-LeftMouse> :cal <SID>GLNav()<CR>", m)
enddef

def! GitLog()
    GHead()
    let o = expand('<cfile>')
    GLog(strchars(o) > 5 ? o : 'HEAD')
enddef
nnoremap <silent><F7> :cal <SID>GitLog()<CR>

def! GLNav()
    let L = gettabvar(tabpagenr(), 'L')
    if col('.') > L[0] + L[1] + 4
        GLog(get(split(getline('.')), 1))
    else
        GitInspect(expand('<cword>'))
    endif
enddef

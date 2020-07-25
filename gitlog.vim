
" REFRESH TOP WINDOW CONTENTS
"
" h  BUFFER NUMBER TO WRITE TO
" b  SHOULD WE CLEAR FIRST 0|1
def! GLRefresh(h: number, commit: string, b = 1)
    # GET THE CURRENT TIME FOR SPEED METRIC
    let now = reltime()

    # CLEAR BUFFER AND EXISTING SYNTAX (b == 1)
    if b
        deletebufline(h, 1, '$')
        sy clear TC S D A K T M
    endif

    # UNIQUE LIST OF KEYWORDS AND AUTHORS FOR FAST SYNTAX, E.G. LITERALS
    # ARE FASTER THAN REGEX
    let ats = ''
    let kws = commit

    # LONGEST STRINGS IN EACH COLUMN / START WITH MINIMUM LENGTHS
    let L0 = 7 | let L1 = 7 | let L2 = 50 | let L3 = 10 | let L4 = 7

    let rs: list<list<string>>
    let log = systemlist("git log -n50 --pretty='%t | %h | %s | %as | %an' " .. commit)
    let numLog = len(log)
    for i in log
        let r = split(i, ' | ')

        # FIX SUBJECT LENGTH+FORMAT
        let subj = r[2]->strchars() < 85 ? r[2] : r[2]->strcharpart(0, 85)->tr("\t", " ")

        # UPDATE COLUMN LENGTHS
        L0 = AddIf(L0, r[0])
        L1 = AddIf(L1, r[1])
        L2 = AddIf(L2, subj)
        L4 = AddIf(L4, r[4])
        settabvar(tabpagenr(), 'L', [L0, L1, L2, L3, L4])

        add(rs, [ r[0], r[1], subj, r[3], r[4]])
    endfor

    let f = printf('%%-%ds  %%-%ds  %%-%ds  %%-%ds  %%s', L0, L1, L2, L3)
    let hdr = printf(f, 'TREE', 'COMMIT', commit, 'DATE', 'AUTHOR')
    let hl = L0 + L1 + L2 + L3 + L4 + 8
    let sep = repeat('-', hl)

    let l = [hdr, sep]
    for i in rs
        add(l, printf(f, i[0], i[1], i[2], i[3], i[4]))
    endfor

    # BRANCHES
    extend(l, ['', printf(f, 'TREE', 'COMMIT', 'TAG', 'DATE', 'AUTHOR'), sep])

    let branches = systemlist('git rev-parse --short --tags HEAD')
    let numBranches = len(branches)
    for i in branches
        let line = trim(system("git log -n1 --pretty='%t | %h | %D | %as | %an' " .. i))
        let r = split(line, ' | ')

        # SYNTAX: AUTHOR NAMES
        for at in split(r[4])
            ats = Appendif(ats, at)
        endfor

        add(l, printf(f, r[0], r[1], r[2], r[3], r[4]))
    endfor

    extend(l, ['', '',
    '  <S+INS>  ------------  |  <S+HOME>  -----------  |  <PGDN>  -------------  |',
    '  <S+DEL>  ------------  |  <S+END>   -----------  |  <PGUP>  -------------  |',
    '                         |                         |                         |',
    '  <F1>     MENU          |  <F2>      -----------  |  <F3>    CLOSE          |  <F4>  INSPECT',
    '  <F5>     BRANCH        |  <F6>      GUI          |  <F7>    REFRESH/GITK   |  <F8>  STATUS',
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
    exe 'sy keyword A ' .. ats
    exe 'sy keyword K ' .. kws

    Region('M', numLog + numBranches + 8, 5, 'l', 'contains=@NoSpell,P,MC,MK')
    Region('T', 3, numLog, 'l', 'contains=TC,S,D,A')
    Region('T', numLog + 6, numBranches, 'l', 'contains=TC,S,D,A')

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
    exe 'split ' .. obj .. ' - ' .. now
    let hT = bufnr()
    setbufvar(hT, '&colorcolumn', '')
    :2resize 20
    GLRefresh(hT, obj, 0)
    Hide(hT)

    # BASIC SYNTAX/COLOR
    GColor()

    # LABELS
    sy keyword Identifier author commit date tag tree

    # LOCAL KEY BINDS
    let cmd = 'nnoremap <silent><buffer>'
    exe printf("%s<F3> :exe 'sil bw! %d %d'<CR> ", cmd, hT, hB)
    exe printf('%s<F4> :cal <SID>GLNav()<CR>', cmd)
    exe printf("%s<F7> :cal <SID>GLRefresh(%d, '%s')<CR>", cmd, hT, obj)
    exe printf("%s<2-LeftMouse> :cal <SID>GLNav()<CR>", cmd)
enddef

def! GitLog()
    GHead()
    let hint = expand('<cfile>')
    GLog(strchars(hint) > 5 ? hint : 'HEAD')
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

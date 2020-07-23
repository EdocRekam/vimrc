" REFRESH TOP WINDOW CONTENTS
" 
" h - Buffer number to write to
" b - Should we clear first 0|1
def! GBRef(h: number, b = 1)

    # CREATE A SYNTAX REGION STARTING/ENDING ON A COLUMN OR LINE
    def Region(group: string, x: number, y: number, t = 'c', extra = 'contained display oneline')
        let f = 'sy region %s start="%s" end="%s" %s'
        let z = x + y
        exe printf(f, group, '\%' .. x .. t, '\%' .. z .. t, extra)
    enddef

    # RETURN X OR THE LENGTH OF VAL; WHICHEVER IS GREATER
    def AddIf(x: number, val: string): number
        let y = strchars(val)
        return y > x ? y : x
    enddef

    # APPEND Y TO X IF IT DOES NOT EXIST; OTHERWISE X
    def Appendif(x: string, y: string): string
        return stridx(x, y) >= 0 ? x : printf('%s %s', x, y)
    enddef

    # GET THE CURRENT TIME FOR SPEED METRIC
    let now = reltime()

    # CLEAR BUFFER AND EXISTING SYNTAX (b == 1)
    if b
        deletebufline(h, 1, '$')
        sy clear M T C B S D A R
    endif

    # UNIQUE LIST OF KEYWORDS AND AUTHORS FOR FAST SYNTAX, E.G. LITERALS
    # ARE FASTER THAN REGEX
    let kws = ''
    let ats = ''
    let remotes = ''

    # LONGEST STRINGS IN EACH COLUMN / START WITH MINIMUM LENGTHS
    let l0 = 7 | let l1 = 10 | let l2 = 20 | let l3 = 10 | let l4 = 10

    let rs: list<list<string>>
    for i in systemlist("git branch -a --format='%(objectname:short) | %(refname) | %(subject) | %(authordate:short) | %(authorname)'")
        let p = split(i, ' | ')

        # HANDLE BAD REF
        if len(p) != 5
            :continue
        endif

        # SHORTEN REF NAME
        let ref = substitute(p[1], 'refs/remotes/', '', '')
        ref = substitute(ref, 'refs/heads/', '', '')

        # FIX SUBJECT LENGTH+FORMAT
        let subj = p[2]->strchars() < 85 ? p[2] : p[2]->strcharpart(0, 85)->tr("\t", " ")

        # BUILD UNIQUE REMOTE LIST
        let p1 = split(ref, '/')
        if len(p1) > 1
            remotes = Appendif(remotes, p1[0])
        endif

        # SYNTAX: BRANCH KEYWORDS
        for kw in p1
            kws = Appendif(kws, kw)
        endfor

        # SYNTAX: AUTHOR NAMES
        for at in split(p[4])
            ats = Appendif(ats, at)
        endfor

        # UPDATE COLUMN LENGTHS
        l0 = AddIf(l0, p[0])
        l1 = AddIf(l1, ref)
        l2 = AddIf(l2, subj)
        l4 = AddIf(l4, p[4])
        add(rs, [ p[0], ref, subj, p[3], p[4]])
    endfor

    let f = printf('%%-%ds  %%-%ds  %%-%ds  %%-%ds  %%s', l0, l1, l2, l3)
    let hdr = printf(f, 'COMMIT', 'BRANCH', 'SUBJECT', 'DATE', 'AUTHOR')
    let hl = l0 + l1 + l2 + l3 + l4 + 8
    let sep = repeat('-', hl)
    let l = [hdr, sep]
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
    Region('C', 1, l0)
    exe 'sy keyword B ' .. kws
    Region('S', l0 + l1 + 4, l2 + 1, 'c', 'contained display contains=L,P oneline')
    Region('D', l0 + l1 + l2 + 7, 10)
    exe 'sy keyword A ' .. ats

    #     T  TOP LINES
    #     M  MENU
    #     R  REMOTES
    let rc = len(l)
    Region('T', 3, rc - 2, 'l', 'contains=C,B,S,D,A')
    Region('M', rc + 3, 5, 'l', 'contains=@NoSpell,P,MC,MK')
    Region('M', rc + 11, 1, 'l', 'contains=@NoSpell,P,MC,MK')
    Region('R', rc + 9, 1, 'l', 'contains=@NoSpell display oneline')

    # ADD MENU + REMOTES + BRANCH NAME
    extend(l, ['','',
    '  <S+INS>  CREATE        |  <S+HOME>  CLEAN        |  <PGDN>  -------------  |',
    '  <S+DEL>  DELETE        |  <S+END>   RESET        |  <PGUP>  -------------  |',
    '                         |                         |                         |',
    '  <F1>     MENU          |  <F2>      -----------  |  <F3>    CLOSE          |  <F4>  CHECKOUT',
    '  <F5>     REFRESH       |  <F6>      GUI          |  <F7>    LOG/GITK       |  <F8>  STATUS',
    '', 'REMOTE:' .. remotes,
    '', '<CTRL+P> PRUNE (UNDER CURSOR) <CTRL+T> FETCH TAGS',
    '', 'BRANCH: ' .. g:head, sep, ''])

    # ADD LAST FIVE LOG ENTRIES
    for i in systemlist('git log -n5')
        add(l, substitute(i, '^\s\s\s\s$', '', ''))
    endfor
    extend(l, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])

    # FINALLY PRINT EVERYTHING TO THE BUFFER
    Say(h, l)

    # POSITION CURSOR
    let winid = win_getid(1)
    win_execute(winid, printf('norm %s|', l0 + 3))
    win_execute(winid, '3')
enddef

def! GBExeExit(hT: number, hB: number, chan: number, code: number)
    GBRef(hT, 1)
enddef

def! GBExe(hT: number, hB: number, cmd: string)
    Say(hB, cmd)
    win_execute(win_getid(2), 'norm G')
    let f = funcref("s:SayCallback", [hB])
    let e = funcref("s:GBExeExit", [hT, hB])
    job_start(cmd, #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def! GBCln(hT: number, hB: number)
    GBExe(hT, hB, 'git clean -xdf -e *.swp')
enddef

def! GBDel(hT: number, hB: number)
    GBExe(hT, hB, 'git branch -d ' .. expand('<cfile>'))
enddef

def! GBNav(hT: number, hB: number)
    if col('.') < 10
        GitLog()
    else
        GBExe(hT, hB, 'git checkout ' .. expand('<cfile>:t'))
    endif
enddef

def! GBNew(hT: number, hB: number)
    GBExe(hT, hB, 'git branch ' .. expand('<cfile>'))
enddef

def! GBPru(hT: number, hB: number)
    GBExe(hT, hB, 'git remote prune ' .. expand('<cword>'))
enddef

def! GBRes(hT: number, hB: number)
    GBExe(hT, hB, 'git reset --hard ' .. expand('<cfile>'))
enddef

def! GBTag(hT: number, hB: number)
    GBExe(hT, hB, 'git fetch --tags ' .. expand('<cword>'))
enddef

def! GitBranch()
    let now = reltimestr(reltime())
    GHead()

    # BOTTOM -------------------------------------------------------------
    exe 'tabnew BranchB' .. now
    settabvar(tabpagenr(), 'title', 'BRANCH')
    let hB = bufnr()
    Say(hB, 'Ready...')
    Hide(hB)
    setbufvar(hB, '&colorcolumn', '')

    # TOP ----------------------------------------------------------------
    exe 'split BranchT' .. now
    let hT = bufnr()
    setbufvar(hT, '&colorcolumn', '')
    :ownsyntax gitbranch
    :2resize 20
    GBRef(hT, 0)
    Hide(hT)

    # COLOR
    sy case ignore

    # LABELS
    sy keyword LBL author branch commit date remote subject

    # PAIRS
    sy region P start="<" end=">" contains=@NoSpell display oneline
    sy region P start="`" end="`" contains=@NoSpell display oneline

    # MENU COMMANDS
    sy keyword MC add checkout clean close create cursor delete fetch gitk gui log menu prune refresh reset status tags under contained

    # COMMENTS
    sy match Comment "^\s\s\s\s.*$" contains=L,P

    # LINKS - SHA OR []
    sy match L "[0-9a-f]\{40}" contains=@NoSpell display
    sy region L start="\[" end="\]" contains=@NoSpell display oneline

    hi MC guifg=#27d185
    hi link LBL Identifier
    hi link MK String
    hi link T Function | hi link A Function
    hi link B Keyword | hi link C Keyword | hi link L Keyword | hi link R Keyword
    hi link S Comment
    hi link D String | hi link P String

    # LOCAL KEY BINDS
    let m = 'nnoremap <silent><buffer>'
    exe printf("%s<s-DEL> :cal <SID>GBDel(%d, %d)<CR>", m, hT, hB)
    exe printf("%s<s-END> :cal <SID>GBRes(%d, %d)<CR>", m, hT, hB)
    exe printf("%s<F3> :exe 'sil bw! %d %d'<CR>", m, hT, hB)
    exe printf("%s<F4> :cal <SID>GBNav(%d, %d)<CR>", m, hT, hB)
    exe printf("%s<F5> :cal <SID>GBRef(%d, 1)<CR>", m, hT)
    exe printf("%s<s-HOME> :cal <SID>GBCln(%d, %d)<CR>", m, hT, hB)
    exe printf("%s<s-INS> :cal <SID>GBNew(%d, %d)<CR>", m, hT, hB)
    exe printf("%s<c-p> :cal <SID>GBPru(%d, %d)<CR>", m, hT, hB)
    exe printf("%s<c-t> :cal <SID>GBTag(%d, %d)<CR>", m, hT, hB)
enddef
nnoremap <silent><F5> :cal <SID>GitBranch()<CR>


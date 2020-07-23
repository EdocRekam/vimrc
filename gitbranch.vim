def! GRemotes(): string
    let l: string
    for r in systemlist('git remote')
        l = printf('%s  %s', l, r)
    endfor
    retu 'REMOTE:' .. l
enddef

def! Appendif(x: string, y: string): string
    return stridx(x, y) >= 0 ? x : printf('%s %s', x, y)
enddef

" REFRESH TOP WINDOW CONTENTS
" 
" h - Buffer number to write to
" b - Should we clear first 0|1
def! GBRef(h: number, b: number)
    def Region(group: string, x: number, y: number, t = 'c', extra = 'contained display oneline')
        let f = 'sy region %s start="%s" end="%s" %s'
        let z = x + y
        exe printf(f, group, '\%' .. x .. t, '\%' .. z .. t, extra)
    enddef

    let now = reltime()
    if b
        deletebufline(h, 1, '$')
        sy clear M T C B S D A R
    endif

    # KEYWORD LIST
    let kw = ''
    let authors = ''

    let lens = [
        Widest(rs, 0, 7),
        Widest(rs, 1, 10),
        Widest(rs, 2, 7),
        11,
        Widest(rs, 4, 7)]

    let f = '%-' .. lens[0] .. 's  %-' .. lens[1] .. 's  %-' .. lens[2] .. 's  %-' .. lens[3] .. 's  %s'
    let hdr = printf(f, 'COMMIT', 'BRANCH', 'SUBJECT', 'DATE', 'AUTHOR')
    let hl = lens[0] + lens[1] + lens[2] + lens[3] + lens[4] + 8
    let sep = repeat('-', hl)

    let l = [hdr, sep]
    for i in systemlist("git branch -a --format='%(objectname:short) | %(refname) | %(subject) | %(authordate:short) | %(authorname)'")
        let p = split(i, ' | ')
        if len(p) != 5
            :continue
        endif
        let ref = substitute(p[1], 'refs/remotes/', '', '')
        ref = substitute(ref, 'refs/heads/', '', '')

        # BRANCHES
        for z in split(ref, '/')
            kw = Appendif(kw, z)
        endfor

        # AUTHORS
        for a in split(p[4])
            authors = Appendif(authors, a)
        endfor

        add(l, printf(f, p[0], ref, p[2]->strchars() < 85 ? p[2] : p[2]->strcharpart(0, 85)->tr("\t", " "), p[3], p[4])
    endfor

    # SYNTAX
    #     B - BRANCH COLUMN
    #     C - COMMIT COLUMN
    #     S - SUBJECT COLUMN
    #     D - DATE COLUMN
    let rowCount = len(l)

    # COMMIT
    Region('C', 1, lens[0])

    # BRANCH
    exe 'sy keyword B ' .. kw

    # SUBJECT
    let x = lens[0] + lens[1] + 4
    let y = lens[2] + 2
    Region('S', x, y, 'c', 'contained display contains=L,P oneline')

    # DATE
    x = lens[0] + lens[1] + lens[2] + 7
    Region('D', x, 10)

    # AUTHOR
    exe 'sy keyword A ' .. authors

    # TOP SECTION
    Region('T', 3, rowCount - 2, 'l', 'contains=C,B,S,D,A')

    # MENU
    Region('M', rowCount + 3, 5, 'l', 'contains=@NoSpell,P,MC,MK')
    Region('M', rowCount + 11, 1, 'l', 'contains=@NoSpell,P,MC,MK')

    # REMOTES
    Region('R', rowCount + 9, 1, 'l', 'contains=@NoSpell display oneline')

    extend(l, ['','',
    '  <S+INS>  CREATE        |  <S+HOME>  CLEAN        |  <PGDN>  -------------  |',
    '  <S+DEL>  DELETE        |  <S+END>   RESET        |  <PGUP>  -------------  |',
    '                         |                         |                         |',
    '  <F1>     MENU          |  <F2>      -----------  |  <F3>    CLOSE          |  <F4>  CHECKOUT',
    '  <F5>     REFRESH       |  <F6>      GUI          |  <F7>    LOG/GITK       |  <F8>  STATUS',
    '', GRemotes(),
    '', '<CTRL+P> PRUNE (UNDER CURSOR) <CTRL+T> FETCH TAGS',
    '', 'BRANCH: ' .. g:head, sep, ''])

    for i in systemlist('git log -n5')
        add(l, substitute(i, '^\s\s\s\s$', '', ''))
    endfor
    extend(l, ['', '', 'Time:' .. reltimestr(reltime(now, reltime()))])
    Say(h, l)

    # POSITION
    let winid = win_getid(1)
    win_execute(winid, printf('norm %s|', lens[0] + 3))
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
    syn match L "[0-9a-f]\{40}" contains=@NoSpell display
    sy region L start="\[" end="\]" contains=@NoSpell display oneline

    hi MC guifg=#27d185
    hi link LBL Identifier
    hi link MK String
    hi link T Function
    hi link A Function
    hi link B Keyword
    hi link C Keyword
    hi link L Keyword
    hi link R Keyword
    hi link S Comment
    hi link D String
    hi link P String

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


def! GRemotes(): string
    let l: string
    for r in systemlist('git remote')
        l = printf('%s  %s', l, r)
    endfor
    retu 'Remotes:' .. l
enddef

" REFRESH TOP WINDOW CONTENTS
" 
" h - Buffer number to write to
" b - Should we clear first 0|1
def! GBRef(h: number, b: number)
    let now = reltime()
    if b
        deletebufline(h, 1, '$')
        sy clear Mnu Brnch C B S D A
    endif

    let rs: list<list<string>>
    for i in systemlist("git branch -a --format='%(objectname:short) %(refname)'")
        let p = split(i)
        let commit = p[0]
        let ref = substitute(p[1], 'refs/remotes/', '', '')
        ref = substitute(ref, 'refs/heads/', '', '')
        let r = [ commit, ref]
        let cmd = "git log -n1 --pretty='%<(78,trunc)%s | %as | %an' " .. commit
        extend(r, split(trim(system(cmd)), ' | '))
        add(rs, r)
    endfor
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
    for r in rs
        add(l, printf(f, r[0], r[1], r[2], r[3], r[4]))
    endfor

    # SYNTAX
    #     B - BRANCH COLUMN
    #     C - COMMIT COLUMN
    #     S - SUBJECT COLUMN
    #     D - DATE COLUMN
    let rowCount = len(l)
    let x = 0
    let y = 0

    # COMMIT
    y = lens[0] + 1
    exe 'sy region C start="\%1c" end="\%' .. y .. 'c" contained oneline'

    # BRANCH
    x = y + 2
    y = x + lens[1] + 1
    exe 'sy region B start="\%' .. x .. 'c" end="\%' .. y .. 'c" contained oneline'

    # SUBJECT
    x = y + 1
    y = x + lens[2] + 1
    exe 'sy region S start="\%' .. x .. 'c" end="\%' .. y .. 'c" contained oneline'

    # DATE
    x = y + 1
    y = x + lens[3] + 1
    exe 'sy region D start="\%' .. x .. 'c" end="\%' .. y .. 'c" contained oneline'

    # AUTHOR
    x = y + 1
    y = x + lens[4] + 1
    exe 'sy region A start="\%' .. x .. 'c" end="\%' .. y .. 'c" contained oneline'

    y = rowCount + 1
    exe 'sy region Brnch start="\%3l" end="\%' .. y .. 'l" contains=C,B,S,D,A'

    x = rowCount + 3
    y = x + 5
    exe 'sy region Mnu start="\%' .. x .. 'l" end="\%' .. y .. 'l" contains=@NoSpell, MnuCmd, MnuKey'
    extend(l, ['','',
    '  <INS>  ADD BRANCH      |  <HOME>  CLEAN          |  <PGDN>  -------------  |',
    '  <DEL>  DELETE BRANCH   |  <END>   RESET          |  <PGUP>  -------------  |',
    '                         |                         |                         |',
    '  <F1>   MENU            |  <F2>    -------------  |  <F3>    CLOSE          |  <F4>  CHECKOUT',
    '  <F5>   REFRESH         |  <F6>    GUI            |  <F7>    LOG/GITK       |  <F8>  STATUS',
    '', GRemotes(), '',
    '<CTRL+P> PRUNE (UNDER CURSOR) <CTRL+T> PULL TAGS', ''
    'BRANCH: ' .. g:head, sep, ''])

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
    sy keyword Label author branch commit date remotes subject
    sy region String start="<" end=">" contains=@NoSpell oneline

    sy keyword MnuCmd add branch checkout clean close delete gitk gui log menu refresh reset status contained
    sy region MnuKey start="<" end=">" contained

    hi Label guifg=#9cdcfe
    hi MnuCmd guifg=#27d185
    hi link MnuKey String
    hi link Brnch Function
    hi link B Keyword
    hi link C Keyword
    hi link S Comment
    hi link D String
    hi link A Function

    # LOCAL KEY BINDS
    let m = 'nnoremap <silent><buffer>'
    exe printf("%s<DEL> :cal <SID>GBDel(%d, %d)<CR>", m, hT, hB)
    exe printf("%s<END> :cal <SID>GBRes(%d, %d)<CR>", m, hT, hB)
    exe printf("%s<F3> :exe 'sil bw! %d %d'<CR>", m, hT, hB)
    exe printf("%s<F4> :cal <SID>GBNav(%d, %d)<CR>", m, hT, hB)
    exe printf("%s<F5> :cal <SID>GBRef(%d, 1)<CR>", m, hT)
    exe printf("%s<HOME> :cal <SID>GBCln(%d, %d)<CR>", m, hT, hB)
    exe printf("%s<INS> :cal <SID>GBNew(%d, %d)<CR>", m, hT, hB)
    exe printf("%s<c-p> :cal <SID>GBPru(%d, %d)<CR>", m, hT, hB)
    exe printf("%s<c-t> :cal <SID>GBTag(%d, %d)<CR>", m, hT, hB)
enddef
nnoremap <silent><F5> :cal <SID>GitBranch()<CR>


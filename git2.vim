
nnoremap <silent><F6> :sil !git gui&<CR>

let g:head = 'AUTO'
def! GitHead(): string
    g:head = Chomp(system('git rev-parse --abbrev-ref HEAD'))
    retu g:head
enddef

def! GitShow(commit: string, path: string)
    if commit == 'DELETED' || commit == 'ADDED'
        retu
    endif
    let title = printf('%s:%s', commit, path)
    OpenTab(title)
    WriteShell(["git show '%s:%s'", commit, path])
enddef

def! GitShowTwo(commitLeft: string, pathLeft: string, commitRight: string, pathRight: string)
    let title = printf('%s:%s', commitRight, pathRight)
    OpenTab(title)
    if commitRight != 'DELETED' && commitRight != 'ADDED'
        WriteShell(["git show '%s:%s'", commitRight, pathRight])
    endif

    title = printf('%s:%s', commitLeft, pathLeft)
    OpenWinVert(title)
    if commitLeft != 'DELETED' && commitLeft != 'ADDED'
        WriteShell(["git show '%s:%s'", commitLeft, pathLeft])
    endif
enddef

def! GitColors()
    syn case ignore
    syn keyword Comment boron carbon dublin ede havana herne hilla hobart
    syn keyword Comment hofu freetown master ibaraki
    syn keyword DiffAdd added
    syn keyword DiffDelete deleted
    syn keyword Keyword arc head
    syn keyword Function architect edoc happy hector jjoker rekam
    syn keyword Keyword hub origin remotes usb vso
    syn keyword String x86 x64 anycpu
    syn keyword LightBlue commit merge author date branch subject
    syn keyword Good modified
    syn region String start="<" end=">" contains=@NoSpell oneline
    syn region String start="`" end="`" contains=@NoSpell oneline
    syn region String start='"' end='"' contains=@NoSpell oneline
    syn region Keyword start="\s.*/" end="\s" contains=@NoSpell oneline
    syn match String "\d\+-\d\+-\d\+"
    syn match Keyword "\d\+\.\d\+"
    syn match Keyword "\d\+\.\d\+\.\d\+"
    syn match Keyword "\d\+\.\d\+\.\d\+\.\d\+"
    syn match Keyword "\d\+\.\d\+\.\d\+\.\d\+\.\d\+"
    syn match Identifier "#\=\d\{5}"
    syn match Keyword "[0-9a-f]\{7,8}" contains=@NoSpell
    syn match Function '^<.*' contains=@NoSpell
    hi LightBlue guifg=#9cdcfe
    hi Bad  guifg=#ee3020
    hi Good guifg=#00b135
enddef

def! GitBranch()
    GitHead()
    OpenTab('GIT')
    let rs: list<list<string>>
    let hs = systemlist("git branch -a --format='%(objectname:short) %(refname)'")
    for h in hs
        let p = split(h)
        let commit = p[0]
        let ref = substitute(p[1], 'refs/remotes/', '', '')
        ref = substitute(p[1], 'refs/heads/', '', '')
        let r = []
        add(r, commit)
        add(r, ref)
        p = split(Chomp(system("git log -n1 --pretty='%as  %an  %s' " .. commit)), '  ')
        add(r, p[2])
        add(r, p[0])
        add(r, p[1])
        add(rs, r)
    endfor
    let cl = Longest(rs, 0, 7, 100)
    let bl = Longest(rs, 1, 10, 100)
    let sl = Longest(rs, 2, 7, 100)
    let f = '%-' .. cl .. 's  %-' .. bl .. 's  %-' .. sl .. 's  %-11s %-20s'
    let h = printf(f, 'COMMIT', 'BRANCH', 'SUBJECT', 'DATE', 'AUTHOR')
    let hl = strchars(h)
    Write([h])
    Write([repeat('-', hl)])
    for r in rs
        Write([f, r[0], r[1], r[2], r[3], r[4] ])
    endfor
    setline('$', ['',
    '<INS> ADD BRANCH   <HOME> CLEAN',
    '<DEL> DEL BRANCH   <END>  RESET (HARD)',
    '<F4>  CHECKOUT     <F5>   REFRESH', '', repeat('-', hl), ''])
    norm G
    Write(['BRANCH: %s', g:head])
    Write([''])
    WriteShell(["git log -n5 HEAD"])
    exe '%s/\s\+$//e'
    exe printf('norm %s|', cl + 3)
    exe '3'
    GitColors()
    setl colorcolumn=
    nnoremap <silent><buffer><INS> :cal <SID>GitBranchNew()<CR>
    nnoremap <silent><buffer><DEL> :cal <SID>GitBranchDel()<CR>
    nnoremap <silent><buffer><HOME> :cal <SID>GitBranchClean()<CR>
    nnoremap <silent><buffer><END> :cal <SID>GitBranchReset()<CR>
    nnoremap <silent><buffer><F4> :cal <SID>GitBranchNav()<CR>
enddef
nnoremap <silent><F5> :cal <SID>GitBranch()<CR>

def! GitBranchClean(): void
    OpenWin('BRANCH')
    WriteShell(['git clean -xdf'])
    GitBranch()
enddef

def! GitBranchDel()
    OpenWin('BRANCH')
    WriteShell(['git branch -d %s', expand('<cfile>')])
    GitBranch()
enddef

def! GitBranchNav()
    let col = col('.')
    if col > 0 && col < 12
        call <SID>GitLog(expand('<cword>'))
    elseif col > 10 && col < 80
        OpenWin('BRANCH')
        WriteShell(['git checkout %s', expand('<cfile>:t')])
        GitBranch()
    endif
enddef

def! GitBranchNew()
    OpenWin('BRANCH')
    WriteShell(['git branch %s', expand('<cfile>')])
    GitBranch()
enddef

def! GitBranchReset()
    OpenWin('BRANCH')
    WriteShell(['git reset --hard %s', expand('<cfile>')])
    GitBranch()
enddef

def! GitDiff(commit: string)
    OpenTab('SUMMARY: ' .. commit)
    setl colorcolumn=

    GitHead()
    Write(['FILES %-84s %-8s  %-8s  %-8s  %-14s %s', commit, 'BEFORE', 'AFTER', g:head, 'COMPARE', 'SIDE BY SIDE'])
    Write([repeat('-', 160)])

    let items = ShellList(['git diff --numstat %s~1 %s', commit, commit])
    for item in items
        let stats = matchlist(item, '\(\d\+\)\s\(\d\+\)\s\(.*\)')
        let added = str2nr(stats[1])
        let removed = str2nr(stats[2])
        let path = stats[3]
        let past = ShellList(["git log -n3 --pretty=%s %s -- '%s'", '%h', commit, path])
        let pastLen = len(past)

        let after: string
        let before: string

        if pastLen == 1
            before = 'ADDED'
            after = commit
        else
            before = past[1]
            if added > 1
                after = commit
            else
                Shell(["git show '%s:%s'", commit, path])
                after = v:shell_error ? 'DELETED' : commit
            endif
        endif

        let head = filereadable(path) ? g:head : 'DELETED'
        Write(['%-90s %-8s  %-8s  %-8s  B:A  B:H  A:H  B-A  B-H  A-H', path, before, after, head])
    endfor

    setline('$', ['',
    '<F4>  INSPECT',
    '<F6>  GIT GUI    <F7>   GIT LOG (UNDER CURSOR)',
    'CLICK ON FILE TO EDIT'
    ''])

    norm gg
    exe '3'
    GitColors()
    syn region String start="\%>2l" end="\%90c" contains=@NoSpell oneline

    noremap <silent><buffer><2-LeftMouse> :cal <SID>GitDiffNav()<CR>
    nnoremap <silent><buffer><F4> :cal <SID>GitDiffNav()<CR>
    nnoremap <silent><buffer><F7> :cal <SID>GitLog(expand('<cfile>'))<CR>
enddef

def! GitDiffNav()
    let col = col('.')
    let lnr = line('.')
    let line = getline(lnr)

    let path = trim(strcharpart(line, 0, 90))
    let before = trim(strcharpart(line, 91, 8))
    let after = trim(strcharpart(line, 101, 8))
    let head = trim(strcharpart(line, 111, 8))

    # FILE
    if col > 0 && col < 92 && filereadable(path)
        exe 'tabnew ' .. path

    elsei col > 91 && col < 102
        # BEFORE
        GitShow(before, path)

    elsei col > 101 && col < 112
        # AFTER
        GitShow(after, path)

    elsei col > 111 && col < 121
        # HEAD
        GitShow(head, path)

    # BEFORE AFTER
    elsei col > 121 && col < 127 && before != 'DELETED' && after != 'DELETED'
        GitShowTwo(before, path, after, path)
        exe 'windo diffthis'

    # BEFORE HEAD
    elsei col > 126 && col < 131 && before != 'DELETED' && head != 'DELETED'
        GitShowTwo(before, path, head, path)
        exe 'windo diffthis'

    # AFTER HEAD
    elsei col > 131 && col < 136 && after != 'DELETED' && head != 'DELETED'
        GitShowTwo(after, path, head, path)
        exe 'windo diffthis'

    # SXS - BEFORE AFTER
    elsei col > 136 && col < 141 && before != 'DELETED' && after != 'DELETED'
        GitShowTwo(before, path, after, path)

    # SXS - BEFORE HEAD
    elsei col > 141 && col < 146 && before != 'DELETED' && head != 'DELETED'
        GitShowTwo(before, path, head, path)

    # SXS - AFTER HEAD
    elsei col > 146 && after != 'DELETED' && head != 'DELETED'
        GitShowTwo(after, path, head, path)
    endif

    norm gg
enddef

def! GitLog(commit: string = 'AUTO')
    GitHead()
    let ref = commit == 'AUTO' ? g:head : commit
    OpenTab('LOG:' .. ref)
    Write(['TREE      COMMIT    %-81s AUTHOR', ref])
    Write([repeat('-', 130)])
    let fmt = '\%<(8)\%t  \%<(8)\%h  \%<(80,trunc)\%s  \%<(16)\%an  \%as'
    WriteShell(["git log -n50 --pretty=format:'%s' %s", fmt, ref])

    Write([''])
    Write(['TREE      COMMIT    TAG/REMOTE'])
    Write([repeat('-', 130)])

    let refs = ShellList(['git rev-parse --short --tags --branches --remotes HEAD'])
    sort(refs)
    uniq(refs)
    for r in refs
        WriteShell(["git log -n1 --pretty=format:'%s' %s", fmt, r])
    endfor

    setline('$', ['',
    '<F4>  INSPECT',
    '<F6>  GIT GUI    <F7>   GIT LOG (UNDER CURSOR)',
    ''])
    norm gg21|
    setl colorcolumn=
    GitColors()

    nnoremap <silent><buffer><2-LeftMouse> :cal <SID>GitLogNav()<CR>
    nnoremap <silent><buffer><F4> :cal <SID>GitDiff(expand('<cword>'))<CR>
    nnoremap <silent><buffer><F7> :cal <SID>GitLog(expand('<cfile>'))<CR>
enddef
nnoremap <silent><F7> :cal <SID>GitLog(g:head)<CR>

def! GitLogNav()
    let col = col('.')
    if col > 0 && col < 11
        GitDiff(expand('<cword>'))
    elseif col > 10 && col < 21
        GitDiff(expand('<cword>'))
    else
        GitLog(expand('<cfile>'))
    endif
enddef

def! GitStatus()
    GitHead()
    OpenTab('GIT')
    WriteShell(['git status'])
    setline('$', ['',
    '<INS> ADD ALL    <PGUP> PUSH',
    '<END> COMMIT     <PGDN> FETCH',
    '<F6>  GIT GUI    <F7>   GIT LOG (COMMIT UNDER CURSOR)',
    '<F8>  REFRESH', '', '', repeat('-', 80), ''])
    norm G
    WriteShell(['git log -n5'])
    exe '%s/\s\+$//e'
    GitColors()
    setl colorcolumn=
    norm gg
    nnoremap <silent><buffer><END> :Gcommit<CR>
    nnoremap <silent><buffer><INS> :cal <SID>GitStatusAdd()<CR>
    nnoremap <silent><buffer><PageDown> :cal <SID>GitStatusFetch()<CR>
    nnoremap <silent><buffer><PageUp> :cal <SID>GitStatusPush()<CR>
    # nnoremap <silent><buffer><F7> :cal <SID>GitLog(expand('<cword>'))<CR>
enddef
nnoremap <silent><F8> :cal <SID>GitStatus()<CR>

def! GitStatusAdd()
    OpenWinShell('SO', ['git add .'])
    GitStatus()
enddef

def! GitStatusFetch()
    OpenWinShell('SO', ['git fetch'])
    GitStatus()
enddef

def! GitStatusPush()
    OpenWinShell('SO', ['git push'])
    GitStatus()
enddef



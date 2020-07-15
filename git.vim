
nnoremap <silent><F6> :sil !git gui&<CR>

let g:head = ''
def! GitHead(): string
    g:head = Chomp(system('git rev-parse --abbrev-ref HEAD'))
    retu g:head
enddef

def! GitAsyncWin(cmd: string, title: string, msg: string)
    OpenWin(title, 0)
    setline('$', [msg, cmd])
    WriteShellAsync(cmd)
enddef

def! GitShow(commit: string, path: string)
    if commit == 'DELETED' || commit == 'ADDED'
        retu
    endif
    let title = printf('%s:%s', commit, path)
    OpenTab(title)
    let cmd = printf('git show %s:%s', commit, path)
    WriteShellAsync(cmd)
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
    syn keyword Function architect edoc happy hector ioan jjoker rekam radu
    syn keyword Keyword anna hub origin remotes usb vso
    syn keyword String x86 x64 anycpu
    syn keyword LightBlue commit merge author date branch subject tag tree
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

def! GitRemotes(): string
    let line: string
    let remotes = systemlist('git remote')
    for remote in remotes
        line =  printf('%s  %s', line, remote)
    endfor
    return printf('Remotes:%s', line)
enddef

def! GitBranch()
    let startTime = reltime()

    GitHead()
    OpenTab('GIT')
    let rs: list<list<string>>
    let hs = systemlist("git branch -a --format='%(objectname:short) %(refname)'")
    for h in hs
        let p = split(h)
        let commit = p[0]
        let ref = substitute(p[1], 'refs/remotes/', '', '')
        ref = substitute(ref, 'refs/heads/', '', '')
        let r = [ commit, ref]
        let cmd = "git log -n1 --pretty='%<(78,trunc)%s | %as | %an' " .. commit
        let line = Chomp(system(cmd))
        extend(r, split(line, ' | '))
        add(rs, r)
    endfor
    let lens = [
        Longest(rs, 0, 7, 100),
        Longest(rs, 1, 10, 100),
        Longest(rs, 2, 7, 100),
        11,
        Longest(rs, 4, 7, 100)]

    let f = '%-' .. lens[0] .. 's  %-' .. lens[1] .. 's  %-' .. lens[2] .. 's  %-' .. lens[3] .. 's  %-' .. lens[4] .. 's'
    let h = printf(f, 'COMMIT', 'BRANCH', 'SUBJECT', 'DATE', 'AUTHOR')
    let hl = strchars(h)
    let sep = repeat('-', hl)

    append('^', [h, sep])
    for r in rs
        append(line('$') - 1, printf(f, r[0], r[1], r[2], r[3], r[4]))
    endfor

    append('$', [
    '<INS> ADD BRANCH   <HOME> CLEAN',
    '<DEL> DEL BRANCH   <END>  RESET (HARD)',
    '<F4>  CHECKOUT     <F5>   REFRESH',
    '<SHIFT+F7> GITK (UNDER CURSOR)',
    '', GitRemotes(), '',
    '<CTRL+P> PRUNE (UNDER CURSOR) <CTRL+T> PULL TAGS', ''
    'BRANCH: ' .. g:head, sep, ''])

    norm G
    WriteShell(["git log -n5 HEAD"])
    exe 'sil %s/\s\+$//e'

    # POSITION
    exe printf('norm %s|', lens[0] + 3)
    exe '3'

    # SYNTAX
    GitColors()
    setl colorcolumn=

    # LOCAL KEY BINDS
    nnoremap <silent><buffer><c-t> :cal <SID>GitFetchTags()<CR>
    nnoremap <silent><buffer><c-p> :cal <SID>GitBranchPrune()<CR>
    nnoremap <silent><buffer><INS> :cal <SID>GitBranchNew()<CR>
    nnoremap <silent><buffer><DEL> :cal <SID>GitBranchDel()<CR>
    nnoremap <silent><buffer><HOME> :cal <SID>GitBranchClean()<CR>
    nnoremap <silent><buffer><END> :cal <SID>GitBranchReset()<CR>
    nnoremap <silent><buffer><F4> :cal <SID>GitBranchNav()<CR>

    # PERFORMANCE
    append('$' ['', 'Time:' .. reltimestr(reltime(startTime, reltime()))])
enddef
nnoremap <silent><F5> :cal <SID>GitBranch()<CR>

def! GitFetchTags()
    GitAsyncWin('git fetch --tags ' .. expand('<cword>'),
        'BRANCH', 'FETCHING TAGS')
enddef

def! GitBranchPrune()
    GitAsyncWin('git remote prune ' .. expand('<cword>'),
        'BRANCH', 'PRUNING')
enddef

def! GitBranchClean()
    GitAsyncWin('git clean -xdf -e *.swp', 'BRANCH', 'CLEANING')
enddef

def! GitBranchDel()
    GitAsyncWin('git branch -d ' .. expand('<cfile>'),
        'BRANCH', 'DELETE BRANCH')
enddef

def! GitBranchNew()
    GitAsyncWin('git branch ' .. expand('<cfile>'),
        'BRANCH', 'NEW BRANCH')
enddef

def! GitBranchReset()
    GitAsyncWin('git reset --hard ' .. expand('<cfile>'),
        'BRANCH', 'RESET BRANCH')
enddef

def! GitDiff(commit: string)
    GitHead()
    OpenTab('SUMMARY: ' .. commit)
    setl colorcolumn=

    Write(['FILES %-84s %-8s  %-8s  %-8s  %-14s %s', commit, 'BEFORE', 'AFTER', 'HEAD', 'COMPARE', 'SIDE BY SIDE'])
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
    '<F6>  GIT GUI    <F7>       GIT LOG (UNDER CURSOR)',
    '                 <SHIFT+F7> GITK (UNDER CURSOR)',
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

def! InnerGitLog(commit: string)
    let startTime = reltime()

    OpenTab('LOG:' .. commit)

    let rows: list<list<string>>
    let cmd = "git log -n50 --pretty='%t | %h | %<(78,trunc)%s | %as | %an' " .. commit
    let log = systemlist(cmd)
    for entry in log
        rows->add(split(entry, ' | '))
    endfor

    let lens = [
        Longest(rows, 0, 7, 100),
        Longest(rows, 1, 7, 100),
        Longest(rows, 2, 7, 100),
        11,
        Longest(rows, 4, 7, 100)]

    let fmt = '%-' .. lens[0] .. 's  %-' .. lens[1] .. 's  %-' .. lens[2] .. 's  %-' .. lens[3] .. 's  %-' .. lens[4] .. 's'
    let hdr = printf(fmt, 'TREE', 'COMMIT', commit, 'DATE', 'AUTHOR')
    let hdrLen = strchars(hdr)
    let sep = repeat('-', hdrLen)

    append('^', [hdr, sep])
    for row in rows
        append(line('$') - 1, printf(fmt, row[0], row[1], row[2], row[3], row[4]))
    endfor

    # BRANCHES
    append('$', [
    printf(fmt, 'TREE', 'COMMIT', 'TAG', 'DATE', 'AUTHOR'), sep, ''])
    norm G

    let refs = ShellList(['git rev-parse --short --tags HEAD'])
    for r in refs
        let line = Chomp(system("git log -n1 --pretty='%t | %h | %<(78,trunc)%D | %as | %an' " .. r))
        let row = split(line, ' | ')
        append(line('$') - 1, printf(fmt, row[0], row[1], row[2], row[3], row[4]))
    endfor
    exe 'sil %s/\s\+$//e'

    setline('$', ['',
    '<F4>  INSPECT    <F5>       VIEW BRANCHES', 
    '<F6>  GIT GUI    <F7>       GIT LOG (UNDER CURSOR)',
    '                 <SHIFT+F7> GITK (UNDER CURSOR)',
    ''])

    # POSITION
    norm gg21|

    # SYNTAX
    setl colorcolumn=
    GitColors()

    # LOCAL KEY BINDS
    nnoremap <silent><buffer><2-LeftMouse> :cal <SID>GitLogNav()<CR>
    nnoremap <silent><buffer><F4> :cal <SID>GitDiff(expand('<cword>'))<CR>

    # PERFORMANCE
    append('$' ['', 'Time:' .. reltimestr(reltime(startTime, reltime()))])
enddef

def! GitLog()
    GitHead()
    let hint = expand('<cfile>')
    if strlen(hint) > 0
        InnerGitLog(hint)
    else
        InnerGitLog(g:head)
    endif
enddef
nnoremap <silent><F7> :cal <SID>GitLog()<CR>

def! GitLogPath(path: string)
    OpenTab('TRACE')
    Write(['COMMIT   %-80s DATE       AUTHOR', path])
    Write([repeat('-', 130)])
    WriteShell(["git log --pretty=format:'%s' -- '%s'",
        '\%<(8)\%h \%<(80,trunc)\%s \%cs \%an',
        path])

    exe '3'
    normal 1|
    setl colorcolumn=
    GitColors()

    exe printf("noremap <silent><buffer><2-LeftMouse> :cal <SID>git_trace_nav('%s')<CR>", path)
    exe printf("nnoremap <silent><buffer><F4> :cal <SID>git_trace_nav('%s')<CR>", path)
    exe printf("nnoremap <silent><buffer><F5> :cal <SID>git_log_file('%s')<CR>", path)
enddef

def! GitLogNav()
    let col = col('.')
    if col > 0 && col < 11
        GitDiff(expand('<cword>'))
    elseif col > 10 && col < 21
        GitDiff(expand('<cword>'))
    else
        GitLog()
    endif
enddef

def! GitBranchNav()
    if col('.') < 10
        GitLog()
    else
        let cmd = 'git checkout ' .. expand('<cfile>:t')
        OpenWin('BRANCH')
        setline('$', ['SWITCHING BRANCH', cmd])
        WriteShellAsync(cmd)
    endif
enddef

def! GitStatus()
    let startTime = reltime()

    GitHead()
    OpenTab('GIT')
    WriteShell(['git status'])
    append('$', [
    '<INS> ADD ALL    <PGUP>     PUSH',
    '<END> COMMIT     <PGDN>     FETCH',
    '<F6>  GIT GUI    <F7>       GIT LOG (COMMIT UNDER CURSOR)',
    '<F8>  REFRESH    <SHIFT+F7> GIK (UNDER CURSOR)',
    '', repeat('-', 80), ''])

    norm G
    WriteShell(['git log -n5'])
    exe '%s/\s\+$//e'

    # POSITION
    norm gg

    # SYNTAX
    setl colorcolumn=
    GitColors()

    # LOCAL KEY BINDS
    nnoremap <silent><buffer><END> :Gcommit<CR>
    nnoremap <silent><buffer><INS> :cal <SID>GitStatusAdd()<CR>
    nnoremap <silent><buffer><PageDown> :cal <SID>GitStatusFetch()<CR>
    nnoremap <silent><buffer><PageUp> :cal <SID>GitStatusPush()<CR>

    # PERFORMANCE
    append('$' ['', 'Time:' .. reltimestr(reltime(startTime, reltime()))])
enddef
nnoremap <silent><F8> :cal <SID>GitStatus()<CR>

def! GitStatusAdd()
    GitAsyncWin('git add .', 'SO', 'ADDING ALL FILES')
    GitStatus()
enddef

def! GitStatusFetch()
    GitAsyncWin('git fetch', 'SO', 'FETCHING')
    GitStatus()
enddef

def! GitStatusPush()
    GitAsyncWin('git push', 'SO', 'PUSHING')
    GitStatus()
enddef

def! GitK()
    let path = expand('<cfile>')
    if filereadable(path)
        exe printf("sil !gitk -- '%s'& ", path)
    elsei strlen(path) > 0
        exe printf("sil !gitk %s&", path)
    else
        exe "sil !gitk&"
    endif
enddef
nnoremap <silent><S-F7> :cal <SID>GitK()<CR>


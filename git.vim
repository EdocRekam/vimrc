
"
" GIT SYNTAX COLORING
"
function! s:GitColors()
    syn case ignore
    syn keyword Comment boron carbon dublin ede havana herne hilla hobart
    syn keyword Comment hofu freetown master ibaraki
    syn keyword Function arch architect edoc happy head hector jjoker rekam
    syn keyword Statement hub origin remotes usb vso
    syn keyword String x86 x64 anycpu
    syn region String start="`" end="`" contains=@NoSpell oneline
    syn region String start='"' end='"' contains=@NoSpell oneline
    syn match String "\d\+\.\d\+"
    syn match String "\d\+\.\d\+\.\d\+"
    syn match String "\d\+\.\d\+\.\d\+\.\d\+"
    syn match String "\d\+\.\d\+\.\d\+\.\d\+\.\d\+"
    syn match Identifier "#\=\d\{5}"
    syn match Keyword "[0-9a-f]\{7,8}" contains=@NoSpell
    " syn region Identifier start="\%57c" end="\%64c"
    " syn region String     start="\%64c" end="\%71c"
    " syn region Keyword    start="\%71c" end="$"
    " syn match Comment "^COMMIT SUMMARY.*" contains=@NoSpell
endfunction

function! GitDiff(commit)
    call s:TabCommand('DIFF', printf('git diff HEAD..%s', a:commit))
endfunction

function! GitDiffSummary(commit)
    call s:MakeTabBuffer(printf('SUMMARY: %s', a:commit))
    setlocal colorcolumn=

    call s:WriteLine('FILES %-84s %-8s  %-8s  %-8s  %s', a:commit, 'BEFORE', 'AFTER', 'HEAD', 'COMPARE')
    call s:WriteLine(repeat('-', 160))

    let l:head = s:Chomp(s:Shell('git rev-parse --short HEAD'))
    let l:files = s:ShellList('git diff --name-only %s~1', a:commit)
    for l:file in l:files
        let l:before = s:Chomp(s:Shell("git log -n2 --pretty=%s %s -- '%s' | tail -n1", '%h', a:commit, l:file))
        call s:WriteLine('%-90s %-8s  %-8s  %-8s  B:A  B:H', l:file, l:before, a:commit, l:head)
    endfor
    exe '3'
    call s:GitColors()
    syn region String start="\%>2l" end="\%90c" contains=@NoSpell oneline

    noremap <silent><buffer><2-LeftMouse> :call GitDiffSummaryGotoDefinition()<CR>
    nnoremap <silent><buffer><F4> :call GitDiffSummaryGotoDefinition()<CR>
    exe printf("nnoremap <silent><buffer><F5> :call GitDiffSummary('%s')<CR>", a:commit)
endfunction

function! GitDiffSummaryGotoDefinition()
    let l:col = col('.')
    let l:lnr = line('.')
    let l:line = getline(l:lnr)
    let l:file = trim(strcharpart(l:line, 0, 90))

    " FILE
    if l:col > 0 && l:col < 92
        silent exe printf('tabnew %s', l:file)

    " BEFORE
    elseif l:col > 91 && l:col < 102
        let l:before = trim(strcharpart(l:line, 91, 8))
        call GitShowFile(l:before, l:file)

    " AFTER
    elseif l:col > 101 && l:col < 112
        let l:after  = trim(strcharpart(l:line, 101, 8))
        call GitShowFile(l:after, l:file)

    " HEAD
    elseif l:col > 111 && l:col < 121
        let l:head = trim(strcharpart(l:line, 111, 8))
        call GitShowFile(l:head, l:file)

    " BEFORE AFTER
    elseif l:col > 121 && l:col < 127
        let l:after  = trim(strcharpart(l:line, 101, 8))
        call GitShowFile(l:after, l:file)
        let l:syntax = &syntax
        exe 'vsplit'
        let l:before = trim(strcharpart(l:line, 91, 8))
        call s:NewOrReplaceBuffer(printf('%s:%s', l:before, l:file))
        call s:WriteExecute("git show %s -- '%s'", l:before, l:file)
        if l:syntax
            exe printf('setf %s', l:syntax)
        endif
        exe 'windo diffthis'
        normal gg

    " BEFORE HEAD
    else
        exe printf('tabnew %s', l:file)
        let l:syntax = &syntax
        exe 'vsplit'
        let l:before = trim(strcharpart(l:line, 91, 8))
        call s:NewOrReplaceBuffer(printf('%s:%s', l:before, l:file))
        call s:WriteExecute('git show %s:%s', l:before, l:file)
        exe printf('setf %s', l:syntax)
        exe 'windo diffthis'
        normal gg

    endif
endfunction

function! GitFetch(remote)
    call s:TabCommand('FETCH', printf('git fetch %s', a:remote))
endfunction

"
" DISPLAY GIT LOG HISTORY AND BRANCHES IN A NEW TAB
"
function! GitList(...)
    let l:branch = get(a:, 1, s:Chomp(system('git rev-parse --abbrev-ref HEAD')))

    call s:MakeTabBuffer(printf('LOG: %s', l:branch))
    call s:WriteLine('TREE      COMMIT    %-81s AUTHOR', l:branch)
    call s:WriteLine(repeat('-', 130))

    call s:WriteExecute("git log -n75 --pretty=format:'%s' %s"
                \ ,'\%<(8)\%t  \%<(8)\%h  \%<(80,trunc)\%s  \%<(16)\%an  \%as'
                \ ,l:branch)

    call s:WriteLine('')
    call s:WriteLine('TREE      COMMIT    TAG/REMOTE')
    call s:WriteLine(repeat('-', 130))

    let l:refs = s:ShellList('git rev-parse --short --tags --branches --remotes HEAD | sort -u')
    for l:ref in l:refs
         let l:msg = s:Shell("git log -n1 --pretty=format:'%s' %s", '%<(8)%t  %<(8)%h  %<(80,trunc)%D  %<(16)%an  %as', l:ref)
         call s:WriteLine(l:msg)
    endfor

    normal gg
    normal 21|
    setlocal colorcolumn=
    call s:GitColors()

    noremap <silent><buffer><2-LeftMouse> :call GitListGotoDefinition()<CR>
    nnoremap <silent><buffer><F4> :call GitListGotoDefinition()<CR>
    exe printf("nnoremap <silent><buffer><F5> :call GitList('%s')<CR>", l:branch)
endfunction

" JUMP TO A NEW LOCATION BASED ON CURSOR IN GITLIST
function! GitListGotoDefinition()
    let l:col = col('.')
    if l:col > 0 && l:col < 11
        call GitDiffSummary(expand('<cword>'))
    elseif l:col > 10 && l:col < 21
        call GitDiffSummary(expand('<cword>'))
    else
        call GitList(expand('<cfile>'))
    endif
endfunction

function! GitPrune(remote)
    call s:TabCommand('PRUNE', printf('git remote prune %s', a:remote))
endfunction

function! GitShowFile(commit, file)
    let l:cmd = printf("git show %s -- '%s'", a:commit, a:file)
    call s:TabCommand(printf('%s:%s', a:commit, a:file), l:cmd)
endfunction

function! GitStatus()
    call s:TabCommand('STATUS', 'git status')
    setf gitmisc
endfunction

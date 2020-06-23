
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

function! GitDiffSummaryOpen()
    let l:col = col('.')
    let l:lnr = line('.')
    let l:line = getline(l:lnr)
    let l:file = trim(strcharpart(l:line, 0, 60))
    let l:commit = trim(strcharpart(l:line, 61, 8))

    if l:col < 72
        silent exe printf('tabnew %s', l:file)
    elseif l:col < 82 && l:col > 71
        let l:before = trim(strcharpart(l:line, 71, 8))
        call GitShowFile(l:before, l:file)
    elseif l:col < 92 && l:col > 81
        let l:after  = trim(strcharpart(l:line, 81, 8))
        call GitShowFile(l:after, l:file)
    elseif l:col < 102 && l:col > 91
        let l:head = trim(strcharpart(l:line, 91, 8))
        call GitShowFile(l:head, l:file)
    elseif l:col > 105
        exe printf('tabnew %s', l:file)
        let l:syntax = &syntax
        exe 'vsplit'
        let l:before = trim(strcharpart(l:line, 71, 8))
        call s:NewOrReplaceBuffer(printf('%s:%s', l:before, l:file))
        call s:WriteExecute(printf('git show %s:%s', l:before, l:file))
        exe printf('setf %s', l:syntax)
        exe 'windo diffthis'
    else
        let l:after  = trim(strcharpart(l:line, 81, 8))
        call GitShowFile(l:after, l:file)
        let l:syntax = &syntax
        exe 'vsplit'
        let l:before = trim(strcharpart(l:line, 71, 8))
        call s:NewOrReplaceBuffer(printf('%s:%s', l:before, l:file))
        call s:WriteExecute(printf('git show %s:%s', l:before, l:file))
        exe printf('setf %s', l:syntax)
        exe 'windo diffthis'
    endif
endfunction

function! GitDiffSummary(commit)
    call s:MakeTabBuffer(printf('SUMMARY: %s', a:commit))
    setlocal colorcolumn=

    call s:WriteLine(printf('%-70s %-8s  %-8s  %-8s  %s', 'FILE', 'BEFORE', 'AFTER', 'HEAD', 'COMPARE'))
    call s:WriteLine(repeat('-', 130))

    let l:head = s:Chomp(system('git rev-parse --short HEAD'))
    let l:cmd = printf('git diff --name-only %s~1', a:commit)
    let l:files = systemlist(l:cmd)
    for l:file in l:files
        let l:parent = s:Chomp(system(printf("git log -n1 --pretty=%s %s '%s'", '%p', a:commit, l:file)))
        call s:WriteLine(printf('%-70s %-8s  %-8s  %-8s  B:A  B:H', l:file, l:parent, a:commit, l:head))
    endfor
    exe '3'
    call s:GitColors()
    syn region String start="\%>2l" end="\%70c" contains=@NoSpell oneline

    noremap <silent><buffer><2-LeftMouse> :call GitDiffSummaryOpen()<CR>
    nnoremap <silent><buffer><F4> :call GitDiffSummaryOpen()<CR>
    exe printf("nnoremap <silent><buffer><F5> :call GitDiffSummary('%s')<CR>", a:commit)
endfunction

function! GitFetch(remote)
    call s:TabCommand('FETCH', printf('git fetch %s', a:remote))
endfunction

"
" DISPLAY GIT LOG HISTORY AND BRANCHES IN A NEW TAB
"
function! GitList()
    call s:MakeTabBuffer('GIT LOG')

    let l:branch = s:Chomp(system('git rev-parse --abbrev-ref HEAD'))

    call s:WriteLine(printf('TREE    COMMIT   %-81s AUTHOR', l:branch))
    call s:WriteLine(repeat('-', 130))
    call s:WriteExecute('git log -n75 --pretty=format:\%t\ \%h\ \ \%\<\(80,trunc\)\%s\ \ \%\<\(16\)\%an\ \ \%as')

    call s:WriteLine('')
    call s:WriteLine('  BRANCH                      COMMIT')
    call s:WriteLine(repeat('-', 130))
    call s:WriteExecute('git branch -lrav --no-color')

    normal gg
    call s:GitColors()

    noremap <silent><buffer><2-LeftMouse> :call GitDiffSummary(expand('<cword>'))<CR>
    nnoremap <silent><buffer><F4> :call GitDiffSummary(expand('<cword>'))<CR>
    nnoremap <silent><buffer><F5> :call GitList()<CR>
endfunction

function! GitPrune(remote)
    call s:TabCommand('PRUNE', printf('git remote prune %s', a:remote))
endfunction

function! GitShowFile(commit, file)
    let l:cmd = printf('git show %s:%s', a:commit, a:file)
    call s:TabCommand(printf('%s:%s', a:commit, a:file), l:cmd)
endfunction

function! GitStatus()
    call s:TabCommand('STATUS', 'git status')
    setf gitmisc
endfunction


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
endfunction

function! GitDiff(commit)
    call s:TabCommand('DIFF', printf('git diff HEAD..%s', a:commit))
endfunction

function! GitDiffSummaryOpen()
    let l:col = col('.')
    let l:linenr = line('.')
    let l:line = getline(l:linenr)
    let l:file = trim(strcharpart(l:line, 0, 60))
    let l:commit = trim(strcharpart(l:line, 61, 8))

    if l:col < 73
        call GitShowFile(l:commit, l:file)
    elseif l:col < 81
        silent exe printf('tabnew %s', l:file)
    else
        exe printf('tabnew %s', l:file)
        let l:syntax = &syntax
        exe 'vsplit'

        call s:NewOrReplaceBuffer(l:commit)
        exe printf('setf %s', l:syntax)
        call s:WriteExecute(printf('git show %s:%s', l:commit, l:file))
        exe 'windo diffthis'
        unlet l:syntax
    endif

    unlet l:col
    unlet l:commit
    unlet l:file
    unlet l:line
    unlet l:linenr
endfunction

function! GitDiffSummary(commit)
    call s:MakeTabBuffer(printf('Summary: %s', a:commit))

    call s:WriteLine(printf('%-60s %s', 'FILE', 'COMMIT'))
    call s:WriteLine(repeat('-', 120))

    let l:cmd = printf('git diff --name-only HEAD..%s', a:commit)
    let l:files = systemlist(l:cmd)
    for l:file in l:files
        call s:WriteLine(printf('%-60s %s    HEAD    DIFF', l:file, a:commit))
    endfor

    normal gg

    noremap <silent><buffer><2-LeftMouse> :call GitDiffSummaryOpen()<CR>
    nnoremap <silent><buffer><F4> :call GitDiffSummaryOpen()<CR>
    exe printf("nnoremap <silent><buffer><F5> :call GitDiffSummary('%s')<CR>", a:commit)

    " syn region Keyword    start="\%1c"  end="\%57c" contains=@NoSpell
    " syn region Identifier start="\%57c" end="\%64c"
    " syn region String     start="\%64c" end="\%71c"
    " syn region Keyword    start="\%71c" end="$"
    " syn match Comment "^COMMIT SUMMARY.*" contains=@NoSpell
    call s:GitColors()
endfunction

function! GitFetch(remote)
    call s:TabCommand('FETCH', printf('git fetch %s', a:remote))
endfunction

function! GitListBranches()
    call s:TabCommand('BRANCHES', 'git branch -lra')
endfunction

function! GitShowFile(commit, file)
    let l:cmd = printf('git show %s:%s', a:commit, a:file)
    call s:TabCommand(printf('%s:%s', a:commit, a:file), l:cmd)
    unlet l:cmd
endfunction

function! s:PickupFileName(commit)
    let l:line = getline(line('.'))
    let l:file = trim(strcharpart(l:line, 0, 56))
    return [ a:commit, l:file ]
endfunction

function! NavigateToFile(commit)
    let l:args = s:PickupFileName(a:commit)
    call GitShowFile(l:args[0], l:args[1])
    unlet l:args
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
    call s:WriteLine('BRANCHES')
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

function! GitStatus()
    call s:TabCommand('STATUS', 'git status')
    setf gitmisc
endfunction

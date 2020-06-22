
function! s:Chomp(msg)
    return strcharpart(a:msg, 0, strlen(a:msg)-1)
endfunction

function! s:WriteLine(msg)
    call append(line("$"), a:msg)
endfunction

function! s:WriteExecute(cmd)
    silent execute printf('%dr !%s', line("$"), a:cmd)
endfunction

function! GitCommand(title, cmd)
    if bufexists(a:title)
        let l:bufnr = bufnr(a:title)
        exe printf("%dbd!", l:bufnr)
    endif

    tabnew a:title
    let l:bufnr = bufadd(a:title)
    call bufload(l:bufnr)
    exe printf("%db", l:bufnr)
    setlocal buflisted
    setlocal buftype=nofile
    silent exe printf("0r !%s", a:cmd)
    normal gg
    unlet l:bufnr
endfunction

function! GitDiff(commit)
    let l:cmd = printf('git diff HEAD..%s', a:commit)
    call GitCommand('DIFF', l:cmd)
endfunction

function! GitShowFile(commit, file)
    let l:cmd = printf('git show %s:%s', a:commit, a:file)
    call GitCommand(printf('%s:%s', a:commit, a:file), l:cmd)
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

function! GitDiffSummary(commit)
    let l:title = printf('Summary: %s', a:commit)
    if bufexists(l:title)
        let l:bufnr = bufnr(l:title)
        exe printf("%dbd!", l:bufnr)
    endif

    tabnew l:title
    let l:bufnr = bufadd(l:title)
    call bufload(l:bufnr)
    exe printf("%db", l:bufnr)
    setlocal buflisted
    setlocal buftype=nofile

    call append(0, printf('COMMIT SUMMARY %s', a:commit))
    call append(line("$"), 'FILE')
    call append(line("$"), repeat('-', 75))

    let l:cmd = printf('git diff --name-only HEAD..%s', a:commit)
    let l:files = systemlist(l:cmd)
    for l:file in l:files
        call append(line("$"), printf('%-55s OLD    NEW    DIFF', l:file))
    endfor

    normal gg
    unlet l:bufnr

    exe printf("nnoremap <silent><buffer><F4> :call NavigateToFile('%s')<CR>", a:commit)

    syn region Keyword    start="\%1c"  end="\%57c" contains=@NoSpell
    syn region Identifier start="\%57c" end="\%64c"
    syn region String     start="\%64c" end="\%71c"
    syn region Keyword    start="\%71c" end="$"
    syn match Comment "^COMMIT SUMMARY.*" contains=@NoSpell
endfunction

function! GitFetch(remote)
    let l:cmd = printf('git fetch %s', a:remote)
    call GitCommand('FETCH', l:cmd)
    unlet l:cmd
endfunction

function! GitList()
    let l:title = 'GIT LOG'
    if bufexists(l:title)
        let l:bufnr = bufnr(l:title)
        exe printf("%dbd!", l:bufnr)
    endif

    tabnew l:title
    let l:bufnr = bufadd(l:title)
    unlet l:title

    call bufload(l:bufnr)
    exe printf("%db", l:bufnr)
    unlet l:bufnr

    setlocal buflisted
    setlocal buftype=nofile

    let l:branch = s:Chomp(system('git rev-parse --abbrev-ref HEAD'))

    call s:WriteLine(printf('HISTORY %s', l:branch))
    call s:WriteLine(repeat('-', 95))
    call s:WriteExecute('git log -n75 --pretty=format:\%h\ \ \%\<\(73\)\%s\%an')

    call s:WriteLine('')
    call s:WriteLine('BRANCHES')
    call s:WriteLine(repeat('-', 95))
    call s:WriteExecute('git branch -lrav --no-color')

    normal gg

    nnoremap <silent><buffer><F4> :call GitDiffSummary(expand('<cword>'))<CR>

    syn keyword Statement x86 x64 containedin=String,Comment
    syn keyword Statement boron carbon dublin
    syn keyword Statement ede containedin=String,Comment
    syn keyword Statement havana herne hobart containedin=String,Comment
    syn keyword Statement master freetown ibaraki containedin=String,Comment
    syn match Comment "\d\{5}" containedin=String,Comment
    syn match Statement "\d\.\d" containedin=String,Comment
    syn match Statement "\d\.\d\.\d" containedin=String,Comment
    syn match Statement "\d\.\d\.\d\.\d" containedin=String,Comment
    syn region String start="\s\s" end="$"
    syn match Keyword "[0-9a-f]\{7,8}" containedin=String,Comment contains=@NoSpell
    syn region Comment start="remotes/" end="\s" containedin=String
endfunction

function! GitPrune(remote)
    call GitCommand('PRUNE', printf('git remote prune %s', a:remote))
endfunction

function! GitListBranches()
    call GitCommand('BRANCHES', 'git branch -lra')
endfunction

function! GitStatus()
    call GitCommand('STATUS', 'git status')
    setf gitmisc
endfunction

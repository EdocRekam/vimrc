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
    call GitCommand(a:file, l:cmd)
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

    syn region Keyword start="\%1c" end="\%42c" contains=@NoSpell
    syn region Identifier start="\%42c" end="\%49c" contains=@NoSpell
    syn region String start="\%49c" end="\%56c"
    syn region Keyword start="\%56c" end="$"
    syn match Comment "^COMMIT SUMMARY.*" contains=@NoSpell

    call append(0, printf('COMMIT SUMMARY %s', a:commit))
    call append(line("$"), 'FILE')
    call append(line("$"), '------------------------------------------------------------')

    let l:cmd = printf('git diff --name-only HEAD..%s', a:commit)
    let l:files = systemlist(l:cmd)
    for l:file in l:files
        call append(line("$"), printf('%-40s OLD    NEW    DIFF', l:file))
    endfor

    normal gg
    unlet l:bufnr

    nnoremap <silent><buffer><F4> :call GitShowFile('bb309c7', 'cs.vim')<CR>
endfunction

function! GitList()
    let l:cmd = 'git log -n75 --pretty=format:\%h\ \ \%\<\(73\)\%s\%an'
    call GitCommand('GIT LOG', l:cmd)
    nnoremap <silent><buffer><F4> :call GitDiffSummary(expand('<cword>'))<CR>
    syn region Keyword start="\%1c" end="\%8c" contains=@NoSpell
    syn region String start="\%10c" end="\%80c"
    syn region Identifier start="\%81c" end="$"
    unlet l:cmd
endfunction

function! GitStatus()
    call GitCommand('STATUS', 'git status')
    setf gitmisc
endfunction

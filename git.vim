function! GitCommand(title, cmd)
    if bufexists(a:title)
        let l:bufnr = bufnr(a:title)
        exe printf("%dbd!", l:bufnr)
    endif

    tabnew l:title
    let l:bufnr = bufadd(a:title)
    call bufload(l:bufnr)
    exe printf("%db", l:bufnr)
    setlocal buflisted
    setlocal buftype=nofile
    silent exe printf("0r !%s", a:cmd)
    normal gg
    unlet l:bufnr
endfunction

function! GitList()
    let l:cmd = 'git log -n75 --pretty=format:\%h\ \ \%\<\(73\)\%s\%an'
    call GitCommand('GIT LOG', l:cmd)
    syn region Keyword start="\%1c" end="\%8c"
    syn region String start="\%10c" end="\%80c"
    syn region Identifier start="\%81c" end="$"
    unlet l:cmd
endfunction

function! GitStatus()
    call GitCommand('STATUS', 'git status')
    setf gitmisc
endfunction

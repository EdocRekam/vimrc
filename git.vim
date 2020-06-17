function! GitList()
    let l:title = 'GIT LOG'
    let l:cmd = 'git log -n75 --pretty=format:\%h\ \ \%\<\(73\)\%s\%an'

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
    setf gitrebase
    silent exe printf("0r !%s", l:cmd)
    normal gg

    unlet l:bufnr
    unlet l:cmd
    unlet l:title
endfunction


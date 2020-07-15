    elseif id == 2
        s:dotnet_build()
    elseif id == 3
        s:dotnet_restore()
    elseif id == 12
        s:hell_tab('GIT' ['git add .'])
    elseif id == 13
        exe 'Gcommit'
    elseif id == 14
        s:hell_tab('GIT', ['git diff'])
    elseif id == 15
        ask = input('Remote: ', 'vso')
        s:git_fetch(ask)
    elseif id == 18
        exe 'silent !git gui&'
    elseif id == 20
        ask = input('Remote: ', 'vso')
        s:git_prune(ask)
    elseif id == 21
        s:csharp_use()
    elseif id == 28
        GotoDefinition()
    elseif id == 29
        s:dotnet_test()
    elseif id == 30
        s:dotnet_test(expand('<cword>'))
    elseif id == 31
        " TEST THIS FILE
    elseif id == 38
        s:csharp_startserver()
    elseif id == 39
        s:csharp_fold()
    elseif id == 40
        s:csharp_nofold()
    elseif id == 43
        s:git_log_file(expand('<cfile>'))
    elseif id == 44
        s:git_checkout(expand('<cfile>:t'))
    endif


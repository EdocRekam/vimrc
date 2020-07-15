    elseif id == 2
        s:dotnet_build()
    elseif id == 3
        s:dotnet_restore()
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
    endif


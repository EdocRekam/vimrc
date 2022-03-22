def GotoDef()
    # CFILE
    var f = T1()
    if filereadable(f)
        exe 'tabnew ' .. f
    else
        # FIND WORD IN FILES
        T11(T9())
    endif
    # else
    # OmniSharpGotoDefinition()
enddef
T0('F4', 'GotoDef')


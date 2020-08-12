def GotoDef()
    # CFILE
    let f = T1()
    if filereadable(f)
        exe 'tabnew ' .. f
    el
        # FIND WORD IN FILES
        T11(T9())
    en
    # else
    # OmniSharpGotoDefinition()
enddef
T0('F4', 'GotoDef')


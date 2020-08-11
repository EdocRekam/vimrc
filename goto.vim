def GotoDef()
    let pat = T1()
    if filereadable(pat)
        exe 'e! %s' .. pat
    en
    # else
    # OmniSharpGotoDefinition()
enddef
T0('F4', 'GotoDef')


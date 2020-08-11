def GotoDef()
    let pat = T1()
    if filereadable(pat)
        exe 'e! %s' .. pat
    en
    # else
    # OmniSharpGotoDefinition()
enddef
nn <silent><F4> :cal GotoDef()<CR>


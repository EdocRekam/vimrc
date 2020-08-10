def GotoDef()
    let pat = Cfile()
    if filereadable(pat)
        exe 'e! %s' .. pat
    en
    # else
    # OmniSharpGotoDefinition()
enddef
nn <silent><F4> :cal GotoDef()<CR>


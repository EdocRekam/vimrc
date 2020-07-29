def GotoDef()
    let pat = expand("<cfile>")
    if filereadable(pat)
        exe 'e! %s' .. pat
    en
    # else
    # OmniSharpGotoDefinition()
enddef
nnoremap <silent><F4> :cal GotoDef()<CR>


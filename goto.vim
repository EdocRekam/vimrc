def! GotoDef()
    let pat = expand("<cfile>")
    if filereadable(pat)
        exe 'e! %s' .. pat
    endif
    # else
    # OmniSharpGotoDefinition()
enddef
nnoremap <silent><F4> :call GotoDef()<CR>


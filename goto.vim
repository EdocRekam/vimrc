def! GotoDef()
    let path = expand("<cfile>")
    if filereadable(path)
        exe 'e! %s' .. path
    endif
    # else
    # OmniSharpGotoDefinition()
enddef
nnoremap <silent><F4> :call GotoDef()<CR>


def! GotoDefinition(): void
    let path = expand("<cfile>")
    if filereadable(path)
        sil exe printf('e! %s', path)
    endif
    # else
    # OmniSharpGotoDefinition()
enddef

" GOTO FILE > DEFINITION                                F4
nnoremap <silent><F4> :call GotoDefinition()<CR>


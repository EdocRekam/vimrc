def g:Trace(msg = '')
    var h = 0
    if !bufexists('TRACE')
        h = bufadd('TRACE')
        bufload(h)
        T3(h)
    else
        h = bufnr('TRACE')
    endif

    appendbufline(h, get(getbufinfo(h), 0).linecount - 1, msg)
enddef

def g:OpenTrace()
    if bufexists('TRACE')
        var h = bufnr('TRACE')
        if 0 == win_gotoid(h)
            tabnew
            exe 'b' .. h
        endif
    endif
enddef


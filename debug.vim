def g:Trace(msg = '')
    let h = 0
    if !bufexists('TRACE')
        h = bufadd('TRACE')
        bufload(h)
        T3(h)
    el
        h = bufnr('TRACE')
    en

    appendbufline(h, get(getbufinfo(h), 0).linecount - 1, msg)
enddef

def g:OpenTrace()
    if bufexists('TRACE')
        let h = bufnr('TRACE')
        if 0 == win_gotoid(h)
            tabnew
            exe 'b' .. h
        en
    en
enddef


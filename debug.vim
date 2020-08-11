def g:Trace(msg: string)
    let h: number
    if !bufexists('TRACE')
        h = bufadd('TRACE')
        bufload(h)
        T3(h)
    else
        h = bufnr('TRACE')
    en

    let inf = getbufinfo(h)
    let lnr = inf[0].linecount
    appendbufline(h, lnr - 1, msg)
enddef

def g:OpenTrace()
    if bufexists('TRACE')
        let h = bufnr('TRACE')
        if 0 == win_gotoid(h)
            :tabnew
            exe 'b' .. h
        en
    en
enddef


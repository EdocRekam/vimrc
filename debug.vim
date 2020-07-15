def! g:Trace(msg: string)
    let h: number
    if !bufexists('TRACE')
        h = bufadd('TRACE')
        bufload(h)
        setbufvar(h, '&buftype', 'nofile')
        setbufvar(h, '&swapfile', '0')
    else
        h = bufnr('TRACE')
    endif

    let inf = getbufinfo(h)
    let lnr = inf[0].linecount
    if lnr > 1
        appendbufline(h, lnr - 1, msg)
    else
        appendbufline(h, 1, '')
        setbufline(h, 1, msg)
    endif
enddef

def! g:OpenTrace()
    if bufexists('TRACE')
        let h = bufnr('TRACE')
        if 0 == win_gotoid(h)
            :tabnew
            exe 'b' .. h
        endif
    endif
enddef


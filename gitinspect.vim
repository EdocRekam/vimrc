def! GInsRefresh(hT: number, hB: number, obj: string)
    let now = reltime()
    deletebufline(hT, 1, '$')

    let f =  'FILES %-84s %-8s  %-8s  %-8s  %-14s %s'
    let hdr = printf(f, obj, 'BEFORE', 'AFTER', 'HEAD', 'COMPARE', 'SIDE BY SIDE')
    let hl = 160
    let sep = repeat('-', hl)

    let l = [hdr, sep]
    extend(l, [
    '', '', 'Time:' .. reltimestr(reltime(now, reltime()))])
    Say(hT, l)

    # POSITION
    let winid = win_getid(1)
    win_execute(winid, '3')
enddef

def! GitInspect(obj: string)
    GHead()

    # TOP ----------------------------------------------------------------
    let tT = 'I:' .. obj
    let hT = bufadd(tT)
    bufload(hT)

    # BOTTOM -------------------------------------------------------------
    let tB = tT .. ' - Messages'
    let hB = bufadd(tB)
    bufload(hB)
    Say(hB, 'Ready...')

    # TAB ----------------------------------------------------------------
    exe 'tabnew ' .. tB
    settabvar(tabpagenr(), 'title', tT)

    exe 'split ' .. tT
    exe '2resize 20'
    GInsRefresh(hT, hB, obj)

    # OPTIONS
    GHide(hT)
    GHide(hB)

    # SYNTAX
    setbufvar(hT, '&colorcolumn', '')
    setbufvar(hB, '&colorcolumn', '')
    GitColors()

    # LOCAL KEY BINDS
    let cmd = 'nnoremap <silent><buffer>'
    exe printf('%s<F3> :cal <SID>GQuit(%d, %d)<CR>', cmd, hT, hB)
    exe printf("%s<F6> :cal <SID>GInsRefresh(%d, %d, '%s')<CR>", cmd, hT, hB, obj)
enddef
nnoremap <silent><F6> :cal <SID>GitInspect('nothing')<CR>

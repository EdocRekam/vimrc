
def! GShowExit(h: number, chan: number, code: number)
    let winid = get(win_findbuf(h), 0)
    win_gotoid(winid)
    win_execute(winid, 'norm gg')
enddef

def! GShow(h: number, obj: string, pat: string)
    let f = funcref("s:SayCallback", [h])
    let e = funcref("s:GShowExit", [h])
    job_start('git show ' .. obj .. ':' .. pat,  #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def! GitShow(obj: string, pat: string, title: string = ''): number
    let t = '' == title ? obj .. ':' .. pat : title

    let h = bufadd(t)
    bufload(h)
    GShow(h, obj, pat)

    exe 'tabnew ' .. t
    settabvar(tabpagenr(), 'title', t)
    Hide(h)

    # LOCAL KEY BINDS
    let cmd = 'nnoremap <silent><buffer>'
    exe printf("%s<F3> :exe 'sil bw! %d'<CR> ", cmd, h)

    retu h
enddef

def! GitShow2(objL: string, patL: string, objR: string, patR: string)
    let tL = objL .. ':' .. patL
    let hL = bufadd(tL)
    bufload(hL)

    let tR = objR .. ':' .. patR
    let hR = bufadd(tR)
    bufload(hR)

    exe 'tabnew ' .. tR
    settabvar(tabpagenr(), 'title', objL .. '-' .. objR)
    exe 'vsplit ' .. tL

    GShow(hR, objR, patR)
    Hide(hR)

    GShow(hL, objL, patL)
    Hide(hL)

    # LOCAL KEY BINDS
    let cmd = 'nnoremap <silent><buffer>'
    exe printf("%s<F3> :exe 'sil bw! %d %d'<CR> ", cmd, hL, hR)
enddef

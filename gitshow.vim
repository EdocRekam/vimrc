
def GShowExit(h: number, j: job, code: number)
    let id = get(win_findbuf(h), 0)
    win_gotoid(id)
    win_execute(id, 'norm gg')
enddef

def GShow(h: number, obj: string, pat: string)
    let f = funcref(SayCb, [h])
    let e = funcref(GShowExit, [h])
    job_start('git show ' .. obj .. ':' .. pat,  #{out_cb: f, err_cb: f, exit_cb: e})
enddef

def GitShow(obj: string, pat: string, title: string = ''): number
    let t = '' == title ? obj .. ':' .. pat : title

    exe 'tabnew ' .. obj .. ':' .. pat
    let h = bufnr()
    T3(h)
    GShow(h, obj, pat)
    settabvar(tabpagenr(), 'title', t)

    # LOCAL KEY BINDS
    exe printf("nn <silent><buffer><F3> :exe 'sil bw! %d'<CR> ", h)

    retu h
enddef

def GitShow2(objL: string, patL: string, objR: string, patR: string)
    exe 'tabnew ' .. objR .. ':' .. patR
    let hR = bufnr()
    T3(hR)
    GShow(hR, objR, patR)
    settabvar(tabpagenr(), 'title', objL .. '-' .. objR)

    exe 'vsplit ' .. objL .. ':' .. patL
    let hL = bufnr()
    T3(hL)
    GShow(hL, objL, patL)

    # LOCAL KEY BINDS
    G0(hL, hR)
enddef

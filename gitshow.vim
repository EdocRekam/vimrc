
def GS0(h: number, j: job, c = 0)
    var id = get(win_findbuf(h), 0)
    win_gotoid(id)
    win_execute(id, 'norm gg')
enddef

# GIT SHOW OBJECT:PATH
def GS1(h = 0, o = '', p = '')
    var F = funcref(SayCb, [h])
    var E = funcref(GS0, [h])
    job_start(['git', 'show', o .. ':' .. p],  {out_cb: F, err_cb: F, exit_cb: E})
enddef

# GIT SHOW OBJECT:PATH
def GitShow(o = '', p = '', title = ''): number
    var t = '' == title ? o .. ':' .. p : title

    exe 'tabnew ' .. o .. ':' .. p
    var h = bufnr()
    setbufvar(h, '&buftype', 'nofile')
    setbufvar(h, '&ff', 'unix')
    setbufvar(h, '&swapfile', '0')
    GS1(h, o, p)
    settabvar(tabpagenr(), 'title', t)

    # LOCAL KEY BINDS
    exe printf("nn <silent><buffer><F3> :exe 'sil bw! %d'<CR> ", h)

    retu h
enddef

# TWO GIT SHOWS SIDE BY SIDE
# GIT SHOW LEFT_OBJECT:LEFT_PATH
# GIT SHOW RIGHT_OBJECT:RIGHT_PATH
def GitShow2(oL = '', pL = '', oR = '', pR = '')
    exe 'tabnew ' .. oR .. ':' .. pR
    var hR = bufnr()
    T3(hR)
    GS1(hR, oR, pR)
    settabvar(tabpagenr(), 'title', oL .. '-' .. oR)

    exe 'vsplit ' .. oL .. ':' .. pL
    var hL = bufnr()
    T3(hL)
    GS1(hL, oL, pL)

    # SCROLLBIND WINDOWS TOGETHER
    windo set scb

    # F3 - CLOSE BOTH WINDOWS
    G0(hL, hR)
enddef

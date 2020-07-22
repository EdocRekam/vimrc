def! GInsCols(): list<number>
    let l: list<number> = gettabvar(tabpagenr(), 'lens')
    let c: list<number> = [l[0] + 3,
         l[0] + l[1] + 5,
         l[0] + l[1] + l[2] + 7,
         l[0] + l[1] + l[2] + l[3] + 9]

    add(c, c[3] + 5)
    add(c, c[3] + 10)
    add(c, c[3] + 15)
    add(c, c[3] + 20)
    add(c, c[3] + 25)
    add(c, c[3] + 30)

    retu c
enddef

def! GInsHitTest(): number
    let cs: list<number> = GInsCols()
    let c = col('.')
    let r = 1
    if c < cs[9] && c >= cs[8]
        r = 10
    elsei c < cs[8] && c >= cs[7]
        r = 9
    elsei c < cs[7] && c >= cs[6]
        r = 8
    elsei c < cs[6] && c >= cs[5]
        r = 7
    elsei c < cs[5] && c >= cs[4]
        r = 6
    elsei c < cs[4] && c >= cs[3]
        r = 5
    elsei c < cs[3] && c >= cs[2]
        r = 4
    elsei c < cs[2] && c >= cs[1]
        r = 3
    elsei c < cs[1] && c >= cs[0]
        r = 2
    endif

    retu r
enddef

def! GInsNav(hT: number, hB: number, obj: string)
    let cs = GInsCols()

    let lin = getline('.')
    let pat = trim(strcharpart(lin, 0, cs[0] - 1))
    let bef = trim(strcharpart(lin, cs[0] - 1, cs[1] - cs[0] - 1))
    let aft = trim(strcharpart(lin, cs[1] - 1, cs[2] - cs[1] - 1))
    let hed = trim(strcharpart(lin, cs[2] - 1, cs[3] - cs[2] - 1))

    let c = GInsHitTest()

    # FILE
    if c == 1 && filereadable(pat)
        exe 'tabnew ' .. pat

    # BEFORE
    elsei c == 2
        GitShow(bef, pat)

    # AFTER
    elsei c == 3
        GitShow(aft, pat)

    # HEAD
    elsei c == 4
        GitShow(hed, pat)

    # BEFORE:AFTER
    elsei c == 5 && bef != 'DELETED' && aft != 'DELETED'
        GitShow2(bef, pat, aft, pat)
        :windo diffthis

    # BEFORE:HEAD
    elsei c == 6 && bef != 'DELETED' && hed != 'DELETED'
        GitShow2(bef, pat, hed, pat)
        :windo diffthis

    # AFTER:HEAD
    elsei c == 7 && aft != 'DELETED' && hed != 'DELETED'
        GitShow2(aft, pat, hed, pat)
        :windo diffthis

    # BEFORE-AFTER
    elsei c == 8 && bef != 'DELETED' && aft != 'DELETED'
        GitShow2(bef, pat, aft, pat)

    # BEFORE-HEAD
    elsei c == 9 && bef != 'DELETED' && hed != 'DELETED'
        GitShow2(bef, pat, hed, pat)

    # AFTER-HEAD
    elsei c == 10 && aft != 'DELETED' && hed != 'DELETED'
        GitShow2(aft, pat, hed, pat)

    endif
enddef

def! GInsRefresh(hT: number, hB: number, obj: string)
    let now = reltime()
    deletebufline(hT, 1, '$')

    let rs: list<list<string>>
    for i in systemlist('git diff --numstat ' .. obj .. '~1 ' .. obj)

        # SAMPLE OUTPUT
        # ADD(A)  DEL(B)  PATH(C)
        # 16      111     git.vim
        # 46      54      gitbranch.vim
        # 20      30      gitcommit.vim
        # 83      0       gitinspect.vim
        # 120     0       gitlog.vim
        # 26      36      gitstatus.vim
        # 3       1       install
        # 1       1       menu.vim
        # 5       0       session.vim
        let abc = split(i)
        let a = str2nr(abc[0])
        let b = str2nr(abc[1])
        let c = abc[2]

        let aft = ''
        let bef = ''
        let past = systemlist('git log -n3 --pretty=%h ' .. obj .. ' -- ' .. c)
        if len(past) == 1
            bef = 'ADDED'
            aft = obj
        else
            bef = past[1]
            if b > 1
                aft = obj
            else
                system('git show ' .. obj .. ':' .. c)
                aft = v:shell_error ? 'DELETED' : obj
            endif
        endif
        let head = filereadable(c) ? g:head : 'DELETED'
        add(rs, [c, bef, aft, head])
    endfor

    let lens = [
        Widest(rs, 0, 20),
        Widest(rs, 1, 8),
        Widest(rs, 2, 8),
        Widest(rs, 3, 5),
        13, 13]
    settabvar(tabpagenr(), 'lens', lens)

    let f = '%-' .. lens[0] .. 's  %-' .. lens[1] .. 's  %-' .. lens[2] .. 's  %-' .. lens[3] .. 's  %-' .. lens[4] .. 's  %s'
    let hdr = printf(f, 'FILE', 'BEFORE', 'AFTER', 'HEAD', 'COMPARE', 'SIDE BY SIDE')
    let hl = lens[0] + lens[1] + lens[2] + lens[3] + lens[4] + lens[5] + 10
    let sep = repeat('-', hl)

    let l = [hdr, sep]
    for i in rs
        add(l, printf(f, i[0], i[1], i[2], i[3], 'B:A  B:H  A:H', 'B-A  B-H  A-H'))
    endfor

    extend(l, ['',
    '<F4>  INSPECT',
    '<F6>  GIT GUI    <F7>       GIT LOG (UNDER CURSOR)',
    '                 <SHIFT+F7> GITK (UNDER CURSOR)',
    'CLICK ON FILE TO EDIT',
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
    Hide(hT)
    Hide(hB)

    # SYNTAX
    setbufvar(hT, '&colorcolumn', '')
    setbufvar(hB, '&colorcolumn', '')
    GColor()
    " syn region String start="\%>2l" end="\%90c" contains=@NoSpell oneline

    # LOCAL KEY BINDS
    let cmd = 'nnoremap <silent><buffer>'
    exe printf("%s<2-LeftMouse> :cal <SID>GInsNav(%d, %d, '%s')<CR>", cmd, hT, hB, obj)
    exe printf("%s<F3> :exe 'sil bw! %d %d'<CR> ", cmd, hT, hB)
    exe printf("%s<F6> :cal <SID>GInsRefresh(%d, %d, '%s')<CR>", cmd, hT, hB, obj)
enddef
nnoremap <silent><F6> :cal <SID>GitInspect('392bef0')<CR>

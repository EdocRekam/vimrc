

def! s:callback(winid: number, result: number): number
    if result == -1
        return 1
    endif
    let ask: string
    let path: string
    let id = s:GetCmdId(result)
    if id == 1
        ask = input('Align on: ', '=')
        s:align(ask)
    elseif id == 2
        s:dotnet_build()
    elseif id == 3
        s:dotnet_restore()
    elseif id == 4
        s:lower()
    elseif id == 5
        s:upper()
    elseif id == 6
        s:notabs()
    elseif id == 7
        s:tocrlf()
    elseif id == 8
        s:tolf()
    elseif id == 9
        ask = input('Start: ', '0')
        s:enum(str2nr(ask))
    elseif id == 10
        g:ZoomOut()
    elseif id == 11
        g:ZoomIn()
    elseif id == 12
        s:hell_tab('GIT' ['git add .'])
    elseif id == 13
        exe 'Gcommit'
    elseif id == 14
        s:hell_tab('GIT', ['git diff'])
    elseif id == 15
        ask = input('Remote: ', 'vso')
        s:git_fetch(ask)
    elseif id == 16
        s:git_status()
    elseif id == 17
        exe 'silent !gitk&'
    elseif id == 18
        exe 'silent !git gui&'
    elseif id == 19
        s:git_log()
    elseif id == 20
        ask = input('Remote: ', 'vso')
        s:git_prune(ask)
    elseif id == 21
        s:csharp_use()
    elseif id == 22
        s:unique()
    elseif id == 23
        s:notrails()
    elseif id == 24
        s:ort()
    elseif id == 25
        s:orti()
    elseif id == 26
        s:sortd()
    elseif id == 27
        s:sortdi()
    elseif id == 28
        GotoDefinition()
    elseif id == 29
        s:dotnet_test()
    elseif id == 30
        s:dotnet_test(expand('<cword>'))
    elseif id == 31
        " TEST THIS FILE
    elseif id == 32
        so $VIMRUNTIME/syntax/hitest.vim
    elseif id == 33
        tabclose
    elseif id == 34
        tabnew
    elseif id == 35
        path = printf('%s/syntax/%s.vim', $VIMRUNTIME, &filetype)
        if filereadable(path)
            sil exe 'tabnew ' .. path
        endif
    elseif id == 36
        silent exe 'options'
    elseif id == 37
        silent exe 'set guifont=*'
    elseif id == 38
        s:csharp_startserver()
    elseif id == 39
        s:csharp_fold()
    elseif id == 40
        s:csharp_nofold()
    elseif id == 41
        path = printf('%skeys.html', s:vim_dir())
        if filereadable(path)
            sil exe printf("!firefox --new-window '%s'&", path)
        endif
    elseif id == 42
        setl wrap!
    elseif id == 43
        s:git_log_file(expand('<cfile>'))
    elseif id == 44
        s:git_checkout(expand('<cfile>:t'))
    elseif id == 45
        s:git_branch()
    endif
    return 1
enddef

def! s:filter(winid: number, key: string): number

    if key == "\<F1>"
        popup_close(winid, -1)
        return 1
    endif

    " PASS
    if key == "\<F2>" || key == "\<F3>" || key == "\<F4>"
      \ || key == "\<F5>" || key == "\<F6>" || key == "\<F7>"
      \ || key == "\<F8>" || key == "\<F9>" || key == "\<F10>"
      \ || key == "\<F11>" || key == "\<F12>"
        popup_close(winid, -1)
        feedkeys(key)
        return 1
    endif

    " PRINTABLE CHAR
    if 0 == match(key, '\p')
       " IGNORE THESE
        if key == ':'
            return popup_filter_menu(winid, key)
        endif

        " ACCUMULATE
        popup_close(winid, -1)
        s:opts.title = s:opts.title .. key
        s:FilterBuffer(s:menuId[1])
        s:accum += 1
        s:wid = popup_create(s:menuId[1], s:opts)
        return 1
    endif

    " NONPRINTABLE
    if key == "\<BS>"
        " NOTHING TO DO
        if s:accum < 1
            popup_close(winid, -1)
            return 1
        endif

        " REGRESS
        popup_close(winid, -1)
        s:RestoreBuffer()
        s:opts.title = s:chomp(s:opts.title)
        s:FilterBuffer(s:menuId[1])
        s:accum -= 1
        s:wid = popup_create(s:menuId[1], s:opts)
    else
        return popup_filter_menu(winid, key)
    endif

    return 1
enddef

def! s:mnu_init()
    s:accum = -1
    s:menuId  = []
    s:wid = -1
    s:opts = #{
        callback: s:callback,
        cursorline: 1,
        filter: s:filter,
        filtermode: 'a',
        line: 2,
        mapping: 0,
        maxheight: 25,
        maxwidth: 36,
        padding: [1, 1, 0, 1],
        title: '',
        wrap: 0,
    }
enddef
call s:mnu_init()

def! s:FilterBuffer(buf: number): void
    let t = tolower(s:opts.title)
    let idx = 1
    for i in getbufline(buf, 0, '$')
        if stridx(tolower(i), t) != -1
            idx += 1
        else
            deletebufline(buf, idx)
        endif
    endfor
enddef

def! s:GetCmdId(result: number): number
    let l = getbufline(s:menuId[1], result)[0]
    let nr = strcharpart(l, 39, 4)
    return str2nr(nr)
enddef

def! s:RestoreBuffer()
    let items = getbufline(s:menuId[0], 0, '$')
    deletebufline(s:menuId[1], 1, '$')
    appendbufline(s:menuId[1], 0, items)
    deletebufline(s:menuId[1], '$')
enddef

" THE ONE AND ONLY WAY INTO MENU
def! s:menu()
    if s:accum == -1
        s:accum = 0
        add(s:menuId, bufadd(printf('%smenu.txt', s:vim_dir())))
        add(s:menuId, bufadd('ea9b0bea-e515-40ed-b1a0-f58281ff9629'))

        bufload(s:menuId[0])
        setbufvar(s:menuId[0], '&buftype', 'nofile')
        setbufvar(s:menuId[0], '&swapfile', '0')

        bufload(s:menuId[1])
        setbufvar(s:menuId[1], '&buftype', 'nofile')
        setbufvar(s:menuId[1], '&swapfile', '0')
    endif

    if s:wid == -1
        s:RestoreBuffer()
        s:wid = popup_create(s:menuId[1], s:opts)
    endif
enddef

" LIST FUNCTIONS                                        F1
nnoremap <silent><F1> :call <SID>menu()<CR>
vnoremap <silent><F1> :call <SID>menu()<CR>




function! s:Callback(winid, result)
    if a:winid == s:wid
        unlet s:wid
    endif

    if a:result == -1
        return 1
    endif

    let l:id = s:GetCmdId(a:result)
    if l:id == 1
        let l:ask = input('Align on: ', '=')
        call s:AlignOn(l:ask)
    elseif l:id == 2
        call s:DotnetBuild()
    elseif l:id == 3
        call s:DotnetRestore()
    elseif l:id == 4
        call s:Lowercase()
    elseif l:id == 5
        call s:Uppercase()
    elseif l:id == 6
        call ExpandTabs()
    elseif l:id == 7
        call Unix2Dos()
    elseif l:id == 8
        call Dos2Unix()
    elseif l:id == 9
        let l:ask = input('Start: ', '0')
        call s:Enumerate(str2nr(l:ask))
    elseif l:id == 10
        call ZoomOut()
    elseif l:id == 11
        call ZoomIn()
    elseif l:id == 12
        execute 'silent !git add .&'
    elseif l:id == 13
        execute 'silent !git commit&'
    elseif l:id == 14
        execute 'silent !git diff&'
    elseif l:id == 15
        let l:ask = input('Remote: ', 'vso')
        call s:git_fetch(l:ask)
    elseif l:id == 16
        call s:git_status()
    elseif l:id == 17
        execute 'silent !gitk&'
    elseif l:id == 18
        execute 'silent !git gui&'
    elseif l:id == 19
        call s:git_log()
    elseif l:id == 20
        let l:ask = input('Remote: ', 'vso')
        call s:git_prune(l:ask)
    elseif l:id == 21
        call SwitchToCsharp()
    elseif l:id == 22
        call s:RemoveDuplicates()
    elseif l:id == 23
        call RemoveTrailingWhitespace()
    elseif l:id == 24
        call s:Sort()
    elseif l:id == 25
        call s:SortI()
    elseif l:id == 26
        call s:SortD()
    elseif l:id == 27
        call s:SortDI()
    elseif l:id == 28
        call GotoDefinition()
    elseif l:id == 29
        call s:dotnet_test()
    elseif l:id == 30
        call s:dotnet_test(expand('<cword>'))
    elseif l:id == 31
        " TEST THIS FILE
    elseif l:id == 32
        so $VIMRUNTIME/syntax/hitest.vim
    elseif l:id == 33
        tabclose
    elseif l:id == 34
        tabnew
    elseif l:id == 35
        let l:path = printf('%s/syntax/%s.vim', $VIMRUNTIME, &filetype)
        if filereadable(l:path)
            silent exe printf("tabnew %s", l:path)
        endif
    elseif l:id == 36
        silent exe 'options'
    elseif l:id == 37
        silent exe 'set guifont=*'
    elseif l:id == 38
        call s:csharp_startserver()
    elseif l:id == 39
        call s:csharp_fold()
    elseif l:id == 40
        call s:csharp_nofold()
    elseif l:id == 41
        let l:path = printf('%skeys.html', s:VimDir())
        if filereadable(l:path)
            silent exe printf("!firefox --new-window '%s'&", l:path)
        endif
    elseif l:id == 42
        exe 'setlocal wrap!'
    endif

    return 1
endfunction

function! s:Filter(winid, key)

    " PRINTABLE CHAR
    if 0 == match(a:key, '\p')
            " IGNORE THESE
            if a:key == ':'
                return popup_filter_menu(a:winid, a:key)
            endif

            " ACCUMULATE
            call popup_close(a:winid, -1)
            let s:opts.title = s:opts.title . a:key
            call s:FilterBuffer(s:menuId[1])
            let s:accum +=1
            let s:wid = popup_create(s:menuId[1], s:opts)

    " NONPRINTABLE
    else
        if a:key == "\<BS>"
            " NOTHING TO DO
            if s:accum < 1
                call popup_close(a:winid, -1)
                return 1
            endif

            " REGRESS
            call popup_close(a:winid, -1)
            call s:RestoreBuffer()
            let s:opts.title = s:Chomp(s:opts.title)
            call s:FilterBuffer(s:menuId[1])
            let s:accum -=1
            let s:wid = popup_create(s:menuId[1], s:opts)
        else
            return popup_filter_menu(a:winid, a:key)
        endif
    endif

    return 1
endfunction

function! s:FilterBuffer(buf)
    let l:t = tolower(s:opts.title)
    let l:idx = 1
    for l:i in getbufline(a:buf, 0, '$')
        if stridx(tolower(l:i), l:t) != -1
            let l:idx +=1
        else
            call deletebufline(a:buf, l:idx)
        endif
    endfor
endfunction

function! s:GetCmdId(result)
    let l:l = getbufline(s:menuId[1], a:result)[0]
    let l:nr = strcharpart(l:l, 39, 4)
    return str2nr(l:nr)
endfunction

function! s:RestoreBuffer()
    if !exists('s:menuId')
        let s:menuId = [bufadd(printf('%smenu.txt', s:VimDir()))
                     \ ,bufadd('ea9b0bea-e515-40ed-b1a0-f58281ff9629')]

        silent call bufload(s:menuId[0])
        silent call setbufvar(s:menuId[0], '&buftype', 'nofile')
        silent call setbufvar(s:menuId[0], '&swapfile', '0')

        silent call bufload(s:menuId[1])
        silent call setbufvar(s:menuId[1], '&buftype', 'nofile')
        silent call setbufvar(s:menuId[1], '&swapfile', '0')
    endif

    let l:items = getbufline(s:menuId[0], 0, '$')
    silent call deletebufline(s:menuId[1], 1, '$')
    silent call appendbufline(s:menuId[1], 0, l:items)
    silent call deletebufline(s:menuId[1], '$')
endfunction

" THE ONE AND ONLY WAY INTO MENU
function! ListFunctions()
    if !exists('s:accum')
        let s:accum = 0
        call s:RestoreBuffer()
    endif
    if !exists('s:wid')
        let s:wid = popup_create(s:menuId[1], s:opts)
    endif
endfunction

let s:opts = {
    \  'callback'   : function('s:Callback')
    \, 'cursorline' : 1
    \, 'filter'     : function('s:Filter')
    \, 'filtermode' : 'a'
    \, 'line'       : 2
    \, 'mapping'    : 0
    \, 'maxheight'  : 25
    \, 'maxwidth'   : 36
    \, 'padding'    : [1, 1, 0, 1]
    \, 'title'      : ''
    \, 'wrap'       : 0}

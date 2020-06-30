

function! s:AlignOn(criteria)
    let l:colAlign = 0
    for l:line in getline(line("'<"), line("'>"))
        let l:col = stridx(l:line, a:criteria)
        if l:col > l:colAlign
            let l:colAlign = l:col + 1
        endif
    endfor

    let l:nr = line("'<")
    let l:cnt = 0
    for l:line in getline(line("'<"), line("'>"))
        let l:col = stridx(l:line, a:criteria)
        let l:diff = l:colAlign - l:col
        let l:fmt = '%s%' . printf('%d', l:diff) . 's%s'
        let l:front = strcharpart(l:line, 0, l:col)
        let l:back = strcharpart(l:line, l:col, strlen(l:line))
        let l:line = printf(l:fmt, l:front, ' ', l:back)
        call setline(l:nr, l:line)
        let l:nr = l:nr + 1
        let l:cnt = l:cnt + 1
    endfor
    normal gv
endfunction

function! s:Enumerate(start)
    let l:nr = line("'<")
    let l:cnt = a:start
    for l:line in getline(line("'<"), line("'>"))
        let l:line = printf('%04d %s', l:cnt, l:line)
        call setline(l:nr, l:line)
        let l:nr = l:nr + 1
        let l:cnt = l:cnt + 1
    endfor
    normal gv
endfunction

function! s:RemoveDuplicates()
    '<,'>%!uniq
    normal gv
endfunction

function! s:SortD()
    '<,'>sort!
    normal gv
endfunction

function! s:SortDI()
    '<,'>sort! i
    normal gv
endfunction

function! s:Sort()
    '<,'>sort
    normal gv
endfunction

function! s:SortI()
    '<,'>sort i
    normal gv
endfunction

function! s:Lowercase()
    normal gvu
    normal gv
endfunction

function! s:Uppercase()
    normal gvU
    normal gv
endfunction

function! s:Callback(winid, result)
    if a:result == -1
        return 1
    endif

    let l:cmd = s:GetCommandId(a:result)
    if l:cmd == 1
        let l:criteria = input('Align on: ', '=')
        call s:AlignOn(l:criteria)
    elseif l:cmd == 2
        " BUILD
    elseif l:cmd == 3
        " RESTORE
    elseif l:cmd == 4
        call s:Lowercase()
    elseif l:cmd == 5
        call s:Uppercase()
    elseif l:cmd == 6
        call ExpandTabs()
    elseif l:cmd == 7
        call Unix2Dos()
    elseif l:cmd == 8
        call Dos2Unix()
    elseif l:cmd == 9
        let l:criteria = input('Start: ', '0')
        call s:Enumerate(str2nr(l:criteria))
    elseif l:cmd == 10
        call ZoomOut()
    elseif l:cmd == 11
        call ZoomIn()
    elseif l:cmd == 12
        " GIT - ADD ALL
        execute 'silent !git add .&'
    elseif l:cmd == 13
        execute 'silent !git commit&'
    elseif l:cmd == 14
        execute 'silent !git diff&'
    elseif l:cmd == 15
        let l:criteria = input('Remote: ', 'vso')
        call GitFetch(l:criteria)
    elseif l:cmd == 16
        call GitStatus()
    elseif l:cmd == 17
        execute 'silent !gitk&'
    elseif l:cmd == 18
        execute 'silent !git gui&'
    elseif l:cmd == 19
        call GitList()
    elseif l:cmd == 20
        let l:criteria = input('Remote: ', 'vso')
        call GitPrune(l:criteria)
    elseif l:cmd == 21
        call SwitchToCsharp()
    elseif l:cmd == 22
        call s:RemoveDuplicates()
    elseif l:cmd == 23
        call RemoveTrailingWhitespace()
    elseif l:cmd == 24
        call s:Sort()
    elseif l:cmd == 25
        call s:SortI()
    elseif l:cmd == 26
        call s:SortD()
    elseif l:cmd == 27
        call s:SortDI()
    elseif l:cmd == 28
        call GotoDefinition()
    elseif l:cmd == 29
        " TEST ALL
    elseif l:cmd == 30
        " TEST THIS
    elseif l:cmd == 31
        " TEST THIS FILE
    elseif l:cmd == 32
        so $VIMRUNTIME/syntax/hitest.vim
    elseif l:cmd == 33
        tabclose
    elseif l:cmd == 24
        tabnew
    endif
    unlet s:wid
    return 1
endfunction

function! s:GetCommandId(result)
    let l:line = getbufline(s:menuId[1], a:result)[0]
    let l:txtId = strcharpart(l:line, 39, 4)
    let l:cmdId = str2nr(l:txtId)
    return l:cmdId
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
            call s:FilterActiveMenuBuffer(a:key, s:menuId[1], s:accum)
            let s:opts.title = s:opts.title . a:key
            let s:accum = s:accum +1
            call popup_atcursor(s:menuId[1], s:opts)

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
            call s:RestoreActiveMenuBuffer()
            let s:opts.title = s:Chomp(s:opts.title)
            let s:accum = s:accum -1
            let l:i = 0
            while l:i < s:accum
                call s:FilterActiveMenuBuffer(s:opts.title[l:i], s:menuId[1], l:i)
                let l:i = l:i +1
            endwhile
            call popup_atcursor(s:menuId[1], s:opts)
        else
            return popup_filter_menu(a:winid, a:key)
        endif
    endif

    return 1
endfunction

function! s:FilterActiveMenuBuffer(key, buf, pos)
    let l:x = tolower(a:key)
    let l:items = getbufline(a:buf, 0, '$')
    let l:index = 1
    for l:item in l:items
        let l:y = tolower(l:item[a:pos])
        if l:x == l:y
            let l:index = l:index +1
        else
            call deletebufline(a:buf, l:index)
        endif
    endfor
endfunction

function! s:RestoreActiveMenuBuffer()
    if !exists('s:menuId')
        let s:menuId = [bufadd(printf('%s/.vim/popup.txt', $HOME))
                     \ ,bufadd('ea9b0bea-e515-40ed-b1a0-f58281ff9629')]

        silent call bufload(s:menuId[0])
        silent call setbufvar(s:menuId[0], '&buftype', 'nofile')
        silent call setbufvar(s:menuId[0], '&swapfile', '0')

        silent call bufload(s:menuId[1])
        silent call setbufvar(s:menuId[1], '&buftype', 'nofile')
        silent call setbufvar(s:menuId[1], '&swapfile', '0')
    endif

    let l:items = getbufline(s:menuId[0], 0, '$')
    call deletebufline(s:menuId[1], 1, '$')
    call appendbufline(s:menuId[1], 0, l:items)
    call deletebufline(s:menuId[1], '$')
endfunction

function! ListFunctions()
    if !exists('s:accum')
        let s:accum = 0
        call s:RestoreActiveMenuBuffer()
    endif

    if !exists('s:wid')
        let s:wid = popup_atcursor(s:menuId[1], s:opts)
    endif
endfunction

"-------------------------------------------------------------------------
"     SOURCE CODE
"-------------------------------------------------------------------------
let s:opts = {
    \  'border'     : [1,0,0,0]
    \, 'borderchars': ['-']
    \, 'callback'   : function('s:Callback')
    \, 'cursorline' : 1
    \, 'filter'     : function('s:Filter')
    \, 'filtermode' : 'a'
    \, 'mapping'    : 0
    \, 'maxheight'  : 20
    \, 'maxwidth'   : 30
    \, 'padding'    : [1, 1, 0, 1]
    \, 'title'      : ''
    \, 'wrap'       : 0}


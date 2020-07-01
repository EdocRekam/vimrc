

function! s:Callback(winid, result)
    if a:winid == s:wid
        unlet s:wid
    endif

    if a:result == -1
        return 1
    endif

    let l:cmd = s:GetCommandId(a:result)
    if l:cmd == 1
        let l:criteria = input('Align on: ', '=')
        call s:AlignOn(l:criteria)
    elseif l:cmd == 2
        call s:DotnetBuild()
    elseif l:cmd == 3
        call s:DotnetRestore()
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
        call s:DotnetTest()
    elseif l:cmd == 30
        call s:DotnetTest(expand('<cword>'))
    elseif l:cmd == 31
        " TEST THIS FILE
    elseif l:cmd == 32
        so $VIMRUNTIME/syntax/hitest.vim
    elseif l:cmd == 33
        tabclose
    elseif l:cmd == 24
        tabnew
    endif
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
            call s:RestoreActiveMenuBuffer()
            let s:opts.title = s:Chomp(s:opts.title)
            let s:accum = s:accum -1
            let l:i = 0
            while l:i < s:accum
                call s:FilterActiveMenuBuffer(s:opts.title[l:i], s:menuId[1], l:i)
                let l:i = l:i +1
            endwhile
            let s:wid = popup_create(s:menuId[1], s:opts)
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
    silent call deletebufline(s:menuId[1], 1, '$')
    silent call appendbufline(s:menuId[1], 0, l:items)
    silent call deletebufline(s:menuId[1], '$')
endfunction

" THE ONE AND ONLY WAY INTO MENU
function! ListFunctions()
    if !exists('s:accum')
        let s:accum = 0
        call s:RestoreActiveMenuBuffer()
    endif
    if !exists('s:wid')
        let s:wid = popup_create(s:menuId[1], s:opts)
    endif
endfunction

let s:opts = {
    \  'border'     : [1,0,0,0]
    \, 'borderchars': ['-']
    \, 'callback'   : function('s:Callback')
    \, 'cursorline' : 1
    \, 'filter'     : function('s:Filter')
    \, 'filtermode' : 'a'
    \, 'mapping'    : 0
    \, 'maxheight'  : 20
    \, 'line'       : 2
    \, 'maxwidth'   : 30
    \, 'padding'    : [1, 1, 0, 1]
    \, 'title'      : ''
    \, 'wrap'       : 0}

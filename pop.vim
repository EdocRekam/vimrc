" POPUP WINDOW

function! s:AlignOn()
    echom 'Todo: AlignOn'
endfunction

function! s:Enumerate()
    let l:nr = line("'<")
    let l:cnt = 0
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
    if a:result == -1 || !exists('s:wid') || s:wid != a:winid
        return 1
    endif

    let l:cmd = s:items[a:result-1]
    if 'Align On' == l:cmd
        call s:AlignOn()
    elseif 'Enumerate' == l:cmd
        call s:Enumerate()
    elseif 'Remove Duplicates' == l:cmd
        call s:RemoveDuplicates()
    elseif 'Sort Ascending' == l:cmd
        call s:Sort()
    elseif 'Sort Ascending (Insensitive)' == l:cmd
        call s:SortI()
    elseif 'Sort Descending' == l:cmd
        call s:SortD()
    elseif 'Sort Descending (Insensitive)' == l:cmd
        call s:SortDI()
    elseif 'Lowercase' == l:cmd
        call s:Lowercase()
    elseif 'Uppercase' == l:cmd
        call s:Uppercase()
    endif

    unlet s:wid
    return 1
endfunction

function! s:Filter(winid, key)
    if a:key == "\<ENTER>"
        return popup_filter_menu(a:winid, a:key)
        unlet s:wid
    endif

    if a:key == "\<UP>" || a:key == "\<DOWN>" || a:key == ':'
        return popup_filter_menu(a:winid, a:key)
    endif

    if a:key == "\<ESC>" || a:key == "\<C-SPACE>" || a:key == "\<F1>"
        if s:len > 0
           let s:len = 0
           let s:opts.title = ''
           let s:items = s:Menu()
        endif
        call popup_close(a:winid, -1)
        unlet s:wid
        return 1
    endif

    if a:key == "\<BS>"
        if s:len < 1
            call popup_close(a:winid, -1)
            unlet s:wid
        else
            let s:len = s:len - 1
            if s:len == 0
                let s:opts.title = ''
                let s:items = s:Menu()
            else
                let s:opts.title = strpart(s:opts.title, 0, s:len)
                let s:items = s:Reduce(s:Menu(), s:opts.title, 0)
            endif
            call popup_close(a:winid, -1)
            let s:wid = popup_atcursor(s:items, s:opts)
        endif
        return 1
    endif

    if s:len > 0
        let s:opts.title = s:opts.title . a:key
    else
        let s:opts.title = a:key
    endif

    let s:items = s:Reduce(s:items, a:key, s:len)
    let s:len = s:len + 1

    call popup_close(a:winid, -1)
    let s:wid = popup_atcursor(s:items, s:opts)
    return 1
endfunction

function! ListFunctions()
    if !exists('s:wid')
        let s:wid = popup_atcursor(s:items, s:opts)
    endif
endfunction

function! s:Menu()
    let l:items = [
        \  'Align On'
        \, 'Enumerate'
        \, 'Remove Duplicates'
        \, 'Sort Acsending'
        \, 'Sort Acsending (Insensitive)'
        \, 'Sort Descending'
        \, 'Sort Descending (Insensitive)'
        \, 'Lowercase'
        \, 'Uppercase' ]
    return l:items
endfunction

function! s:Reduce(items, key, len)
    let l:newItems = []
    for i in a:items
        if stridx(tolower(i), tolower(a:key), a:len) == a:len
            call add(l:newItems, i)
        endif
    endfor
    return l:newItems
endfunction

function! DebugMenu()
    unlet s:wid
endfunction

"-------------------------------------------------------------------------
"     SOURCE CODE
"-------------------------------------------------------------------------
let s:len = 0
let s:items = s:Menu()
let s:opts = {
    \  'maxheight'  : 10
    \, 'padding'    : [1, 1, 0, 1]
    \, 'cursorline' : 1
    \, 'callback'   : function('s:Callback')
    \, 'filter'     : function('s:Filter')
    \, 'filtermode' : 'a'
    \, 'title'      : ''
    \, 'wrap'       : 0}

nnoremap <silent><F1> :call ListFunctions()<CR>
vnoremap <silent><F1> :call ListFunctions()<CR>

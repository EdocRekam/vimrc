

let s:CMD_ALIGN       = 'Align On'
let s:CMD_DOS2UNIX    = 'Change Line Endings To Unix'
let s:CMD_ENUM        = 'Enumerate'
let s:CMD_EXPAND_TAB  = 'Convert Indentation To Spaces'
let s:CMD_REMOVE_DUP  = 'Remove Duplicates'
let s:CMD_REMOVE_WS   = 'Remove Trailing Whitespace'
let s:CMD_UNIX2DOS    = 'Change Line Endings To DOS'
let s:CMD_HI_DISP     = 'Show Highlight Colors'

let s:CMD_GIT_ADDALL  = 'Git: Add All'
let s:CMD_GIT_COMMIT  = 'Git: Commit'
let s:CMD_GIT_DIFF    = 'Git: Diff'
let s:CMD_GIT_FETCH   = 'Git: Fetch'
let s:CMD_GIT_GUI     = 'Git: Gui'
let s:CMD_GIT_K       = 'Git: History (Gitk)'
let s:CMD_GIT_LS      = 'Git: History'
let s:CMD_GIT_PRUNE   = 'Git: Prune Remote'
let s:CMD_GIT_STAT    = 'Git: Status'

let s:CMD_LOWER       = 'Lowercase'
let s:CMD_UPPER       = 'Uppercase'

let s:CMD_FONT_UP     = 'Font: Increase Size'
let s:CMD_FONT_DOWN   = 'Font: Decrease Size'

let s:CMD_SORT        = 'Sort: Ascending'
let s:CMD_SORT_D      = 'Sort: Descending'
let s:CMD_SORT_DI     = 'Sort: Descending + Insensitive'
let s:CMD_SORT_I      = 'Sort: Ascending + Insensitive'

let s:CMD_SYM_GOTO    = 'Symbol: Goto Definition'

let s:CMD_TAB_NEW     = 'Tab: New'
let s:CMD_TAB_CLOSE   = 'Tab: Close'

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
    if a:result == -1 || !exists('s:wid') || s:wid != a:winid
        return 1
    endif

    let l:cmd = s:items[a:result-1]
    if s:CMD_ALIGN == l:cmd
        let l:criteria = input('Align on: ', '=')
        call s:AlignOn(l:criteria)
        unlet l:criteria
    elseif s:CMD_DOS2UNIX == l:cmd
        call Dos2Unix()
    elseif s:CMD_UNIX2DOS == l:cmd
        call Unix2Dos()
    elseif s:CMD_ENUM == l:cmd
        let l:criteria = input('Start: ', '0')
        call s:Enumerate(str2nr(l:criteria))
        unlet l:criteria
    elseif s:CMD_EXPAND_TAB == l:cmd
        call ExpandTabs()
    elseif s:CMD_REMOVE_DUP == l:cmd
        call s:RemoveDuplicates()
    elseif s:CMD_REMOVE_WS == l:cmd
        call RemoveTrailingWhitespace()
    elseif s:CMD_SORT == l:cmd
        call s:Sort()
    elseif s:CMD_SORT_I == l:cmd
        call s:SortI()
    elseif s:CMD_SORT_D == l:cmd
        call s:SortD()
    elseif s:CMD_SORT_DI == l:cmd
        call s:SortDI()
    elseif s:CMD_LOWER == l:cmd
        call s:Lowercase()
    elseif s:CMD_UPPER == l:cmd
        call s:Uppercase()
    elseif s:CMD_HI_DISP == l:cmd
        so $VIMRUNTIME/syntax/hitest.vim
    elseif s:CMD_FONT_UP == l:cmd
        call ZoomIn()
    elseif s:CMD_FONT_DOWN == l:cmd
        call ZoomOut()
    elseif s:CMD_TAB_NEW == l:cmd
        tabnew
    elseif s:CMD_TAB_CLOSE == l:cmd
        tabclose
    elseif s:CMD_SYM_GOTO == l:cmd
        call GotoDefinition()
    elseif s:CMD_GIT_ADDALL == l:cmd
        execute 'silent !git add .&'
    elseif s:CMD_GIT_COMMIT == l:cmd
        execute 'silent !git commit&'
    elseif s:CMD_GIT_DIFF == l:cmd
        execute 'silent !git diff&'
    elseif s:CMD_GIT_GUI == l:cmd
        execute 'silent !git gui&'
    elseif s:CMD_GIT_K == l:cmd
        execute 'silent !gitk&'
    elseif s:CMD_GIT_STAT == l:cmd
        call GitStatus()
    elseif s:CMD_GIT_LS == l:cmd
        call GitList()
    elseif s:CMD_GIT_FETCH == l:cmd
        let l:criteria = input('Remote: ', 'vso')
        call GitFetch(l:criteria)
        unlet l:criteria
    elseif s:CMD_GIT_PRUNE == l:cmd
        let l:criteria = input('Remote: ', 'vso')
        call GitPrune(l:criteria)
        unlet l:criteria
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
           let s:opts.title = '> '
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
                let s:opts.title = '> '
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
        \  s:CMD_ALIGN
        \, s:CMD_UNIX2DOS, s:CMD_DOS2UNIX
        \, s:CMD_ENUM
        \, s:CMD_GIT_ADDALL, s:CMD_GIT_COMMIT, s:CMD_GIT_DIFF
        \, s:CMD_GIT_GUI, s:CMD_GIT_FETCH, s:CMD_GIT_LS
        \, s:CMD_GIT_K, s:CMD_GIT_STAT, s:CMD_GIT_PRUNE
        \, s:CMD_EXPAND_TAB
        \, s:CMD_REMOVE_DUP
        \, s:CMD_REMOVE_WS
        \, s:CMD_HI_DISP
        \, s:CMD_SORT, s:CMD_SORT_I, s:CMD_SORT_D, s:CMD_SORT_DI
        \, s:CMD_SYM_GOTO
        \, s:CMD_FONT_UP, s:CMD_FONT_DOWN
        \, s:CMD_TAB_NEW, s:CMD_TAB_CLOSE
        \, s:CMD_LOWER
        \, s:CMD_UPPER ]
    return l:items
endfunction

function! s:Reduce(items, key, len)
    let l:newItems = []
    for l:item in a:items
        if stridx(tolower(l:item), tolower(a:key), a:len) == a:len
            call add(l:newItems, l:item)
        endif
    endfor
    return l:newItems
endfunction

"-------------------------------------------------------------------------
"     SOURCE CODE
"-------------------------------------------------------------------------
let s:len = 0
let s:items = s:Menu()
let s:opts = {
    \  'border'     : [1,0,0,0]
    \, 'borderchars': ['-']
    \, 'callback'   : function('s:Callback')
    \, 'cursorline' : 1
    \, 'filter'     : function('s:Filter')
    \, 'filtermode' : 'a'
    \, 'maxheight'  : 20
    \, 'padding'    : [1, 1, 0, 1]
    \, 'title'      : '> '
    \, 'wrap'       : 0}


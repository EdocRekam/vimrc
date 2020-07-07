
" THINGS I CANNOT LOCALIZE
function! Vimrc_get_statusline()
    let l:head = exists('s:head') ? s:head : ''
    let l:enc = strlen(&fenc) ? '  ' . toupper(&fenc) : '  PLAIN'
    let l:bom = &bomb? '  with BOM' : ''
    let l:le = &ff == 'unix' ? '  LF' : '  CRLF'
    return l:head . '  %M%<%f%=' . l:enc . l:bom . l:le . '  %Y'
endfunction

" INTERNAL LIBRARY FUNCTIONS
function! s:chomp(msg)
    return strcharpart(a:msg, 0, strlen(a:msg)-1)
endfunction

function! s:MakeTabBuffer(title)
    if bufexists(a:title)
        let l:bufnr = bufnr(a:title)
        silent exe printf("bwipeout! %d", l:bufnr)
    endif
    silent exe printf('tabnew %s', a:title)
    setlocal buftype=nofile
    setlocal noswapfile
    normal gg
endfunction

"
" CREATE A BUFFER WITH TITLE, REPLACE IF EXITS
"
function! s:NewOrReplaceBuffer(title)
    if bufexists(a:title)
        let l:bufnr = bufnr(a:title)
        silent exe printf("bwipeout! %d", l:bufnr)
    endif
    let l:bufnr = bufadd(a:title)
    call bufload(l:bufnr)
    silent exe printf("%db", l:bufnr)
    setlocal buflisted
    setlocal buftype=nofile
    setlocal noswapfile
endfunction

function! s:shell(...)
    let s:cmd = call('printf', a:000)
    return system(s:cmd)
endfunction

function! s:shell_list(...)
    let s:cmd = call('printf', a:000)
    return systemlist(s:cmd)
endfunction

function! s:shell_tab(title, ...)
    if bufexists(a:title)
        let l:bufnr = bufnr(a:title)
        silent exe printf("bwipeout! %d", l:bufnr)
    endif
    silent exe printf('tabnew %s', a:title)
    setlocal buftype=nofile
    setlocal noswapfile
    silent exe printf('-1read !%s', call('printf', a:000))
    normal gg
endfunction

function! s:vim_dir()
    if has('gui_gtk2') || has('gui_gtk3')
        return printf('%s/.vim/', $HOME)
    else
        return printf('%s/vimfiles/', $HOME)
    endif
endfunction

function! s:write(...)
    let l:msg = call('printf', a:000)
    call setline('.', [ l:msg, '' ])
    normal G
endfunction

function! s:write_shell(...)
    silent exe printf('-1read !%s', call('printf', a:000))
    normal G
endfunction

" INTERNAL USER FUNCTIONS - TRIGGERED BY THINGS LIKE MENU
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
    normal gv
    '<,'>%!uniq
    normal gv
endfunction

function! s:SortD()
    normal gv
    '<,'>sort!
    normal gv
endfunction

function! s:SortDI()
    normal gv
    '<,'>sort! i
    normal gv
endfunction

function! s:Sort()
    normal gv
    '<,'>sort
    normal gv
endfunction

function! s:SortI()
    normal gv
    '<,'>sort i
    normal gv
endfunction

function! s:Uppercase()
    normal gvU
    normal gv
endfunction

" PUBLIC FUNCTIONS YOU MAY WANT TO CALL DIRECT YOURSELF
" ------------------------------------------------------------------------
function! GotoDefinition()
    let l:path = expand("<cfile>")
    if filereadable(l:path)
        :e! <cfile>
    elseif exists("g:e0647a20")
        call OmniSharpGotoDefinition()
    endif
endfunction

function! Dos2Unix()
    :update
    :e ++ff=dos
    :setlocal ff=unix
    :w
endfunction

function! Unix2Dos()
   update
   :e ++ff=unix
   setlocal ff=dos
   update
endfunction

function! FindInFiles(criteria)
    silent execute printf('grep! -rn  %s *', a:criteria)
    copen 35
endfunction
command! -nargs=1 Find call FindInFiles('<args>')

function! ExpandTabs()
    update
    :setlocal expandtab
    :retab
    update
endfunction

function! Rename()
    let l:val = input('Value: ')
    execute '%s//' . l:val . '/g'
endfunction

function! RemoveTrailingWhitespace()
    let _s=@/
    :%s/\s\+$//e
    let @/=_s
    :nohl
    unlet _s
endfunction

function! s:rotate()
    if exists('s:orient')
        if s:orient == 'H'
            let s:orient = 'K'
        else
            let s:orient = 'H'
        endif
    else
        let s:orient = 'H'
    endif
    exe printf('windo wincmd %s', s:orient)
endfunction

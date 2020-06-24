
" INTERNAL LIBRARY FUNCTIONS
function! s:Chomp(msg)
    return strcharpart(a:msg, 0, strlen(a:msg)-1)
endfunction

function! s:MakeTabBuffer(title)
    if bufexists(a:title)
        let l:bufnr = bufnr(a:title)
        exe printf("bwipeout! %d", l:bufnr)
    endif
    exe printf('tabnew %s', a:title)
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
        exe printf("bwipeout! %d", l:bufnr)
    endif
    let l:bufnr = bufadd(a:title)
    call bufload(l:bufnr)
    exe printf("%db", l:bufnr)
    setlocal buflisted
    setlocal buftype=nofile
    setlocal noswapfile
endfunction

function! s:TabCommand(title, cmd)
    call s:MakeTabBuffer(a:title)
    call s:WriteExecute(a:cmd)
endfunction

function! s:WriteExecute(cmd)
    silent execute printf('-1r !%s', a:cmd)
endfunction

function! s:WriteLine(msg)
    call setline(winline(), [ a:msg, '' ])
    normal G
endfunction
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
command! Dos2Unix call Dos2Unix()

function! Unix2Dos()
   update
   :e ++ff=unix
   setlocal ff=dos
   update
endfunction
command! Unix2Dos call Unix2Dos()

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
command! RemoveTrailingWhitespace call RemoveTrailingWhitespace()

function! ToggleSplit()
    if exists('s:orient')
        if s:orient == 'K'
            let s:orient = 'H'
        else
            let s:orient = 'K'
        endif
    else
        let s:orient = 'K'
    endif
    exe printf('windo wincmd %s', s:orient)
endfunction

function! ToggleStatusLine()
    if (""==&statusline)
        set statusline+=[%{strlen(&fenc)?&fenc:'none'},
        set statusline+=%{&ff},
        set statusline+=%{&bomb?'bom':'no-bom'}]
        set statusline+=%y " filetype
    else
        set statusline=
    endif
endfunction



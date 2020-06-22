

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

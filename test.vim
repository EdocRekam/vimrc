function! IndentLevel()
    let l:line = getline(v:lnum)
    if l:line[0] == 'f'
        return ">1"
    endif
    return 1
endfunction

function! GetFoldText()
    let l:line = getline(v:foldstart)
    return l:line
endfunction

set foldlevel=0
set foldenable
set foldmethod=syntax
set foldexpr=IndentLevel()
set fillchars=fold:\ 
set foldcolumn=1
set foldtext=GetFoldText()

syn region Folded start="^{" end="^}" transparent fold
syn sync fromstart

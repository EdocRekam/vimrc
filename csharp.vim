
" ------------------------------------------------------------------------
" C# SPECIFIC CONFIGURATION
" ------------------------------------------------------------------------

" OMNISHARP - GENERAL
let g:OmniSharp_server_path='/usr/local/bin/omnisharp'
let g:OmniSharp_server_install='/usr/local/lib64/omnisharp-roslyn'
let g:OmniSharp_server_stdio=1
let g:OmniSharp_start_server=0
let g:OmniSharp_timeout=5

" OMNISHARP - HIGHLIGHTING
let g:OmniSharp_highlighting=2
let g:OmniSharp_hightlight_types=3
let g:omnicomplete_fetch_full_documentation=1

let g:OmniSharp_highlight_groups={
\ 'StringLiteral': 'String',
\ 'XmlDocCommentText': 'Comment'
\}

" POPUP FUNCTIONS
function! s:csharp_use()
    setlocal expandtab
    setlocal shiftwidth=4
    setlocal softtabstop=4
    setlocal tabstop=4
    setlocal fileencoding=utf-8
    setlocal nobomb
    setf cs
endfunction

function! Csharp_get_indent()
    if getline(v:lnum)[0] == 'n'
        return ">1"
    else
        return 1
    endif
endfunction

function! Csharp_get_foldtext()
    return getline(v:foldstart)
endfunction

function! s:csharp_fold()
    setlocal foldlevel=1
    setlocal fillchars+=fold:\ 
    setlocal foldcolumn=1
    setlocal foldexpr=Csharp_get_indent()
    setlocal foldmethod=expr
    setlocal foldtext=Csharp_get_foldtext()
    setlocal foldenable
endfunction

function! s:csharp_nofold()
    setlocal nofoldenable
    setlocal foldcolumn=0
    setlocal foldmethod=manual
endfunction

function! s:charp_startserver()
endfunction

function! s:dotnet_build()
    call s:shell_tab('BUILD', 'dotnet build --nologo')
    setlocal colorcolumn=

    syn case ignore
    syn match Caution "\d\+\sWarn.*"
    syn match Bad "\d\+\sError.*"

    hi Caution guifg=#eed320
    hi Bad guifg=#ee3020
endfunction

function! s:dotnet_restore()
    call s:shell_tab('RESTORE', 'dotnet restore --nologo')
    setlocal colorcolumn=
endfunction

function! s:dotnet_test(...)
    let l:filter = get(a:, 1, '')
    if l:filter == ''
        let l:cmd = 'dotnet test --nologo'
    else
        let l:cmd = printf("dotnet test --nologo --filter '%s'", l:filter)
    endif
    call s:shell_tab('TEST', l:cmd)
    setlocal colorcolumn=
    syn case ignore
    syn match Bad "Failed:\s\d\+"
    syn match Good "Passed:\s\d\+"
    hi Bad guifg=#ee3020
    hi Good guifg=#00b135
endfunction



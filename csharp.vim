
" ------------------------------------------------------------------------
" C# SPECIFIC CONFIGURATION
" ------------------------------------------------------------------------

" OMNISHARP - GENERAL
let g:OmniSharp_server_path='/usr/local/bin/omnisharp'
let g:OmniSharp_server_install='/usr/local/lib64/omnisharp-roslyn'
let g:OmniSharp_server_stdio=1
let g:OmniSharp_start_server=1
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
function! SwitchToCSharp()
    setlocal expandtab
    setlocal shiftwidth=4
    setlocal softtabstop=4
    setlocal tabstop=4
    setlocal fileencoding=utf-8
    setlocal nobomb
    setf cs
endfunction

function! s:DotnetBuild()
    call s:ShellNewTab('BUILD', 'dotnet build --nologo')
    setlocal colorcolumn=

    syn case ignore
    syn match Caution "\d\+\sWarn.*"
    syn match Bad "\d\+\sError.*"

    hi Caution guifg=#eed320
    hi Bad guifg=#ee3020
endfunction

function! s:DotnetRestore()
    call s:ShellNewTab('RESTORE', 'dotnet restore --nologo')
    setlocal colorcolumn=
endfunction

function! s:DotnetTest(...)
    let l:filter = get(a:, 1, '')
    if l:filter == ''
        let l:cmd = 'dotnet test --nologo'
    else
        let l:cmd = printf("dotnet test --nologo --filter '%s'", l:filter)
    endif
    call s:ShellNewTab('TEST', l:cmd)
    setlocal colorcolumn=
    syn case ignore
    syn match Good "Passed:\s\d\+"
    hi Good guifg=#00b135
endfunction



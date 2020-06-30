
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
    " SET TAB HANDLING
    setlocal expandtab
    setlocal shiftwidth=4
    setlocal softtabstop=4
    setlocal tabstop=4

    " SET FILE ENCODING
    setlocal fileencoding=utf-8
    setlocal nobomb

    setf cs
endfunction

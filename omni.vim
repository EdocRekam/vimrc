" https://github.com/OmniSharp/Omnisharp-vim

" 1. Install OmnisSharp-Roslyn
"         https://github.com/OmniSharp/omnisharp-roslyn/releases=
"
" 2. Install `omnisharp-vim`
"         git clone https://github.com/OmniSharp/omnisharp-vim ~/.vim/pack/plugins/start/omnisharp-vim
"
" 3. Turn on plugin support
"         filetype indent plugin on
"
" 4. Manually start server
"         OmniSharp -s /path/to/sln


" OmniSharpHighlight

let g:OmniSharp_server_stdio = 1
let g:OmniSharp_start_server = 1
let g:OmniSharp_server_path  = '/home/jon.chick/omnisharp/run'
let g:OmniSharp_highlighting = 2


let g:OmniSharp_highlight_groups = {
\ 'StringLiteral': 'String',
\ 'XmlDocCommentText': 'Comment'
\}

" function! SanitizeCSharp()
"    call RemoveTrailingWhitespace()
"    call Dos2Unix()
"    call ExpandTabs()
" endfunction

" function! SwitchToCSharp()

    " Set tab handling
"    setlocal expandtab
"    setlocal tabstop=4
"    setlocal shiftwidth=4
"    setlocal softtabstop=4

    " Set file encoding
"    setlocal nobomb
"    setlocal fileencoding=utf-8

    " Customize sanitize function
"    nnoremap <silent> <F12> :call SanitizeCSharp()<CR>
" endfunction

" Remove trailing whitespace when saving CSharp files
" au! BufWritePre *.cs,*.csproj,*.sln call RemoveTrailingWhitespace()

" These are CSharp files
" au! filetypedetect BufNewFile,BufRead *.Tests setf cs

" These are XML files
" au! filetypedetect BufNewFile,BufRead *.props,*.targets setf xml

" Use Audicon GmbH CSharp settings
" au! FileType cs call SwitchToCSharp()

" Remove trailing whitespace when saving C files
" au! BufWritePre *.c call RemoveTrailingWhitespace()


" silent! if plug#begin('~/.vim/plugged')
" Plug 'OmniSharp/omnisharp-vim'
" Plug 'w0rp/ale'
" call plug#end()
" endif

" Add Support For OmniSharp (C# Development)
let g:OmniSharp_hightlight_types=3

" Set type lookup function to preview window instead of echoing it
" let g:OmniSharp_typeLookupInPreview = 1

" Timeout in seconds to wait for server response
let g:OmniSharp_timeout = 5

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview', 'popup'
" and 'popuphidden' if you don't want to see any documentation whatsoever.
" Note that neovim does not support `popuphidden` or `popup` yet: 
" https://github.com/neovim/neovim/issues/10996
set completeopt=longest,menuone,preview,popuphidden

" Highlight the completion documentation popup background/foreground the
" same as the completion menu itself, for better readability with
" highlighted documentation.
set completepopup=highlight:Pmenu,border:off

" Fetch full documentation during omnicomplete requests. By default, only
" Type/Method signatures are fetched. Full documentation can still be
" fetched when you need it with the :OmniSharpDocumentation command.
let g:omnicomplete_fetch_full_documentation = 1

" Set desired preview window height for viewing documentation.
" You might also want to look at the echodoc plugin.
set previewheight=5

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
" let g:ale_linters = { 'cs': ['OmniSharp'] }

" Update semantic highlighting on BufEnter, InsertLeave and TextChanged
let g:OmniSharp_highlight_types = 2

" augroup omnisharp_commands
    " autocmd!

    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    " autocmd CursorHold *.cs OmniSharpTypeLookup

    " The following commands are contextual, based on the cursor position.
    " autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    " autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    " autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    " autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    " autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    " autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    " autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    " autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    " autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    " autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    " autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    " autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    " autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
" augroup END

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
" nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>

" Run code actions with text selected in visual mode to extract method
" xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
" nnoremap <Leader>nm :OmniSharpRename<CR>

" nnoremap <F2> :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
" command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

" Start the OmniSharp server for the current solution
" nnoremap <Leader>ss :OmniSharpStartServer<CR>
" nnoremap <Leader>sp :OmniSharpStopServer<CR>

" Enable snippet completion
" let g:OmniSharp_want_snippet=1


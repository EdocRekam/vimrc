" RUN ONCE
if exists("g:e0647a20")
    finish
endif

" https://github.com/OmniSharp/Omnisharp-vim

" 1. Install OmnisSharp-Roslyn
"         https://github.com/OmniSharp/omnisharp-roslyn/releases
"
" 2. Install `omnisharp-vim`
"         git clone https://github.com/OmniSharp/omnisharp-vim ~/.vim/pack/plugins/start/omnisharp-vim
"
" 3. Turn on plugin support
"         filetype indent plugin on
"
" 4. Manually start server
"         OmniSharp -s /path/to/sln

" TRIGGER SUGGEST                                       CTRL + SPACE
inoremap <silent><c-space> <c-x><c-o>

" RENAME SYMBOL COMMAND
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" OMNISHARP


function! SanitizeCSharp()
    call ExpandTabs()
    call RemoveTrailingWhitespace()
    call Dos2Unix()
endfunction


" REMOVE TRAILING WHITESPACE WHEN SAVING CSHARP FILES
" au! BufWritePre *.cs,*.csproj,*.sln call SanitizeCSharp()

" Set type lookup function to preview window instead of echoing it
" let g:OmniSharp_typeLookupInPreview = 1

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

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
" let g:ale_linters = { 'cs': ['OmniSharp'] }

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

" nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

" Start the OmniSharp server for the current solution
" nnoremap <Leader>ss :OmniSharpStartServer<CR>
" nnoremap <Leader>sp :OmniSharpStopServer<CR>

let g:e0647a20=1

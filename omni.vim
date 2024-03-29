
" TRIGGER SUGGEST                                       CTRL + SPACE
inoremap <silent><c-space> <c-x><c-o>

" RENAME SYMBOL COMMAND
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

function! SanitizeCSharp()
    cal ExpandTabs()
    cal RemoveTrailingWhitespace()
    cal Dos2Unix()
endfunction

" REMOVE TRAILING WHITESPACE WHEN SAVING CSHARP FILES
" au! BufWritePre *.cs,*.csproj,*.sln call SanitizeCSharp()

" Set type lookup function to preview window instead of echoing it
" var g:OmniSharp_typeLookupInPreview = 1

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
" var g:ale_linters = { 'cs': ['OmniSharp'] }

" augroup omnisharp_commands
    " autocmd!

    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    " autocmd CursorHold *.cs OmniSharpTypeLookup

    " The following commands are contextual, based on the cursor position.
    " autocmd FileType cs nn <buffer> gd :OmniSharpGotoDefinition<CR>
    " autocmd FileType cs nn <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    " autocmd FileType cs nn <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    " autocmd FileType cs nn <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    " autocmd FileType cs nn <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    " autocmd FileType cs nn <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    " autocmd FileType cs nn <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    " autocmd FileType cs nn <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    " autocmd FileType cs nn <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    " autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    " autocmd FileType cs nn <buffer> <C-k> :OmniSharpNavigateUp<CR>
    " autocmd FileType cs nn <buffer> <C-j> :OmniSharpNavigateDown<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    " autocmd FileType cs nn <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
" augroup END

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
" nn <Leader><Space> :OmniSharpGetCodeActions<CR>

" Run code actions with text selected in visual mode to extract method
" xnoremap <Leader><Space> :cal OmniSharp#GetCodeActions('visual')<CR>

" nn <Leader>cf :OmniSharpCodeFormat<CR>

" Start the OmniSharp server for the current solution
" nn <Leader>ss :OmniSharpStartServer<CR>
" nn <Leader>sp :OmniSharpStopServer<CR>


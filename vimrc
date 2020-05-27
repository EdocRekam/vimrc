" General VIM settings

" No VI compatibility
set nocp

" No start of line on many commands
set nosol

" Make backspace work correctly
set backspace=indent,eol,start

" Display position at bottom of file
set ruler

" Do not wrap lines
set nowrap

" Display line numbers and set it to four columns wide
set number
set numberwidth=4

" Set colorscheme
colorscheme desert

" Turn on file type inspection to recieve filetype events
filetype on

" Turn on syntax highlighting in GVIM
if has("gui_running")
    syntax on
endif

" Set our preferred font to Courier New
if has("gui_running")
    if has("gui_gtk2") || has("gui_gtk3")
        set gfn=Courier\ New\ 10
    elseif has("gui_win32")
        set gfn=Courier_New:h10:cDEFAULT
    endif
endif

" Display special characters
set list

" Change how we display tab characters
set listchars=tab:>-

" Set highlight background color
highlight ColorColumn ctermbg=0 guibg=lightgrey

" DISPLAY COLUMN GUIDES
set colorcolumn=75,80,120,160

" Always display the status line
set laststatus=2

" Turn on spell checking.
set spell spelllang=en_us
hi clear SpellBad
hi SpellBad cterm=underline

" ADD PLUGIN MANAGER SUPPORT (vim-plug)
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
filetype indent plugin on

silent! if plug#begin('~/.vim/plugged')
Plug 'OmniSharp/omnisharp-vim'
Plug 'w0rp/ale'
call plug#end()
endif

" Add Support For OmniSharp (C# Development)
let g:OmniSharp_server_stdio=1
let g:OmniSharp_hightlight_types=3

" Set the type lookup function to use the preview window instead of echoing it
"let g:OmniSharp_typeLookupInPreview = 1

" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 5

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview', 'popup'
" and 'popuphidden' if you don't want to see any documentation whatsoever.
" Note that neovim does not support `popuphidden` or `popup` yet: 
" https://github.com/neovim/neovim/issues/10996
set completeopt=longest,menuone,preview,popuphidden

" Highlight the completion documentation popup background/foreground the same as
" the completion menu itself, for better readability with highlighted
" documentation.
set completepopup=highlight:Pmenu,border:off

" Fetch full documentation during omnicomplete requests.
" By default, only Type/Method signatures are fetched. Full documentation can
" still be fetched when you need it with the :OmniSharpDocumentation command.
let g:omnicomplete_fetch_full_documentation = 1

" Set desired preview window height for viewing documentation.
" You might also want to look at the echodoc plugin.
set previewheight=5

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters = { 'cs': ['OmniSharp'] }

" Update semantic highlighting on BufEnter, InsertLeave and TextChanged
let g:OmniSharp_highlight_types = 2

augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    autocmd CursorHold *.cs OmniSharpTypeLookup

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
augroup END

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <Leader>nm :OmniSharpRename<CR>
nnoremap <F2> :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <Leader>ss :OmniSharpStartServer<CR>
nnoremap <Leader>sp :OmniSharpStopServer<CR>

" Enable snippet completion
" let g:OmniSharp_want_snippet=1

" *******************************************************************
" Source code
" *******************************************************************
function! RemoveTrailingWhitespace()
    let _s=@/
    :%s/\s\+$//e
    let @/=_s
    :nohl
    unlet _s
endfunction

function! Dos2Unix()
    :update
    :e ++ff=dos
    :setlocal ff=unix
    :w
endfunction

function! Unix2Dos()
   :update
   :e ++ff=unix
   :setlocal ff=dos
   :w
endfunction

function! ExpandTabs()
    :update
    :setlocal expandtab
    :retab
    :w
endfunction

function! SanitizeCSharp()
    call RemoveTrailingWhitespace()
    call Dos2Unix()
    call ExpandTabs()
endfunction

function! Set80Columns()
    setlocal textwidth=80
    execute "setlocal colorcolumn=" . join(range(81,335), ',')
endfunction

function! Set120Columns()
    setlocal textwidth=120
    execute "setlocal colorcolumn=" . join(range(121,335), ',')
endfunction

function! SetDefaultColumns()
    setlocal textwidth=120
    setlocal colorcolumn=75,80,120,160
    highlight ColorColumn ctermbg=0 guibg=lightgrey
endfunction

function! SwitchToCSharp()

    " Set tab handling
    setlocal expandtab
    setlocal tabstop=4
    setlocal shiftwidth=4
    setlocal softtabstop=4

    " Set file encoding
    setlocal nobomb
    setlocal fileencoding=utf-8

    " Customize sanitize function
    nnoremap <silent> <F12> :call SanitizeCSharp()<CR>
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

" *******************************************************************
" Key bindings
" *******************************************************************

" ALT+UP - Move line up
inoremap <A-Up> <ESC>:m-2<CR>:startinsert<CR>
nnoremap <A-Up> :m-2<CR>==
vnoremap <A-Up> :m '<-2<CR>gv=gv

" ALT+DOWN - Move line down
inoremap <A-Down> <ESC>:m+<CR>:startinsert<CR>
nnoremap <A-Down> :m+<CR>==
vnoremap <A-Down> :m '>+1<CR>gv=gv

" CTRL+TAB - Always insert real tab
inoremap <C-Tab> <C-Q><Tab>
nnoremap <C-Tab> i<C-Q><Tab>

" TAB - Indent
vnoremap <Tab> > <CR>gv

" SHIFT+TAB - Unindent
inoremap <S-Tab> <C-d>
nnoremap <S-Tab> <<
vnoremap <S-Tab> < <CR>gv

" CTRL+C - Copy
vnoremap <C-c> "+y
vnoremap <C-x> "+x
inoremap <C-v> "+gP
nnoremap <C-v> "+gP

" CTRL+S - Sort block
vnoremap <C-S> :'<,'>sort<CR>gv

" F1 - Toggle status bar
inoremap <silent> <F1> :call ToggleStatusLine()<CR>
nnoremap <silent> <F1> :call ToggleStatusLine()<CR>
vnoremap <silent> <F1> :call ToggleStatusLine()<CR>

" F5 - Remove trailing whitespace
nnoremap <silent> <F5> :call RemoveTrailingWhitespace()<CR>

" *******************************************************************
" Event handling
" *******************************************************************

" Remove trailing whitespace when saving CSharp files
au! BufWritePre *.cs,*.csproj,*.sln call RemoveTrailingWhitespace()

" These are CSharp files
au! filetypedetect BufNewFile,BufRead *.Tests setf cs

" These are XML files
au! filetypedetect BufNewFile,BufRead *.props,*.targets setf xml

" Remove trailing whitespace when saving C files
au! BufWritePre *.c call RemoveTrailingWhitespace()

" Use Audicon GmbH CSharp settings
au! FileType cs call SwitchToCSharp()

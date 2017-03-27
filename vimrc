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
highlight ColorColumn guibg=black

" Always display the status line
set laststatus=2

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

function! SanitizeCSharp()
    call RemoveTrailingWhitespace()
    call Dos2Unix()
endfunction

function! Set80Columns()
    setlocal textwidth=80
    execute "setlocal colorcolumn=" . join(range(81,335), ',')
endfunction

function! Set120Columns()
    setlocal textwidth=120
    execute "setlocal colorcolumn=" . join(range(121,335), ',')
endfunction

function! SwitchToCSharp()
    call Set80Columns()

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

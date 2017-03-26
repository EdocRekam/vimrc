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

function! Set80Columns()
    set textwidth=80
    execute "set colorcolumn=" . join(range(81,335), ',')
endfunction

function! Set120Columns()
    set textwidth=120
    execute "set colorcolumn=" . join(range(121,335), ',')
endfunction

function! SwitchToCSharp()
    call Set120Columns()

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

" TAB - Indent
vnoremap <Tab> > <CR>gv

" SHIFT+TAB - Unindent
inoremap <S-Tab> <C-d>
nnoremap <S-Tab> <<
vnoremap <S-Tab> < <CR>gv

" CTRL+S - Sort block
vnoremap <C-S> :'<,'>sort<CR>gv

" F5 - Remove trailing whitespace
nnoremap <F5> :call RemoveTrailingWhitespace()<CR>

" *******************************************************************
" Event handling
" *******************************************************************

" Remove trailing whitespace when saving CSharp files
au! BufWritePre *.cs,*.csproj,*.sln call RemoveTrailingWhitespace()

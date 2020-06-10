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

" FUZZY FILE GLOBS
set path+=**

" HIGHLIGHT ALL SEARCH MATCH(S)
set hlsearch

" SET SEARCH TO CASE INSENSITIVE
set ignorecase

" DISPLAY LINE NUMBERS WITH 5 CHAR GUTTER
set number
set numberwidth=5

" DEFAULT TAB HANDLING
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" DEFAULT FILE ENCODING
set nobomb
set fileencoding=utf-8

" Turn on syntax highlighting in GVIM
" if has("gui_running")
"    syntax on
" endif

" SET PREFERRED FONT + GVIM OPTIONS
let g:fontSize=16
if has("gui_running")
        if has("gui_gtk2") || has("gui_gtk3")
                set gfn=Inconsolata\ 16

                " HIDE TOOLBAR AND MENU
                set guioptions -=T
                set guioptions -=m
        elseif has("gui_win32")
                set gfn=Courier_New:h10:cDEFAULT
        endif
endif

" HIGHLIGHT TABS AND TRAILING WHITESPACE
set list
set listchars=tab:▸\ ,trail:·

" DISPLAY COLUMN GUIDES
set colorcolumn=75,80,120,160

" Always display the status line
set laststatus=2

" Turn on spell checking.
set spell spelllang=en_us

" Turn on file type inspection to receive filetype events
filetype on

" TURN ON PLUGIN SUPPORT
filetype indent plugin on

" SET THEME (ORDER SPECIFIC)
colorscheme dark_plus

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
command! RemoveTrailingWhitespace call RemoveTrailingWhitespace()

function! Dos2Unix()
    :update
    :e ++ff=dos
    :setlocal ff=unix
    :w
endfunction
command! Dos2Unix call Dos2Unix()

function! Unix2Dos()
   :update
   :e ++ff=unix
   :setlocal ff=dos
   :w
endfunction
command! Unix2Dos call Unix2Dos()

function! ExpandTabs()
    :update
    :setlocal expandtab
    :retab
    :w
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

function! ZoomIn()
        if !exists('g:fontSize')
                let g:fontSize=10
        endif

        if (g:fontSize < 10)
                let g:fontSize=10
        endif

        let g:fontSize=g:fontSize+1
        let font="Inconsolata " .. g:fontSize
        let &guifont=font
endfunction

function! ZoomOut()
        if !exists('g:fontSize')
                let g:fontSize=10
        endif

        if (g:fontSize > 20)
                let g:fontSize=20
        endif

        let g:fontSize=g:fontSize-1
        let font="Inconsolata " .. g:fontSize
        let &guifont=font
endfunction

" *******************************************************************
" Key bindings
" *******************************************************************

" CTRL+TAB - Always insert real tab
inoremap <C-Tab> <C-Q><Tab>
nnoremap <C-Tab> i<C-Q><Tab>

" TAB - Indent
vnoremap <Tab> > <CR>gv

" SHIFT+TAB - Unindent
inoremap <S-Tab> <C-d>
nnoremap <S-Tab> <<
vnoremap <S-Tab> < <CR>gv

" CTRL+S - Sort block
vnoremap <C-S> :'<,'>sort<CR>gv

" F1 - Toggle status bar
inoremap <silent> <F1> :call ToggleStatusLine()<CR>
nnoremap <silent> <F1> :call ToggleStatusLine()<CR>
vnoremap <silent> <F1> :call ToggleStatusLine()<CR>

" INCREASE/DECREASE FONT CTRL+SHIFT LEFT/RIGHT
nnoremap <silent> <C-S-RIGHT> :call ZoomIn()<CR>
nnoremap <silent> <C-S-LEFT> :call ZoomOut()<CR>


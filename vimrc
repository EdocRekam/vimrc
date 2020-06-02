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

" DISPLAY LINE NUMBERS WITH 5 CHAR GUTTER
set number
set numberwidth=5

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

" F10 - ROTATE WINDOWS RIGHT/LEFT
nnoremap <silent> <F10> <C-W>x

" F11 - Split Window Up/Down
nnoremap <silent> <F11> :split<CR>
nnoremap <silent> <S-F11> :q<CR>

" F12 - Split Window Vertical
nnoremap <silent> <F12> :vsplit<CR>
nnoremap <silent> <S-F12> :q<CR>

" PAGE UP/DOWN MOVE CURSOR INSTEAD OF PAGE
nnoremap <silent> <PAGEUP> :-45<CR>
nnoremap <silent> <PAGEDOWN> :+45<CR>

" CTRL+UP TOGGLES NERDTREE
nnoremap <silent> <C-UP> :NERDTreeToggle<CR>

" CTRL LEFT/RIGHT SIZE SPLIT
nnoremap <silent> <C-RIGHT> 10<C-w>>
nnoremap <silent> <C-LEFT> 10<C-w><

" INCREASE/DECREASE FONT CTRL+SHIFT LEFT/RIGHT
nnoremap <silent> <C-S-RIGHT> :call ZoomIn()<CR>
nnoremap <silent> <C-S-LEFT> :call ZoomOut()<CR>


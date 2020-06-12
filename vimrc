" NO VI COMPATIBILITY
set nocp

" NO START OF LINE ON MANY COMMANDS
set nosol

" MAKE BACKSPACE WORK CORRECTLY
set backspace=indent,eol,start

" DISPLAY POSITION AT BOTTOM OF FILE
set ruler

" DO NOT WRAP LINES
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

" HIGHLIGHT TABS AND TRAILING WHITESPACE
set list
set listchars=tab:▸\ ,trail:·

" DISPLAY COLUMN GUIDES
set colorcolumn=75,80,120,160

" ALWAYS DISPLAY THE STATUS LINE
set laststatus=2

" TURN ON SPELL CHECKING.
set spell spelllang=en_us

" TURN ON FILE TYPE INSPECTION TO RECEIVE FILETYPE EVENTS
filetype on

" TURN ON PLUGIN SUPPORT
filetype indent plugin on

" SET THEME (ORDER SPECIFIC)
colorscheme dark_plus

" TURN ON SYNTAX HIGHLIGHTING
syntax on

" KEY BINDINGS
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:script = s:path . '/keymap.vim'
if filereadable(s:script)
    execute 'source ' . s:script
endif

" PREVENT OMNISHARP INSTALL DIALOG
let g:OmniSharp_server_path='/usr/local/bin/omnisharp'

" FILE TYPES
let s:script = s:path . '/filetypes.vim'
if filereadable(s:script)
    execute 'source ' . s:script
endif

" *******************************************************************
" SOURCE CODE
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

function! FindInFiles(criteria)
    execute 'silent grep! ' . a:criteria . ' *'
    copen
endfunction
command! -nargs=1 Find call FindInFiles('<args>')

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
        let l:oldFontName = getfontname()
        let l:sizeIdx = match(oldFontName,"[0-9][0-9]")
        let l:fontFamily = strcharpart(l:oldFontName, -1, l:sizeIdx)
        let l:oldFontSize = str2nr(strcharpart(l:oldFontName, l:sizeIdx, 2))
        let l:newFontSize = l:oldFontSize + 1
        if l:newFontSize > 30
            let l:newFontSize = 14
        endif

        let newFontName = printf("%s %d", l:fontFamily, l:newFontSize)
        let &guifont=l:newFontName

        unlet l:fontFamily
        unlet l:newFontSize
        unlet l:oldFontName
        unlet l:oldFontSize
        unlet l:sizeIdx
endfunction

function! ZoomOut()
        let l:oldFontName = getfontname()
        let l:sizeIdx = match(l:oldFontName,"[0-9][0-9]")
        let l:fontFamily = strcharpart(l:oldFontName, -1, l:sizeIdx)
        let l:oldFontSize = str2nr(strcharpart(l:oldFontName, l:sizeIdx, 2))
        let l:newFontSize = l:oldFontSize - 1
        if l:newFontSize < 14
            let l:newFontSize = 30
        endif

        let l:newFontName = printf("%s %d", l:fontFamily, l:newFontSize)
        let &guifont=l:newFontName

        unlet l:fontFamily
        unlet l:newFontSize
        unlet l:oldFontName
        unlet l:oldFontSize
        unlet l:sizeIdx
endfunction


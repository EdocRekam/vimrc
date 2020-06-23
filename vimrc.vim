" NO VI COMPATIBILITY
set nocp
set encoding=utf-8
scriptencoding utf-8

" MAKE BACKSPACE WORK CORRECTLY
set backspace=indent,eol,start

" DISPLAY LENGTH OF SELECTION ON COMMAND
set showcmd

" DISPLAY COLUMN GUIDES
set colorcolumn=75,80,120,160

" SYNCHRONIZE CLIPBOARD
set clipboard^=unnamed

" HIGHLIGHT LINE
set cursorline

" HIGHLIGHT ALL SEARCH MATCH(S)
set hlsearch

" SET SEARCH TO CASE INSENSITIVE
set ignorecase

" ALWAYS DISPLAY THE STATUS LINE
set laststatus=2

" HIGHLIGHT TABS AND TRAILING WHITESPACE
set list
set listchars=tab:▸\ ,trail:·

" NO START OF LINE ON MANY COMMANDS
set nosol

" DO NOT WRAP LINES
set nowrap

" DISPLAY LINE NUMBERS WITH 5 CHAR GUTTER
set number
set numberwidth=5

" FUZZY FILE GLOBS
set path+=**

" UNKNOWN
set previewheight=5

" DISPLAY POSITION AT BOTTOM OF FILE
set ruler

" TURN ON SPELL CHECKING.
set spell spelllang=en_us

" DEFAULT TAB HANDLING
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" DEFAULT FILE ENCODING
set nobomb
set fileencoding=utf-8

" TURN ON FILE TYPE INSPECTION TO RECEIVE FILETYPE EVENTS
filetype on

" TURN ON PLUGIN SUPPORT
filetype indent plugin on

" SET THEME (ORDER SPECIFIC)
colorscheme Dark+

" TURN ON SYNTAX HIGHLIGHTING
syntax on

" PREVENT OMNISHARP INSTALL DIALOG
let g:OmniSharp_server_path='/usr/local/bin/omnisharp'

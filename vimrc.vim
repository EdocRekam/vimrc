" NO VI COMPATIBILITY
set nocp
set encoding=utf-8
scriptencoding utf-8

" MAKE BACKSPACE WORK CORRECTLY
set backspace=indent,eol,start

" DISPLAY SELECTION LEN
set sc

" SYNCHRONIZE CLIPBOARD
set clipboard^=unnamed

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

" FUZZY FILE GLOBS
set path+=**

" KEEP CURSOR IN MIDDLE
set scrolloff=30

" MISC
set colorcolumn=75,80,120,160
set cursorline
set expandtab
set fileencoding=utf-8
set nobomb
set nowrap
set number
set numberwidth=5
set previewheight=5
set ruler
set shiftwidth=4
set softtabstop=4
set spell spelllang=en_us
set statusline=%!Vimrc_get_statusline()
set tabstop=4

" TURN ON FILE TYPE INSPECTION TO RECEIVE FILETYPE EVENTS
filetype on

" TURN ON PLUGIN SUPPORT
filetype indent plugin on

" SET THEME (ORDER SPECIFIC)
colorscheme Dark+

" TURN ON SYNTAX HIGHLIGHTING
syntax on

" VISUAL STUDIO CODE DEFAULT KEYBOARD SHORTCUTS
mapclear

" MOVE LINE DOWN                                        ALT + DOWN
inoremap <A-Down> <ESC>:m+<CR>:startinsert<CR>
nnoremap <A-Down> :m+<CR>==
vnoremap <A-Down> :m '>+1<CR>gv=gv

" MOVE LINE UP                                          ALT + UP
inoremap <A-Up> <ESC>:m-2<CR>:startinsert<CR>
nnoremap <A-Up> :m-2<CR>==
vnoremap <A-Up> :m '<-2<CR>gv=gv

" RESIZE SPLIT                                          CTRL + LEFT
"                                                       CTRL + RIGHT
nnoremap <silent><c-left> 10<c-w><
nnoremap <silent><c-right> 10<c-w>>

" TOGGLE NERDTREE                                       CTRL + UP
nnoremap <silent><C-UP> :NERDTreeToggle<CR>

" SAVE FILE                                             CTRL + S
inoremap <silent><C-s> <ESC>:w<CR>i
nnoremap <silent><C-s> :w<CR>

" CURSOR HOME SELECT                                    SHIFT + HOME
inoremap <silent><S-Home> <ESC>v<HOME>
nnoremap <silent><S-Home> <ESC>v<HOME>

" CURSOR END SELECT                                     SHIFT + END
inoremap <silent><s-end> <esc>v<end>
nnoremap <silent><s-end> <esc>v<end>

" COPY                                                  CTRL + C
vnoremap <c-c> "+y

" CUT                                                   CTRL + X
vnoremap <c-x> "+x

" PASTE                                                 CTRL + V
inoremap <silent><c-v> <c-r>+=
" nnoremap <C-v> "+gP

" ROTATE WINDOWS RIGHT/LEFT                             F10
nnoremap <silent><F10> <C-W>x

" SPLIT WINDOW UP/DOWN                                  F11
nnoremap <silent><f11> :split<cr>
nnoremap <silent><s-f11> :q<cr>

" SPLIT WINDOW VERTICAL                                 F12
nnoremap <silent><f12> :vsplit<cr>
nnoremap <silent><s-f12> :q<cr>

" BLOCK VISUAL                                          Shift + Alt + Up
"                                                       Shift + Alt + Down
nnoremap <silent><s-a-up> <c-v>
nnoremap <silent><s-a-down> <c-v>

" PAGE UP|DOWN                                          PAGE UP|DOWN
inoremap <silent><pageup> <ESC><c-u>i
inoremap <silent><pagedown> <ESC><c-d>i

nnoremap <F5> :so %<CR>

" FIND                                                  CTRL + F3
" FIND NEXT                                             F3
" RENAME SYMBOL                                         F2
" SAVE FILE AS . . .                                    CTRL + SHIFT + S
" SELECT ALL                                            CTRL + A
" SHOW ALL COMMANDS                                     F1
" TRIM TRAILING WHITESPACE
" UNDO                                                  CTRL + Z

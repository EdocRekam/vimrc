" VISUAL STUDIO CODE DEFAULT KEYBOARD SHORTCUTS
" mapclear

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

" SORT BLOCK                                            CTRL + S
vnoremap <silent><C-s> :'<,'>sort<CR>gv

" CURSOR HOME SELECT                                    SHIFT + HOME
inoremap <silent><S-Home> <ESC>v<HOME>
nnoremap <silent><S-Home> <ESC>v<HOME>

" CURSOR END SELECT                                     SHIFT + END
inoremap <silent><s-end> <esc>v<end>
nnoremap <silent><s-end> <esc>v<end>

" SELECT ALL                                            CTRL + A
nnoremap <silent><C-a> :normal GVgg<CR>

" COPY                                                  CTRL + C
vnoremap <silent>y "+y
vnoremap <c-c> "+y

" CUT                                                   CTRL + X
vnoremap <silent>x "+x
vnoremap <c-x> "+x

" PASTE                                                 CTRL + V
vnoremap <silent>p "+p
vnoremap <silent>P "+P
nnoremap <silent>p "+p
nnoremap <silent>P "+P
inoremap <silent><c-v> <c-r>+

" SHOW ALL COMMANDS                                     F1
inoremap <silent> <F1> :call ToggleStatusLine()<CR>
nnoremap <silent> <F1> :call ToggleStatusLine()<CR>
vnoremap <silent> <F1> :call ToggleStatusLine()<CR>

" GOTO FILE > DEFINITION                                F4
nnoremap <silent><F4> :call GotoDefinition()<CR>
nnoremap <silent><S-F4> :call FindInFiles('<cword>')<CR>

" SOURCE CURRENT FILE                                   F5
nnoremap <F5> :so %<CR>

" GIT GUI                                               F7
nnoremap <silent><F7> :silent !git gui&<cr>

" GIT STATUS                                            F8
nnoremap <silent><F8> :call GitStatus()<CR>

" LAUNCH NEW INSTANCE                                   F9
nnoremap <silent><F9> :silent !gvim&<cr>

" ROTATE WINDOWS RIGHT/LEFT                             F10
nnoremap <silent><F10> <C-W>x

" NEXT TAB                                              F11
nnoremap <silent><F11> :tabnext<CR>

" NEXT BUFFER                                           SHIFT + F11
nnoremap <silent><S-F11> :bnext!<CR>

" SPLIT WINDOW LEFT|RIGHT                               F12
nnoremap <silent><F12> :vsplit<cr>

" TOGGLE SPLIT UP DOWN | LEFT RIGHT
nnoremap <silent><S-F12> :call ToggleSplit()<CR>

" BLOCK VISUAL                                          SHIFT + ALT + UP
"                                                       SHIFT + ALT + DOWN
nnoremap <silent><s-a-up> <c-v>
nnoremap <silent><s-a-down> <c-v>

" PAGE UP|DOWN                                          PAGE UP|DOWN
inoremap <silent><pageup> <ESC><c-u>i
inoremap <silent><pagedown> <ESC><c-d>i

" INCREASE FONT                                         CTRL + SHIFT + RIGHT
nnoremap <silent> <C-S-RIGHT> :call ZoomIn()<CR>

" DECREASE FONT                                         CTRL + SHIFT + LEFT
nnoremap <silent> <C-S-LEFT> :call ZoomOut()<CR>

" INDENT                                                TAB
nnoremap <Tab> >>
vnoremap <Tab> > <CR>gv

" OUTDENT                                               SHIFT + TAB
nnoremap <S-Tab> <<
vnoremap <S-Tab> < <cr>gv

" ALWAYS INSERT REAL TAB                                CTRL + TAB
inoremap <C-Tab> <C-Q><Tab>
nnoremap <C-Tab> i<C-Q><Tab>


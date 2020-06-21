

" VISUAL STUDIO CODE DEFAULT KEYBOARD SHORTCUTS
" mapclear

" MOVE LINE DOWN                                        ALT + DOWN
inoremap <A-DOWN> <ESC>:m+<cr>:startinsert<cr>
nnoremap <A-DOWN> :m+<cr>==
vnoremap <A-DOWN> :m '>+1<cr>gv=gv

" MOVE LINE UP                                          ALT + UP
inoremap <A-UP> <ESC>:m-2<cr>:startinsert<cr>
nnoremap <A-UP> :m-2<cr>==
vnoremap <A-UP> :m '<-2<cr>gv=gv

" PREVIOUS TAB                                          CTRL + LEFT
" NEXT TAB                                              CTRL + RIGHT
nnoremap <C-LEFT> :tabprev<cr>
nnoremap <C-RIGHT> :tabnext<cr>

" DECREASE FONT                                         CTRL + SHIFT + LEFT
" INCREASE FONT                                         CTRL + SHIFT + RIGHT
nnoremap <silent><C-S-LEFT> :call ZoomOut()<cr>
nnoremap <silent><C-S-RIGHT> :call ZoomIn()<cr>

" RESIZE SPLIT                                          ALT + LEFT
"                                                       ALT + RIGHT
nnoremap <A-LEFT> 20<C-w><
nnoremap <A-RIGHT> 20<C-w>>

" TOGGLE NERDTREE                                       CTRL + UP
nnoremap <silent><C-UP> :NERDTreeToggle<cr>

" SAVE FILE                                             CTRL + S
inoremap <C-S> <ESC>:w<cr>i
nnoremap <C-S> :w<cr>

" SORT BLOCK                                            CTRL + S
vnoremap <silent><C-S> :'<,'>sort<cr>gv

" CURSOR HOME SELECT                                    SHIFT + HOME
inoremap <silent><S-HOME> <ESC>v<HOME>
nnoremap <silent><S-HOME> <ESC>v<HOME>

" CURSOR END SELECT                                     SHIFT + END
inoremap <silent><S-END> <ESC>v<END>
nnoremap <silent><S-END> <ESC>v<END>

" SELECT ALL                                            CTRL + A
nnoremap <silent><C-A> :normal GVgg<cr>

" COPY                                                  CTRL + C
vnoremap <C-C> "+y
vnoremap y "+y

" CUT                                                   CTRL + X
vnoremap <C-X> "+x
vnoremap x "+x

" PASTE                                                 CTRL + V
vnoremap <silent>p "+p
vnoremap <silent>P "+P
nnoremap <silent>p "+p
nnoremap <silent>P "+P
inoremap <silent><c-v> <c-r>+

" LIST FUNCTIONS                                        F1
nnoremap <silent><F1> :call ListFunctions()<cr>
vnoremap <silent><F1> :call ListFunctions()<cr>

" RENAME SYMBOL                                         F2
nnoremap <silent><F2> :OmniSharpRename<cr>

" RESERVED (CODE HELPER)                                F3


" GOTO FILE > DEFINITION                                F4
nnoremap <silent><F4> :call GotoDefinition()<cr>
nnoremap <silent><S-F4> :call FindInFiles('<cword>')<cr>

" SOURCE CURRENT FILE                                   F5
nnoremap <F5> :so %<cr>

" RESERVED                                              F6


" GIT GUI                                               F7
nnoremap <silent><F7> :silent !git gui&<cr>

" GIT STATUS                                            F8
nnoremap <silent><F8> :call GitStatus()<cr>

" LAUNCH NEW INSTANCE                                   F9
nnoremap <silent><F9> :silent !gvim&<cr>

" ROTATE WINDOWS RIGHT/LEFT                             F10
nnoremap <F10> <C-W>x

" NEXT TAB                                              F11
nnoremap <silent><F11> :tabnext<cr>

" NEXT BUFFER                                           SHIFT + F11
nnoremap <silent><S-F11> :bnext!<cr>

" SPLIT WINDOW LEFT|RIGHT                               F12
nnoremap <silent><F12> :vsplit<cr>

" TOGGLE SPLIT UP DOWN | LEFT RIGHT                     SHIFT + F12
nnoremap <silent><S-F12> :call ToggleSplit()<cr>

" BLOCK VISUAL                                          SHIFT + ALT + UP
"                                                       SHIFT + ALT + DOWN
nnoremap <silent><s-a-up> <c-v>
nnoremap <silent><s-a-down> <c-v>

" PAGE UP|DOWN                                          PAGE UP|DOWN
inoremap <silent><pageup> <ESC><c-u>i
inoremap <silent><pagedown> <ESC><c-d>i

" INDENT                                                TAB
nnoremap <Tab> >>
vnoremap <Tab> > <cr>gv

" OUTDENT                                               SHIFT + TAB
nnoremap <S-Tab> <<
vnoremap <S-Tab> < <cr>gv

" ALWAYS INSERT REAL TAB                                CTRL + TAB
inoremap <C-Tab> <C-Q><Tab>
nnoremap <C-Tab> i<C-Q><Tab>


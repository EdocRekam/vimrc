

" VISUAL STUDIO CODE DEFAULT KEYBOARD SHORTCUTS
" mapclear

" MOVE LINE DOWN                                        ALT + DOWN
inoremap <A-DOWN> <ESC>:m+<CR>:startinsert<CR>
nnoremap <A-DOWN> :m+<CR>==
vnoremap <A-DOWN> :m '>+1<CR>gv=gv

" MOVE LINE UP                                          ALT + UP
inoremap <A-UP> <ESC>:m-2<CR>:startinsert<CR>
nnoremap <A-UP> :m-2<CR>==
vnoremap <A-UP> :m '<-2<CR>gv=gv

" PREVIOUS TAB                                          CTRL + LEFT
" NEXT TAB                                              CTRL + RIGHT
nnoremap <silent><C-LEFT> :tabprev<CR>
nnoremap <silent><C-RIGHT> :tabnext<CR>

" DECREASE FONT                                         CTRL + SHIFT + LEFT
" INCREASE FONT                                         CTRL + SHIFT + RIGHT
nnoremap <silent><C-S-LEFT> :call ZoomOut()<CR>
nnoremap <silent><C-S-RIGHT> :call ZoomIn()<CR>

" RESIZE SPLIT                                          ALT + LEFT
"                                                       ALT + RIGHT
nnoremap <A-LEFT> 20<C-w><
nnoremap <A-RIGHT> 20<C-w>>

" TOGGLE NERDTREE                                       CTRL + UP
nnoremap <silent><C-UP> :NERDTreeToggle<CR>

" SAVE FILE                                             CTRL + S
inoremap <C-S> <ESC>:w<CR>i
nnoremap <C-S> :w<CR>

" SORT BLOCK                                            CTRL + S
vnoremap <silent><C-S> :'<,'>sort<CR>gv

" CURSOR HOME SELECT                                    SHIFT + HOME
inoremap <silent><S-HOME> <ESC>v<HOME>
nnoremap <silent><S-HOME> <ESC>v<HOME>

" CURSOR END SELECT                                     SHIFT + END
inoremap <silent><S-END> <ESC>v<END>
nnoremap <silent><S-END> <ESC>v<END>

" SELECT ALL                                            CTRL + A
nnoremap <silent><C-A> :normal GVgg<CR>

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
nnoremap <silent><F1> :call ListFunctions()<CR>
vnoremap <silent><F1> :call ListFunctions()<CR>

" RENAME SYMBOL                                         F2
nnoremap <silent><F2> :call Rename()<CR>

" RESERVED (CODE HELPER)                                F3
nnoremap <silent><F3> :bd<CR>
nnoremap <silent><S-F3> :bd!<CR>

" GOTO FILE > DEFINITION                                F4
nnoremap <silent><F4> :call GotoDefinition()<CR>
nnoremap <silent><S-F4> :call FindInFiles('<cword>')<CR>

" SOURCE CURRENT FILE                                   F5
nnoremap <F5> :so %<CR>

" RESERVED                                              F6
nnoremap <silent><F6> :silent !git gui&<CR>

" GIT GUI                                               F7
nnoremap <silent><F7> :silent call <SID>git_log()<CR>

" GIT STATUS                                            F8
nnoremap <silent><F8> :call <SID>git_status()<CR>

" LAUNCH NEW INSTANCE                                   F9
nnoremap <silent><F9> :silent !gvim&<CR>

" ROTATE WINDOWS RIGHT/LEFT                             F10
nnoremap <F10> <C-W>x

" NEXT TAB                                              F11
nnoremap <silent><F11> :tabnext<CR>

" NEXT BUFFER                                           SHIFT + F11
nnoremap <silent><S-F11> :bnext!<CR>

" SPLIT WINDOW LEFT|RIGHT                               F12
nnoremap <silent><F12> :vsplit<CR>

" TOGGLE SPLIT UP DOWN | LEFT RIGHT                     SHIFT + F12
nnoremap <silent><S-F12> :call ToggleSplit()<CR>

" BLOCK VISUAL                                          SHIFT + ALT + UP
"                                                       SHIFT + ALT + DOWN
nnoremap <silent><s-a-up> <c-v>
nnoremap <silent><s-a-down> <c-v>

" PAGE UP|DOWN                                          PAGE UP|DOWN
inoremap <silent><pageup> <ESC><c-u>i
inoremap <silent><pagedown> <ESC><c-d>i

" INDENT                                                TAB
nnoremap <Tab> >>
vnoremap <Tab> > <CR>gv

" OUTDENT                                               SHIFT + TAB
nnoremap <S-Tab> <<
vnoremap <S-Tab> < <CR>gv

" ALWAYS INSERT REAL TAB                                CTRL + TAB
inoremap <C-Tab> <C-Q><Tab>
nnoremap <C-Tab> i<C-Q><Tab>


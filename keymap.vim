
# MOVE LINE DOWN                                        ALT + DOWN
inoremap <A-DOWN> <ESC>:m+<CR>:startinsert<CR>
nn <A-DOWN> :m+<CR>==
vnoremap <A-DOWN> :m '>+1<CR>gv=gv

# MOVE LINE UP                                          ALT + UP
inoremap <A-UP> <ESC>:m-2<CR>:startinsert<CR>
nn <A-UP> :m-2<CR>==
vnoremap <A-UP> :m '<-2<CR>gv=gv

# PREVIOUS TAB                                          CTRL + LEFT
# NEXT TAB                                              CTRL + RIGHT
nn <silent><C-LEFT> :tabprev<CR>
nn <silent><C-RIGHT> :tabnext<CR>

# RESIZE SPLIT                                          ALT + LEFT
#                                                       ALT + RIGHT
nn <A-LEFT> 20<C-w><
nn <A-RIGHT> 20<C-w>>

# TOGGLE NERDTREE                                       CTRL + UP
nn <silent><C-UP> :NERDTreeToggle<CR>

# SAVE FILE                                             CTRL + S
inoremap <C-S> <ESC> :w<CR>i
nn <C-S> :w<CR>

# SORT BLOCK                                            CTRL + S
vnoremap <silent><C-S> :'<,'>sort<CR>gv

# CURSOR HOME SELECT                                    SHIFT + HOME
inoremap <silent><S-HOME> <ESC>v<HOME>
nn <silent><S-HOME> <ESC>v<HOME>

# CURSOR END SELECT                                     SHIFT + END
inoremap <silent><S-END> <ESC>v<END>
nn <silent><S-END> <ESC>v<END>

# SELECT ALL                                            CTRL + A
nn <silent><C-A> :norm GVgg<CR>

# COPY                                                  CTRL + C
vnoremap <C-C> "+y
vnoremap y "+y

# CUT                                                   CTRL + X
vnoremap <C-X> "+x
vnoremap x "+x

# PASTE                                                 CTRL + V
vnoremap <silent>p "+p
vnoremap <silent>P "+P
nn <silent>p "+p
nn <silent>P "+P

# RESERVED (CODE HELPER)                                F3
nn <silent><F3> :bd<CR>
nn <silent><S-F3> :bd!<CR>

# LAUNCH NEW INSTANCE                                   F9
nn <silent><F9> :sil !gvim&<CR>

# ROTATE WINDOWS RIGHT/LEFT                             F10
nn <F10> <C-W>x

# NEXT TAB                                              F11
nn <silent><F11> :tabnext<CR>

# NEXT BUFFER                                           SHIFT + F11
nn <silent><S-F11> :bnext!<CR>

# SPLIT WINDOW LEFT|RIGHT                               F12
nn <silent><F12> :vsplit<CR>

# BLOCK VISUAL                                          SHIFT + ALT + UP
#                                                       SHIFT + ALT + DOWN
nn <silent><s-a-up> <c-v>
nn <silent><s-a-down> <c-v>

# PAGE UP|DOWN                                          PAGE UP|DOWN
inoremap <silent><pageup> <ESC><c-u>i
inoremap <silent><pagedown> <ESC><c-d>i

# INDENT                                                TAB
nn <Tab> >>
vnoremap <Tab> > <CR>gv

# OUTDENT                                               SHIFT + TAB
nn <S-Tab> <<
vnoremap <S-Tab> < <CR>gv

# ALWAYS INSERT REAL TAB                                CTRL + TAB
inoremap <C-Tab> <C-Q><Tab>
nn <C-Tab> i<C-Q><Tab>




def! s:buf_tab(title: string): number
    if bufexists(title)
        sil exe 'bwipeout! ' .. bufnr(title)
    endif
    sil exe 'tabe ' .. title
    setl buftype=nofile
    setl noswapfile
    norm gg
    retu tabpagenr()
enddef


def! s:hell(args: list<any>): string
    let cmd = call('printf', args)
    retu system(cmd)
enddef

def! s:hell_tab(title: string, args: list<any>): void
    if bufexists(title)
        sil exe 'bwipeout! ' .. bufnr(title)
    endif
    sil exe 'tabnew ' .. title
    setl buftype=nofile
    setl noswapfile
    sil exe '-1read !' .. call('printf', args)
    norm gg
enddef

def! GotoDefinition(): void
    let path = expand("<cfile>")
    if filereadable(path)
        sil exe printf('e! %s', path)
    endif
    # else
    # OmniSharpGotoDefinition()
enddef

" GOTO FILE > DEFINITION                                F4
nnoremap <silent><F4> :call GotoDefinition()<CR>
nnoremap <silent><S-F4> :call FindInFiles('<cword>')<CR>


def! s:MakeTabBuffer(title: string): void
    if bufexists(title)
        sil exe 'bwipeout! ' .. bufnr(title)
    endif
    sil exe 'tabnew ' .. title
    setl buftype=nofile
    setl noswapfile
    norm gg
enddef

"
" CREATE A BUFFER WITH TITLE, REPLACE IF EXITS
"
def! s:NewOrReplaceBuffer(title: string): void
    if bufexists(title)
        sil exe 'bwipeout! ' .. bufnr(title)
    endif
    let bufnr = bufadd(title)
    bufload(bufnr)
    sil exe printf("%db", bufnr)
    setl buflisted
    setl buftype=nofile
    setl noswapfile
enddef

function! s:notrails()
    let _s=@/
    :%s/\s\+$//e
    let @/=_s
    nohl
    unlet _s
endfunction

def! s:longest(rows: list<list<string>>, col: number, min: number, max: number ): number
    let c = min
    for r in rows
        let len = strchars(r[col])
        if len > c
            c = len
            if c > max
                retu max
            endif
        endif
    endfor
    retu c
enddef

def! s:ortd()
    norm gv
    :'<,'>sort!
    norm gv
enddef

def! s:ortdi()
    norm gv
    :'<,'>sort! i
    norm gv
enddef

def! s:ort()
    norm gv
    :'<,'>sort
    norm gv
enddef

def! s:orti()
    norm gv
    :'<,'>sort i
    norm gv
enddef

def! s:hell(args: list<string>): string
    let cmd = call('printf', args)
    retu system(cmd)
enddef


def! s:unique(): void
    norm gv
    :'<,'>%!uniq
    norm gv
enddef



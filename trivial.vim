
" CREATE A SYNTAX REGION STARTING/ENDING ON A COLUMN OR LINE
def! Region(grp: string, x: number, y: number, t = 'c', extra = 'contained display oneline')
    let f = 'sy region %s start="%s" end="%s" %s'
    let z = x + y
    exe printf(f, grp, '\%' .. x .. t, '\%' .. z .. t, extra)
enddef

" RETURN X OR THE LENGTH OF VAL; WHICHEVER IS GREATER
def! AddIf(x: number, val: string): number
    let y = strchars(val)
    return y > x ? y : x
enddef

" APPEND Y TO X IF IT DOES NOT EXIST; OTHERWISE X
def! Appendif(x: string, y: string): string
    return stridx(x, y) >= 0 ? x : printf('%s %s', x, y)
enddef

def! FindInFile(val: string)
    exe printf("sil grep! -rni  '%s' *", val)
    copen 35
enddef
command! -nargs=1 Find :cal <SID>FindInFile('<args>')

def! Hide(h: number)
    setbufvar(h, '&buflisted', '0')
    setbufvar(h, '&buftype', 'nofile')
    setbufvar(h, '&swapfile', '0')
enddef

def! NoTabs()
    update
    setl expandtab
    retab
    update
enddef

def! NoTrails()
    :%s/\s\+$//e
enddef

def! Lower()
    norm gvugv
enddef

def! Rename(): void
    let val = input('Value: ')
    if '' != val
        exe '%s/' .. expand('<cword>') .. '/' .. val .. '/g'
    endif
enddef
nnoremap <silent><F2> :cal <SID>Rename()<CR>

let s:orient = 'H'
def! Rotate()
    s:orient = s:orient == 'H' ? 'K' : 'H'
    exe 'wincmd ' .. s:orient
enddef
nnoremap <silent><S-F12> :cal <SID>Rotate()<CR>

def! Say(h: number, msg: any)
    let c = get(get(getbufinfo(h), 0), 'linecount')
    let l = strchars(get(getbufline(h, '$'), 0))
    appendbufline(h, l > 1 ? c : c - 1, msg)
enddef

def! SayCallback(h: number, chan: number, msg: string)
    Say(h, msg)
enddef

def! SayShell(h: number, cmd: string)
    let f = funcref("s:SayCallback", [h])
    job_start(cmd, #{out_cb: f, err_cb: f})
enddef

def! SourceFile()
    up
    so %
enddef
nnoremap <silent><S-F5> :cal <SID>SourceFile()<CR>

def! Sort()
    norm gv
    :'<,'>sort
    norm gv
enddef

def! SortD()
    norm gv
    :'<,'>sort!
    norm gv
enddef

def! SortDI()
    norm gv
    :'<,'>sort! i
    norm gv
enddef

def! SortI()
    norm gv
    :'<,'>sort i
    norm gv
enddef

def! Startup()
    if filereadable('session.vim')
        so session.vim
    endif
enddef
au VimEnter * ++once : cal Startup()

def! ToCrlf()
   up
   :e ++ff=unix
   setl ff=dos
   up
enddef

def! ToLf()
    up
    :e ++ff=dos
    setl ff=unix
    up
enddef

def! Unique()
    norm gv
    :'<,'>%!uniq
    norm gv
enddef

def! Upper()
    norm gvUgv
enddef

def! VimDir(): string
    retu has('linux') ? $HOME .. '/.vim/' : $HOME .. '/vimfiles/'
enddef

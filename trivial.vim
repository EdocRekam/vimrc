
def! Chomp(msg: string): string
    retu strcharpart(msg, 0, strchars(msg) - 1)
enddef

def! FindInFile(val: string)
    exe printf("sil grep! -rni  '%s' *", val)
    copen 35
enddef
command! -nargs=1 Find :cal <SID>FindInFile('<args>')

def! NoTabs()
    update
    setl expandtab
    retab
    update
enddef

def! Lower()
    norm gvugv
enddef

def! SourceFile()
    exe 'w'
    exe 'so %'
enddef
nnoremap <silent><S-F5> :cal <SID>SourceFile()<CR>

def! Rename(): void
    let val = input('Value: ')
    exe '%s/' .. expand('<cword>') .. '/' .. val .. '/g'
enddef
nnoremap <silent><F2> :cal <SID>Rename()<CR>

let s:orient = 'H'
def! Rotate()
    s:orient = s:orient == 'H' ? 'K' : 'H'
    exe 'wincmd ' .. s:orient
enddef
nnoremap <silent><S-F12> :cal <SID>Rotate()<CR>

def! Startup()
    if filereadable('session.vim')
        exe 'so session.vim'
    endif
enddef
au VimEnter * ++once : cal Startup()

def! ToCrlf()
   :up
   :e ++ff=unix
   setl ff=dos
   :up
enddef

def! ToLf()
    :up
    :e ++ff=dos
    setl ff=unix
    :up
enddef

def! Upper()
    norm gvUgv
enddef

def! VimDir(): string
    retu has('linux') ? $HOME .. '/.vim/' : $HOME .. '/vimfiles/'
enddef

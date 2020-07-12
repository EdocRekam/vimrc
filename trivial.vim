
def! s:chomp(msg: string): string
    retu strcharpart(msg, 0, strchars(msg) - 1)
enddef

def! s:findfile(val: string)
    exe printf('grep! -rn  %s *', val)
    copen 35
enddef
command! -nargs=1 Find cal <SID>findfile('<args>')

def! s:notabs()
    update
    setl expandtab
    retab
    update
enddef

def! s:lower()
    norm gvugv
enddef

def! s:ource_file()
    exe 'w'
    exe 'so %'
enddef
nnoremap <silent><S-F5> :cal <SID>ource_file()<CR>

def! s:rename(): void
    let val = input('Value: ')
    exe '%s//' .. val .. '/g'
enddef
nnoremap <silent><F2> :cal <SID>rename()<CR>

let s:orient = 'H'
def! s:rotate()
    s:orient = s:orient == 'H' ? 'K' : 'H'
    exe 'wincmd ' .. s:orient
enddef
nnoremap <silent><S-F12> :cal <SID>rotate()<CR>

def! s:tartup()
    if filereadable('session.vim')
        exe 'so session.vim'
    endif
enddef
au VimEnter * ++once :cal <SID>tartup()

def! s:tocrlf()
   :up
   :e ++ff=unix
   setl ff=dos
   :up
enddef

def! s:tolf()
    :up
    :e ++ff=dos
    setl ff=unix
    :up
enddef

def! s:upper()
    norm gvUgv
enddef

def! s:vim_dir(): string
    retu has('linux') ? $HOME .. '/.vim/' : $HOME .. '/vimfiles/'
enddef

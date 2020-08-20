def DotnetAsyncWin(cmd = '', title = '', msg = '')
    let h = OpenWin(title, 0)
    Say(h, msg)
    SayEx(h, cmd)
    setbufvar(h, '&colorcolumn', '0')
enddef

# DOTNET BUILD
def F2()
    DotnetAsyncWin('dotnet build', 'DOTNET', 'Building . . .')
    sy case ignore
    sy match Caution "\d\+\sWarn.*"
    sy match Bad "\d\+\sError.*"
    hi Caution guifg=#eed320
    hi Bad guifg=#ee3020
enddef

# DOTNET RESTORE
def F3()
    DotnetAsyncWin('dotnet restore', 'DOTNET', 'Restoring . . .')
enddef

# POPUP FUNCTIONS
def F21()
    setf cs
    setl expandtab
    setl ff=unix
    setl fileencoding=utf-8
    setl nobomb
    setl shiftwidth=4
    setl softtabstop=4
    setl tabstop=4
enddef

# RUN ALL DOTNET UNIT TESTS
def F29(filter = '')
    let cmd: string
    if filter == ''
        cmd = 'dotnet test'
    else
        cmd = printf("dotnet test --filter '%s'", filter)
    en
    DotnetAsyncWin(cmd, 'DOTNET', 'Testing . . .')
    sy case ignore
    sy match Bad "Failed:\s\d\+"
    sy match Good "Passed:\s\d\+"
    hi Bad guifg=#ee3020
    hi Good guifg=#00b135
enddef

# DISABLE CSHARP CODE FOLDING
def F40()
    setl nofoldenable
    setl foldcolumn=0
    setl foldmethod=manual
enddef

def g:CsFoldText(): string
    retu getline(v:foldstart)
enddef

def g:CsIndent(n = 0): any
    let l = getline(n)
    if char2nr('n') == strgetchar(l, 0)
        retu '>1'
    en
    retu 1
enddef

# TURN ON CSHARP CODE FOLDING
def F39()
    setl foldlevel=1
    setl fillchars+=fold:\
    setl foldcolumn=1
    setl foldmethod=expr
    setl foldexpr=CsIndent(v:lnum)
    setl foldtext=CsFoldText()
    setl foldenable
enddef

# XML
autocmd! filetypedetect BufNewFile,BufRead *.csproj setf xml
autocmd! filetypedetect BufNewFile,BufRead *.props setf xml
autocmd! filetypedetect BufNewFile,BufRead *.targets setf xml

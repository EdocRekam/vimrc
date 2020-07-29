# OMNISHARP - GENERAL
g:OmniSharp_server_path = '/usr/local/bin/omnisharp'
g:OmniSharp_server_install = '/usr/local/lib64/omnisharp-roslyn'
g:OmniSharp_server_stdio = 1
g:OmniSharp_start_server = 0
g:OmniSharp_timeout = 5

# OMNISHARP - HIGHLIGHTING
g:OmniSharp_highlighting = 2
g:OmniSharp_hightlight_types = 3
g:omnicomplete_fetch_full_documentation = 1

g:OmniSharp_highlight_groups = #{StringLiteral: 'String', XmlDocCommentText: 'Comment' }

# POPUP FUNCTIONS
def CsUse()
    setf cs
    setl expandtab
    setl ff=unix
    setl fileencoding=utf-8
    setl nobomb
    setl shiftwidth=4
    setl softtabstop=4
    setl tabstop=4
enddef

def DotnetAsyncWin(cmd: string, title: string, msg: string)
    let h = OpenWin(title, 0)
    Say(h, [msg, cmd])
    SayShell(h, cmd)
    setbufvar(h, '&colorcolumn', '0')
enddef

def DotnetRestore()
    DotnetAsyncWin('dotnet restore', 'DOTNET', 'Restoring . . .')
enddef

def DotnetBuild()
    DotnetAsyncWin('dotnet build', 'DOTNET', 'Building . . .')
    sy case ignore
    sy match Caution "\d\+\sWarn.*"
    sy match Bad "\d\+\sError.*"
    hi Caution guifg=#eed320
    hi Bad guifg=#ee3020
enddef

def DotnetTest(filter: string = '')
    let cmd: string
    if filter == ''
        cmd = 'dotnet test'
    else
        cmd = printf("dotnet test --filter '%s'", filter)
    endif
    DotnetAsyncWin(cmd, 'DOTNET', 'Testing . . .')
    syn case ignore
    syn match Bad "Failed:\s\d\+"
    syn match Good "Passed:\s\d\+"
    hi Bad guifg=#ee3020
    hi Good guifg=#00b135
enddef

def CsNoFold()
    setl nofoldenable
    setl foldcolumn=0
    setl foldmethod=manual
enddef

def g:CsFoldText(): string
    retu getline(v:foldstart)
enddef

def g:CsIndent(n: number): any
    let l = getline(n)
    if char2nr('n') == strgetchar(l, 0)
        retu '>1'
    endif
    retu 1
enddef

def CsFold()
    setl foldlevel=1
    setl fillchars+=fold:\
    setl foldcolumn=1
    setl foldmethod=expr
    setl foldexpr=CsIndent(v:lnum)
    setl foldtext=CsFoldText()
    setl foldenable
enddef

def CsStartServer()
enddef

# XML
autocmd! filetypedetect BufNewFile,BufRead *.csproj setf xml
autocmd! filetypedetect BufNewFile,BufRead *.props setf xml
autocmd! filetypedetect BufNewFile,BufRead *.targets setf xml

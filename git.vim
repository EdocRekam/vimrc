
nnoremap <silent><F6> :sil !git gui&<CR>

def! GColor()
    sy case ignore
    sy keyword Comment boron carbon dublin ede havana herne hilla hobart
    sy keyword Comment hofu freetown master ibaraki
    sy keyword DiffAdd added
    sy keyword DiffDelete deleted
    sy keyword Keyword arc head
    sy keyword Function architect edoc happy hector ioan jjoker rekam radu
    sy keyword Keyword anna hub origin remotes usb vso
    sy keyword String x86 x64 anycpu
    sy keyword LightBlue commit merge author date branch subject tag tree
    sy keyword Identifier add branch checkout clean close commit del fetch git gitk gui log menu push refresh reset status unstage
    sy region Good start="^\t" end="$" contains=@NoSpell oneline
    sy region String start="<" end=">" contains=@NoSpell oneline
    sy region String start="`" end="`" contains=@NoSpell oneline
    sy region String start='"' end='"' contains=@NoSpell oneline
    sy region Keyword start="\s.*/" end="\s" contains=@NoSpell oneline
    sy match String "\d\+-\d\+-\d\+"
    sy match Keyword "\d\+\.\d\+"
    sy match Keyword "\d\+\.\d\+\.\d\+"
    sy match Keyword "\d\+\.\d\+\.\d\+\.\d\+"
    sy match Keyword "\d\+\.\d\+\.\d\+\.\d\+\.\d\+"
    sy match Identifier "#\=\d\{5}"
    sy match Keyword "[0-9a-f]\{7,8}" contains=@NoSpell
    hi LightBlue guifg=#9cdcfe
    hi Bad  guifg=#ee3020
    hi Good guifg=#00b135
enddef

let g:head = 'HEAD'
def! GHead(): string
    g:head = trim(system('git rev-parse --abbrev-ref HEAD'))
    retu g:head
enddef

def! GWin(cmd: string, title: string, msg: string)
    let h = OpenWin(title, 0)
    Say(h, [msg, cmd])
    SayShell(h, cmd)
enddef

def! GitK()
    let pat = expand('<cfile>')
    if filereadable(pat)
        exe printf("sil !gitk -- '%s'& ", pat)
    elsei strchars(pat) > 0
        exe printf("sil !gitk %s&", pat)
    else
        exe "sil !gitk&"
    endif
enddef
nnoremap <silent><S-F7> :cal <SID>GitK()<CR>


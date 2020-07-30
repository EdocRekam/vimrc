
# REMOTES
let R = 'hub origin vso'
def GRemotes()
    for r in systemlist('git remote')
        R = Appendif(R, r)
    endfor
enddef

# IS REMOTE
def IsR(r: string): bool
    retu -1 != stridx(R, r)
enddef

# AUTHORS
let A = 'edoc rekam'

# LAUNCH GIT GUI
nnoremap <silent><F6> :sil !git gui&<CR>

let GKeys = 'head master'
def GColor()
    sy case ignore

    # COMMENTS
    sy match Comment "^\s\s\s\s.*$" contains=L,P,K

    # DATE
    sy match D "\d\d\d\d-\d\d-\d\d"

    # LINKS - SHA OR []
    sy match L "[0-9a-f]\{40}" contains=@NoSpell display
    sy match L "#\=\d\{5}" contains=@NoSpell display contained
    sy region L start="\[" end="\]" contains=@NoSpell display oneline contained

    # MENU COMMANDS
    sy keyword MC add all branch checkout clean close commit contained create cursor delete fetch gitk gui inspect log menu push prune refresh reset restore status tags under unstage

    # KEYWORDS
    sy keyword Function x86 x64 anycpu

    # PAIRS
    sy region P start="<" end=">" contains=@NoSpell display oneline
    sy region P start="`" end="`" contains=@NoSpell display oneline
    sy region P start='"' end='"' contains=@NoSpell display oneline

    # AUTHORS
    exe 'sy keyword A ' .. A

    # COMMON LINKS - THESE SHOW UP ON A REGULAR BASIS
    exe 'sy keyword K ' ..  GKeys

    # REMOTES
    exe 'sy keyword R ' .. R

    # VERSION STRING
    # sy match String "\d\+\.\d\+"

    # sy match String "\d\+-\d\+-\d\+"
    # sy match Keyword "\d\+\.\d\+"
    # sy match Keyword "\d\+\.\d\+\.\d\+"
    # sy match Keyword "\d\+\.\d\+\.\d\+\.\d\+"
    # sy match Keyword "\d\+\.\d\+\.\d\+\.\d\+\.\d\+"

    # COLORS
    #  A    AUTHORS
    #  B    BRANCH
    #  C    COMMIT
    #  D    DATE
    #  F    FILE
    #  K    KEYWORDS
    #  L    LINK
    #  LBL  LABEL
    #  MK   MENU COMMAND
    #  MK   MENU KEY
    #  P    PAIRS
    #  R    REMOTE
    #  S    SUBJECT
    #  TC   TREE + COMMIT
    hi link A Function
    hi link B Keyword
    hi link C Keyword
    hi link D String
    hi link F Keyword
    hi link K Keyword
    hi link L Keyword
    hi link LBL Identifier
    hi link LOG Comment
    hi link MK String
    hi link P String
    hi link R Keyword
    hi link S Comment
    hi link TC Keyword
enddef

def GHead(): string
    Head = trim(system('git rev-parse --abbrev-ref HEAD'))
    GKeys = Appendif(GKeys, Head)
    GRemotes()
    retu Head
enddef

def GWin(cmd: string, title: string, msg: string)
    let h = OpenWin(title, 0)
    Say(h, [msg, cmd])
    SayShell(h, cmd)
enddef

def GitK()
    let pat = expand('<cfile>')
    if filereadable(pat)
        exe printf("sil !gitk -- '%s'& ", pat)
    elsei strchars(pat) > 0
        exe printf("sil !gitk %s&", pat)
    else
        exe "sil !gitk&"
    en
enddef
nnoremap <silent><S-F7> :cal <SID>GitK()<CR>


def MapClose(hT: number, hB: number)
    win_execute(win_getid(1), printf("nnoremap <silent><buffer><F3> :exe 'sil bw! %d %d'<CR>", hT, hB))
    win_execute(win_getid(2), printf("nnoremap <silent><buffer><F3> :exe 'sil bw! %d %d'<CR>", hT, hB))
enddef

def MapKey(hT: number, hB: number, k: string, f: string)
    exe printf('nnoremap <silent><buffer><%s> :sil cal <SID>%s(%d, %d)<CR>', k, f, hT, hB)
enddef


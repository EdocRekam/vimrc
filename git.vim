
nnoremap <silent><F6> :sil !git gui&<CR>

def! GColor()
    sy case ignore

    # COMMENTS
    sy match S "^\s\s\s\s.*$" contains=L,P,K

    # LINKS - SHA OR []
    sy match L "[0-9a-f]\{40}" contains=@NoSpell display
    sy match L "#\=\d\{5}" contains=@NoSpell display contained
    sy region L start="\[" end="\]" contains=@NoSpell display oneline contained

    # MENU COMMANDS
    sy keyword MC add all branch checkout clean close commit contained create cursor delete fetch gitk gui inspect log menu push prune refresh reset restore status tags under unstage

    # KEYWORDS
    sy keyword K x86 x64 anycpu contained

    # PAIRS
    sy region P start="<" end=">" contains=@NoSpell display oneline
    sy region P start="`" end="`" contains=@NoSpell display oneline
    sy region P start='"' end='"' contains=@NoSpell display oneline

    # sy keyword Comment hofu freetown master ibaraki
    # sy keyword DiffAdd added
    # sy keyword DiffDelete deleted
    # sy keyword Keyword arc head
    # sy keyword LightBlue commit merge author date branch subject tag tree
    # sy region Good start="^\t" end="$" contains=@NoSpell oneline
    # sy region Keyword start="\s.*/" end="\s" contains=@NoSpell oneline
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
    hi link MK String
    hi link P String
    hi link R Keyword
    hi link S Comment
    hi link TC Keyword
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


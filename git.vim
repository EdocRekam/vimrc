# MAP F3 KEY TO CLOSE TOP AND BOTTOM WINDOW AND DELETE BUFFERS
# ASSOCIATED WITH THEM
def G0(hT: number, hB: number)
    let f = "no <silent><buffer><F3> :sil bw! %d %d<CR>"
    win_execute(win_getid(1), printf(f, hT, hB))
    win_execute(win_getid(2), printf(f, hT, hB))
enddef

# COMMON KEY MAPPING USED IN GIT FUNCTIONS
def G1(hT: number, hB: number, k: string, f: string)
    win_execute(win_getid(1), printf('nn <silent><buffer><%s> :sil cal <SID>%s(%d, %d)<CR>', k, f, hT, hB))
enddef

# GENERALLY SYNTAX HIGHLIGHTING WORKS A LOT FASTER WITH A BUNCH OF
# KEYWORDS INSTEAD OF REGULAR EXPRESSIONS. MY GIT FUNCTIONS BUILD UP
# THESE SYNTAX KEYWORDS OVER TIME WHEN RUNNING DIFFERENT FUNCTIONS SO
# THAT I CAN HIGHLIGHT CERTAIN TERMS ON PAGES THAT LACK ENOUGH INFORMATION
# TO FIGURE OUT THE TERMS.
#
# FOR EXAMPLE:
# BRANCH NAMES MAY BE REFERENCED IN GIT LOG MESSAGES. I WANT TO HIGHLIGHT
# THESE BRANCH NAMES. I HOWEVER HAVE NO CLUE WHICH ARE BRANCH NAMES FROM
# THE LOGS ALONE. I CAN FIND BRANCH NAMES FROM THE BRANCH FUNCTION THOUGH
# AND THE NEXT TIME I DISPLAY A LOG THESE BRANCHES ARE HIGHLIGHTED.
#
# SYNTAX GROUPS THAT I TRACK:
#     (A)UTHORS
#     (B)RANCHES
#     (R)EMOTES

let A = 'edoc rekam'
let B = 'head master'
let R = 'hub origin vso'

# SPLIT BRANCH STRING INTO PARTS. ADD EACH PART AS REMOTE
# vso/1.1 -> ['vso', '1.1']
def Ab(val: string)
    for p in split(val, '[/]')
        B = T4(B, p)
    endfo
enddef

# REMOTES
def GRemotes()
    for r in S('git remote')
        R = T4(R, r)
    endfo
enddef

# IS REMOTE
def IsR(r: string): bool
    retu -1 != stridx(R, r)
enddef

# Sr - TrimRemoteName
# TRIM THE LEADING REMOTE TEXT FROM THE SPECIFIED BRANCH NAME
def Sr(b: string): string
    let p = get(split(b, '/'), 0)
    if IsR(p)
        retu Sr(strcharpart(b, strchars(p) + 1))
    en
    retu b
enddef

# LAUNCH GIT GUI
nn <silent><F6> :cal job_start('git gui')<CR>

def G7()
    sy case ignore

    # COMMENTS
    sy match Comment "^\s\s\s\s.*$" contains=L,P,K

    # PAIRS
    sy region P start="\[" end="\]" contains=@NoSpell,L contained display oneline
    sy region P start="(" end=")" contains=@NoSpell,L contained display oneline
    sy region P start="<" end=">" contains=@NoSpell contained display oneline
    sy region P start="`" end="`" contains=@NoSpell contained display oneline
    sy region P start='"' end='"' contains=@NoSpell contained display oneline

    # DATE
    sy match D "\d\d\d\d-\d\d-\d\d"

    # LINKS - SHA OR TFS
    sy match L "#[0-9]\{5}" contains=@NoSpell contained display oneline
    sy match L "[0-9a-f]\{40}" contains=@NoSpell contained display oneline

    # MENU COMMANDS
    sy keyword MC add all amend branch checkout clean close commit contained create cursor delete fetch gitk gui inspect log menu push prune refresh reset restore status tags under unstage

    # KEYWORDS
    sy keyword Function anycpu x86 x64

    # ORDER SPECIFIC
    sy keyword A A
    sy keyword B B
    sy keyword R R
    sy clear A B R
    exe 'sy keyword B ' .. B
    exe 'sy keyword R ' .. R
    exe 'sy keyword A ' .. A

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

def G8(): string
    Head = trim(system('git rev-parse --abbrev-ref HEAD'))
    Ab(Head)
    GRemotes()
    retu Head
enddef

def GWin(cmd: string, title: string, msg: string)
    let h = OpenWin(title, 0)
    Say(h, [msg, cmd])
    SayEx(h, cmd)
enddef

# LAUNCH GITK USING FILE UNDER CURSOR
def GitK()
    let p = T1()
    let c = 'gitk'

    if filereadable(p)
        c = c .. ' -- ' .. p
    elsei strchars(p) > 0
        c = c .. ' ' .. p
    en
    job_start(c)
enddef
T0('S-F7', 'GitK')




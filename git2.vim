
def! s:git_colors(): void
    syn case ignore
    syn keyword Comment boron carbon dublin ede havana herne hilla hobart
    syn keyword Comment hofu freetown master ibaraki
    syn keyword DiffAdd added
    syn keyword DiffDelete deleted
    syn keyword Keyword arc head
    syn keyword Function architect edoc happy hector jjoker rekam
    syn keyword Keyword hub origin remotes usb vso
    syn keyword String x86 x64 anycpu
    syn keyword LightBlue commit merge author date branch subject
    syn keyword Good modified
    syn region String start="<" end=">" contains=@NoSpell oneline
    syn region String start="`" end="`" contains=@NoSpell oneline
    syn region String start='"' end='"' contains=@NoSpell oneline
    syn region Keyword start="\s.*/" end="\s" contains=@NoSpell oneline
    syn match String "\d\+-\d\+-\d\+"
    syn match Keyword "\d\+\.\d\+"
    syn match Keyword "\d\+\.\d\+\.\d\+"
    syn match Keyword "\d\+\.\d\+\.\d\+\.\d\+"
    syn match Keyword "\d\+\.\d\+\.\d\+\.\d\+\.\d\+"
    syn match Identifier "#\=\d\{5}"
    syn match Keyword "[0-9a-f]\{7,8}" contains=@NoSpell
    syn match Function '^<.*' contains=@NoSpell
    hi LightBlue guifg=#9cdcfe
    hi Bad  guifg=#ee3020
    hi Good guifg=#00b135
enddef

let s:head = ''
def! s:git_head()
    s:head = s:chomp(system('git rev-parse --abbrev-ref HEAD'))
enddef

def! s:git_status()
    s:git_head()
    s:opentab('GIT')
    s:write_shell(['git status'])
    setline('$', [''
    \, '<INS> ADD ALL    <PGUP> PUSH'
    \, '<END> COMMIT     <PGDN> FETCH'
    \, '<F6>  GIT GUI    <F7>   GIT LOG (COMMIT UNDER CURSOR)'
    \, '<F8>  REFRESH', '', '', repeat('-', 80), ''])
    norm G
    s:write_shell(['git log -n5'])
    exe '%s/\s\+$//e'
    s:git_colors()
    setl colorcolumn=
    norm gg
    nnoremap <silent><buffer><END> :Gcommit<CR>
    nnoremap <silent><buffer><INS> :cal <SID>git_status_add()<CR>
    nnoremap <silent><buffer><PageDown> :cal <SID>git_status_fetch()<CR>
    nnoremap <silent><buffer><PageUp> :cal <SID>git_status_push()<CR>
    # nnoremap <silent><buffer><F7> :cal <SID>git_log(expand('<cword>'))<CR>
enddef
nnoremap <silent><F8> :cal <SID>git_status()<CR>

def! s:git_status_add()
    s:openwin_shell('SO', ['git add .'])
    s:git_status()
enddef

def! s:git_status_fetch()
    s:openwin_shell('SO', ['git fetch'])
    s:git_status()
enddef

def! s:git_status_push()
    s:openwin_shell('SO', ['git push'])
    s:git_status()
enddef




"
" GIT SYNTAX COLORING
"
function! s:GitColors()
    syn case ignore
    syn keyword Comment boron carbon dublin ede havana herne hilla hobart
    syn keyword Comment hofu freetown master ibaraki
    syn keyword DiffAdd added
    syn keyword DiffDelete deleted
    syn keyword Function arch architect edoc happy head hector jjoker rekam
    syn keyword Statement hub origin remotes usb vso
    syn keyword String x86 x64 anycpu
    syn region String start="`" end="`" contains=@NoSpell oneline
    syn region String start='"' end='"' contains=@NoSpell oneline
    syn match String "\d\+\.\d\+"
    syn match String "\d\+\.\d\+\.\d\+"
    syn match String "\d\+\.\d\+\.\d\+\.\d\+"
    syn match String "\d\+\.\d\+\.\d\+\.\d\+\.\d\+"
    syn match Identifier "#\=\d\{5}"
    syn match Keyword "[0-9a-f]\{7,8}" contains=@NoSpell
endfunction

function! GitDiffSummary(commit)
    call s:MakeTabBuffer(printf('SUMMARY: %s', a:commit))
    setlocal colorcolumn=

    let l:head = s:Chomp(s:Shell('git rev-parse --short HEAD'))
    call s:WriteLine('FILES %-84s %-8s  %-8s  %-8s  %s', a:commit, 'BEFORE', 'AFTER', l:head, 'COMPARE')
    call s:WriteLine(repeat('-', 160))

    let l:items = s:ShellList('git diff --numstat %s~1 %s', a:commit,a:commit)
    for l:item in l:items
        let l:stats = matchlist(l:item, '\(\d\+\)\s\(\d\+\)\s\(.*\)')
        let l:add = str2nr(stats[1])
        let l:del = str2nr(stats[2])
        let l:file = stats[3]

        let l:hist = s:ShellList("git log -n3 --pretty=%s %s -- '%s'", '%h', a:commit, l:file)
        if len(l:hist) == 1
            let l:before = 'ADDED'
            let l:after = a:commit
        elseif len(l:hist) == 2
            let l:before = l:hist[1]
            if l:add > 1
                let l:after = a:commit
            else
                call s:Shell("git show '%s:%s'", a:commit, l:file)
                if v:shell_error
                    let l:after = 'DELETED'
                else
                    let l:after = a:commit
                endif
            endif
        else
            let l:before = l:hist[1]
            if l:add > 1
                let l:after = a:commit
            else
                call s:Shell("git show '%s:%s'", a:commit, l:file)
                if v:shell_error
                    let l:after = 'DELETED'
                else
                    let l:after = a:commit
                endif
            endif
        endif

        " HEAD
        if filereadable(l:file)
            let l:current = l:head
        else
            let l:current = 'DELETED'
        endif

        call s:WriteLine('%-90s %-8s  %-8s  %-8s  B:A  B:H  A:H', l:file, l:before, l:after, l:current)
    endfor
    call s:WriteLine('')

    exe '3'
    call s:GitColors()
    syn region String start="\%>2l" end="\%90c" contains=@NoSpell oneline

    noremap <silent><buffer><2-LeftMouse> :call GitDiffSummaryGotoDefinition()<CR>
    nnoremap <silent><buffer><F4> :call GitDiffSummaryGotoDefinition()<CR>
    exe printf("nnoremap <silent><buffer><F5> :call GitDiffSummary('%s')<CR>", a:commit)
endfunction

function! GitDiffSummaryGotoDefinition()
    let l:col = col('.')
    let l:lnr = line('.')
    let l:lin = getline(l:lnr)

    " FILE
    let l:file = trim(strcharpart(l:lin, 0, 90))
    if l:col > 0 && l:col < 92
        if filereadable(l:file)
            silent exe printf('tabnew %s', l:file)
        endif

    " BEFORE
    elseif l:col > 91 && l:col < 102
        let l:before = trim(strcharpart(l:lin, 91, 8))
        call GitShowFile(l:before, l:file)

    " AFTER
    elseif l:col > 101 && l:col < 112
        let l:after  = trim(strcharpart(l:lin, 101, 8))
        call GitShowFile(l:after, l:file)

    " HEAD
    elseif l:col > 111 && l:col < 121
        let l:head = trim(strcharpart(l:lin, 111, 8))
        call GitShowFile(l:head, l:file)

    " BEFORE AFTER
    elseif l:col > 121 && l:col < 127
        let l:after  = trim(strcharpart(l:lin, 101, 8))
        let l:before = trim(strcharpart(l:lin, 91, 8))

        if l:before == 'DELETED' || l:after == 'DELETED'
            return
        endif

        call GitShowFile(l:after, l:file)
        let l:syntax = &syntax
        exe 'vsplit'
        call s:NewOrReplaceBuffer(printf('%s:%s', l:before, l:file))
        call s:WriteShell("git show '%s:%s'", l:before, l:file)
        if l:syntax
            exe printf('setf %s', l:syntax)
        endif
        exe 'windo diffthis'
        normal gg

    " BEFORE HEAD
    elseif l:col > 126 && l:col < 131
        let l:before = trim(strcharpart(l:lin, 91, 8))
        let l:head = trim(strcharpart(l:lin, 111, 8))
        if l:before == 'DELETED' || l:head == 'DELETED'
            return
        endif

        exe printf('tabnew %s', l:file)
        let l:syntax = &syntax
        exe 'vsplit'
        call s:NewOrReplaceBuffer(printf('%s:%s', l:before, l:file))
        call s:WriteShell("git show '%s:%s'", l:before, l:file)
        exe printf('setf %s', l:syntax)
        exe 'windo diffthis'
        normal gg

    " AFTER HEAD
    else
        let l:after  = trim(strcharpart(l:lin, 101, 8))
        let l:head   = trim(strcharpart(l:lin, 111, 8))
        if l:after == 'DELETED' || l:head == 'DELETED'
            return
        endif

        exe printf('tabnew %s', l:file)
        let l:syntax = &syntax
        exe 'vsplit'
        call s:NewOrReplaceBuffer(printf('%s:%s', l:after, l:file))
        call s:WriteShell("git show '%s:%s'", l:after, l:file)
        exe printf('setf %s', l:syntax)
        exe 'windo diffthis'
        normal gg
    endif
endfunction

function! GitFetch(remote)
    call s:ShellNewTab('FETCH', 'git fetch %s', a:remote)
    setlocal colorcolumn=
    syn case ignore
    syn match Bad "forced update"
    syn match Good "[new branch]"
    hi Bad guifg=#ee3020
    hi Good guifg=#00b135
endfunction

"
" DISPLAY GIT LOG HISTORY AND BRANCHES IN A NEW TAB
"
function! GitList(...)
    let l:branch = get(a:, 1, s:Chomp(system('git rev-parse --abbrev-ref HEAD')))

    call s:MakeTabBuffer(printf('LOG: %s', l:branch))
    call s:WriteLine('TREE      COMMIT    %-81s AUTHOR', l:branch)
    call s:WriteLine(repeat('-', 130))

    call s:WriteShell("git log -n75 --pretty=format:'%s' %s"
                \ ,'%<(8)%t  %<(8)%h  %<(80,trunc)%s  %<(16)%an  %as'
                \ ,l:branch)

    call s:WriteLine('')
    call s:WriteLine('TREE      COMMIT    TAG/REMOTE')
    call s:WriteLine(repeat('-', 130))

    let l:refs = s:ShellList('git rev-parse --short --tags --branches --remotes HEAD')
    call sort(l:refs)
    call uniq(l:refs)

    for l:ref in l:refs
         let l:msg = s:Shell("git log -n1 --pretty=format:'%s' %s", '%<(8)%t  %<(8)%h  %<(80,trunc)%D  %<(16)%an  %as', l:ref)
         call s:WriteLine(l:msg)
    endfor

    normal gg
    normal 21|
    setlocal colorcolumn=
    call s:GitColors()

    noremap <silent><buffer><2-LeftMouse> :call GitListGotoDefinition()<CR>
    nnoremap <silent><buffer><F4> :call GitListGotoDefinition()<CR>
    exe printf("nnoremap <silent><buffer><F5> :call GitList('%s')<CR>", l:branch)
endfunction

" JUMP TO A NEW LOCATION BASED ON CURSOR IN GITLIST
function! GitListGotoDefinition()
    let l:col = col('.')
    if l:col > 0 && l:col < 11
        call GitDiffSummary(expand('<cword>'))
    elseif l:col > 10 && l:col < 21
        call GitDiffSummary(expand('<cword>'))
    else
        call GitList(expand('<cfile>'))
    endif
endfunction

function! GitPrune(remote)
    call s:TabCommand('PRUNE', printf('git remote prune %s', a:remote))
endfunction

function! GitShowFile(commit, file)
    if a:commit == 'DELETED' || a:commit == 'ADDED'
        return
    endif

    let l:cmd = printf("git show '%s:%s'", a:commit, a:file)
    call s:ShellNewTab(printf('%s:%s', a:commit, a:file), l:cmd)
endfunction

function! GitStatus()
    call s:TabCommand('STATUS', 'git status')
    setf gitmisc
endfunction

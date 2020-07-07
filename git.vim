
function! s:git_checkout(ref)
    call s:shell('git checkout %s', a:ref)
    let g:head = s:chomp(s:shell('git rev-parse --short HEAD'))
endfunction

function! s:git_colors()
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
    hi Bad  guifg=#ee3020
    hi Good guifg=#00b135
endfunction

function! s:git_diff(commit)
    call s:MakeTabBuffer(printf('SUMMARY: %s', a:commit))
    setlocal colorcolumn=

    let g:head = s:chomp(s:shell('git rev-parse --short HEAD'))
    call s:write('FILES %-84s %-8s  %-8s  %-8s  %-14s %s', a:commit, 'BEFORE', 'AFTER', g:head, 'COMPARE', 'SIDE BY SIDE')
    call s:write(repeat('-', 160))

    let l:items = s:shell_list('git diff --numstat %s~1 %s', a:commit,a:commit)
    for l:item in l:items
        let l:stats = matchlist(l:item, '\(\d\+\)\s\(\d\+\)\s\(.*\)')
        let l:add = str2nr(stats[1])
        let l:del = str2nr(stats[2])
        let l:file = stats[3]

        let l:hist = s:shell_list("git log -n3 --pretty=%s %s -- '%s'", '%h', a:commit, l:file)
        if len(l:hist) == 1
            let l:before = 'ADDED'
            let l:after = a:commit
        elseif len(l:hist) == 2
            let l:before = l:hist[1]
            if l:add > 1
                let l:after = a:commit
            else
                call s:shell("git show '%s:%s'", a:commit, l:file)
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
                call s:shell("git show '%s:%s'", a:commit, l:file)
                if v:shell_error
                    let l:after = 'DELETED'
                else
                    let l:after = a:commit
                endif
            endif
        endif

        " HEAD
        if filereadable(l:file)
            let l:current = g:head
        else
            let l:current = 'DELETED'
        endif

        call s:write('%-90s %-8s  %-8s  %-8s  B:A  B:H  A:H  B-A  B-H  A-H', l:file, l:before, l:after, l:current)
    endfor
    call s:write('')

    exe '3'
    call s:git_colors()
    syn region String start="\%>2l" end="\%90c" contains=@NoSpell oneline

    noremap <silent><buffer><2-LeftMouse> :call <SID>git_diff_nav()<CR>
    nnoremap <silent><buffer><F4> :call <SID>git_diff_nav()<CR>
    exe printf("nnoremap <silent><buffer><F5> :call <SID>git_diff('%s')<CR>", a:commit)
endfunction

function! s:git_diff_nav()
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
        call s:git_show(l:before, l:file)

    " AFTER
    elseif l:col > 101 && l:col < 112
        let l:after  = trim(strcharpart(l:lin, 101, 8))
        call s:git_show(l:after, l:file)

    " HEAD
    elseif l:col > 111 && l:col < 121
        let l:head = trim(strcharpart(l:lin, 111, 8))
        call s:git_show(l:head, l:file)

    " BEFORE AFTER
    elseif l:col > 121 && l:col < 127
        let l:after = trim(strcharpart(l:lin, 101, 8))
        let l:before = trim(strcharpart(l:lin, 91, 8))

        if l:before == 'DELETED' || l:after == 'DELETED'
            return
        endif

        call s:git_show(l:after, l:file)
        let l:syntax = &syntax
        exe 'vsplit'
        call s:NewOrReplaceBuffer(printf('%s:%s', l:before, l:file))
        call s:write_shell("git show '%s:%s'", l:before, l:file)
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
        call s:write_shell("git show '%s:%s'", l:before, l:file)
        exe printf('setf %s', l:syntax)
        exe 'windo diffthis'
        normal gg

    " AFTER HEAD
    elseif l:col > 131 && l:col < 136
        let l:after = trim(strcharpart(l:lin, 101, 8))
        let l:head = trim(strcharpart(l:lin, 111, 8))
        if l:after == 'DELETED' || l:head == 'DELETED'
            return
        endif

        exe printf('tabnew %s', l:file)
        let l:syntax = &syntax
        exe 'vsplit'
        call s:NewOrReplaceBuffer(printf('%s:%s', l:after, l:file))
        call s:write_shell("git show '%s:%s'", l:after, l:file)
        exe printf('setf %s', l:syntax)
        exe 'windo diffthis'
        normal gg

    " SXS - BEFORE AFTER
    elseif l:col > 136 && l:col < 141
        let l:after = trim(strcharpart(l:lin, 101, 8))
        let l:before = trim(strcharpart(l:lin, 91, 8))

        if l:before == 'DELETED' || l:after == 'DELETED'
            return
        endif

        call s:git_show(l:after, l:file)
        let l:syntax = &syntax
        exe 'vsplit'
        call s:NewOrReplaceBuffer(printf('%s:%s', l:before, l:file))
        call s:write_shell("git show '%s:%s'", l:before, l:file)
        if l:syntax
            exe printf('setf %s', l:syntax)
        endif
        normal gg

    " SXS - BEFORE HEAD
    elseif l:col > 141 && l:col < 146
        let l:before = trim(strcharpart(l:lin, 91, 8))
        let l:head = trim(strcharpart(l:lin, 111, 8))
        if l:before == 'DELETED' || l:head == 'DELETED'
            return
        endif

        exe printf('tabnew %s', l:file)
        let l:syntax = &syntax
        exe 'vsplit'
        call s:NewOrReplaceBuffer(printf('%s:%s', l:before, l:file))
        call s:write_shell("git show '%s:%s'", l:before, l:file)
        exe printf('setf %s', l:syntax)
        exe 'windo diffthis'
        normal gg

    " SXS - AFTER HEAD
    else
        let l:after = trim(strcharpart(l:lin, 101, 8))
        let l:head = trim(strcharpart(l:lin, 111, 8))
        if l:after == 'DELETED' || l:head == 'DELETED'
            return
        endif

        exe printf('tabnew %s', l:file)
        let l:syntax = &syntax
        exe 'vsplit'
        call s:NewOrReplaceBuffer(printf('%s:%s', l:after, l:file))
        call s:write_shell("git show '%s:%s'", l:after, l:file)
        exe printf('setf %s', l:syntax)
        normal gg
    endif
endfunction

function! s:git_fetch(remote)
    call s:shell_tab('FETCH', 'git fetch %s', a:remote)
    setlocal colorcolumn=
    call s:git_colors()
    syn case ignore
    syn match Bad "forced update"
    syn match Good "[new branch]"
    hi Bad guifg=#ee3020
    hi Good guifg=#00b135
endfunction

"
" DISPLAY GIT LOG HISTORY AND BRANCHES IN A NEW TAB
"
function! s:git_log(...)
    let g:head = get(a:, 1, s:chomp(system('git rev-parse --abbrev-ref HEAD')))

    call s:MakeTabBuffer(printf('LOG: %s', g:head))
    call s:write('TREE      COMMIT    %-81s AUTHOR', g:head)
    call s:write(repeat('-', 130))

    call s:write_shell("git log -n75 --pretty=format:'%s' %s"
                \ ,'\%<(8)\%t  \%<(8)\%h  \%<(80,trunc)\%s  \%<(16)\%an  \%as'
                \ ,g:head)

    call s:write('')
    call s:write('TREE      COMMIT    TAG/REMOTE')
    call s:write(repeat('-', 130))

    let l:refs = s:shell_list('git rev-parse --short --tags --branches --remotes HEAD')
    call sort(l:refs)
    call uniq(l:refs)

    for l:ref in l:refs
         let l:msg = s:shell("git log -n1 --pretty=format:'%s' %s", '%<(8)%t  %<(8)%h  %<(80,trunc)%D  %<(16)%an  %as', l:ref)
         call s:write(l:msg)
    endfor

    normal gg
    normal 21|
    setlocal colorcolumn=
    call s:git_colors()

    noremap <silent><buffer><2-LeftMouse> :call <SID>git_log_nav()<CR>
    nnoremap <silent><buffer><F4> :call <SID>git_log_nav()<CR>
    exe printf("nnoremap <silent><buffer><F5> :call <SID>git_log('%s')<CR>", g:head)
endfunction

function! s:git_log_file(path)
    call s:MakeTabBuffer('TRACE')
    call s:write('COMMIT   %-80s DATE       AUTHOR', a:path)
    call s:write(repeat('-', 130))
    call s:write_shell("git log --pretty=format:'%s' -- '%s'"
                    \,'\%<(8)\%h \%<(80,trunc)\%s \%cs \%an'
                    \,a:path)

    exe '3'
    normal 1|
    setlocal colorcolumn=
    call s:git_colors()

    exe printf("noremap <silent><buffer><2-LeftMouse> :call <SID>git_trace_nav('%s')<CR>", a:path)
    exe printf("nnoremap <silent><buffer><F4> :call <SID>git_trace_nav('%s')<CR>", a:path)
    exe printf("nnoremap <silent><buffer><F5> :call <SID>git_log_file('%s')<CR>", a:path)
endfunction

function! s:git_trace_nav(path)
    call s:git_show(expand('<cword>'), a:path)
endfunction

" JUMP TO A NEW LOCATION BASED ON CURSOR IN GITLIST
function! s:git_log_nav()
    let l:col = col('.')
    if l:col > 0 && l:col < 11
        call s:git_diff(expand('<cword>'))
    elseif l:col > 10 && l:col < 21
        call s:git_diff(expand('<cword>'))
    else
        call s:git_log(expand('<cfile>'))
    endif
endfunction

function! s:git_prune(remote)
    call s:shell_tab('PRUNE', 'git remote prune %s', a:remote)
endfunction

function! s:git_show(commit, file)
    if a:commit == 'DELETED' || a:commit == 'ADDED'
        return
    endif

    let l:cmd = printf("git show '%s:%s'", a:commit, a:file)
    call s:shell_tab(printf('%s:%s', a:commit, a:file), l:cmd)
endfunction

function! s:git_status()
    call s:shell_tab('STATUS', 'git status')
    call s:git_colors()
    syn keyword Good modified
endfunction

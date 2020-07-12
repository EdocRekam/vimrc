
def! s:git_branch(): void
    s:git_head()
    s:opentab('GIT')
    let rs: list<list<string>>
    let hs = systemlist("git branch -a --format='%(objectname:short) %(refname)'")
    for h in hs
        let p = split(h)
        # p[1] = substitute(p[1], 'refs/remotes/', '', '')
        # p[1] = substitute(p[1], 'refs/heads/', '', '')
        let r = []
        add(r, p[0])
        add(r, p[1])
        p = split(s:chomp(system("git log -n1 --pretty='%as  %an  %s' " .. p[0])), '  ')
        add(r, p[2])
        add(r, p[0])
        add(r, p[1])
        add(rs, r)
    endfor
    let cl = s:longest(rs, 0, 7, 100)
    let bl = s:longest(rs, 1, 10, 100)
    let sl = s:longest(rs, 2, 7, 100)
    let f = '%-' .. cl .. 's  %-' .. bl .. 's  %-' .. sl .. 's  %-11s %-20s'
    let h = printf(f, 'COMMIT', 'BRANCH', 'SUBJECT', 'DATE', 'AUTHOR')
    let hl = strchars(h)
    s:write([h])
    s:write([repeat('-', hl)])
    for r in rs
        s:write([f, r[0], r[1], r[2], r[3], r[4] ])
    endfor
    setline('$', [''
    \, '<INS> ADD BRANCH   <HOME> CLEAN'
    \, '<DEL> DEL BRANCH   <END>  RESET (HARD)'
    \, '<F4>  CHECKOUT     <F5>   REFRESH', '', repeat('-', hl), ''])
    norm G
    s:write(['BRANCH: %s', g:head])
    s:write([''])
    s:write_shell(["git log -n5 HEAD"])
    sil exe '%s/\s\+$//e'
    exe printf('norm %s|', cl + 3)
    exe '3'
    s:git_colors()
    setl colorcolumn=
    nnoremap <silent><buffer><INS> :cal <SID>git_branch_new()<CR>
    nnoremap <silent><buffer><DEL> :cal <SID>git_branch_del()<CR>
    nnoremap <silent><buffer><HOME> :cal <SID>git_branch_clean()<CR>
    nnoremap <silent><buffer><END> :cal <SID>git_branch_reset()<CR>
    nnoremap <silent><buffer><F4> :cal <SID>git_branch_nav()<CR>
    nnoremap <silent><buffer><F5> :cal <SID>git_branch()<CR>
enddef

def! s:git_branch_clean(): void
    s:hell_win('BRANCH', ['git clean -xdf'])
    s:git_branch()
enddef

def! s:git_branch_nav(): void
    let col = col('.')
    if col > 0 && col < 12
        s:git_log(expand('<cword>'))
    elseif col > 10 && col < 80
        s:hell_win('BRANCH', ['git checkout %s', expand('<cfile>:t')])
        s:git_branch()
    endif
enddef

def! s:git_branch_new(): void
    s:hell_win('BRANCH', ['git branch %s', expand('<cfile>')])
    s:git_branch()
enddef

def! s:git_branch_reset(): void
    s:hell_win('BRANCH', ['git reset --hard %s', expand('<cfile>')])
    s:git_branch()
enddef

def! s:git_branch_del(): void
    s:hell_win('BRANCH', ['git branch -d %s', expand('<cfile>')])
    s:git_branch()
enddef

nnoremap <silent><F5> :cal <SID>git_branch()<CR>

def! s:git_checkout(ref: string): void
    s:git_head()
    s:hell(['git checkout %s', ref])
enddef


def! s:git_diff(ref: string): void
    s:MakeTabBuffer(printf('SUMMARY: %s', ref))
    setl colorcolumn=

    s:git_head()
    s:write(['FILES %-84s %-8s  %-8s  %-8s  %-14s %s', ref, 'BEFORE', 'AFTER', g:head, 'COMPARE', 'SIDE BY SIDE'])
    s:write([repeat('-', 160)])

    let after: string
    let before: string
    let deled: number
    let fil: string
    let foo: number
    let his: list<string>
    let lhist: number
    let stats: list<string>
    let items: list<string>

    items = s:hell_list(['git diff --numstat %s~1 %s', ref, ref])
    for item in items
        stats = matchlist(item, '\(\d\+\)\s\(\d\+\)\s\(.*\)')
        foo = str2nr(stats[1])
        deled = str2nr(stats[2])
        fil = stats[3]
        his = s:hell_list(["git log -n3 --pretty=%s %s -- '%s'", '%h', ref, fil])
        lhist = len(his)

        if lhist == 1
            before = 'ADDED'
            after = ref

        elseif lhist == 2
            before = his[1]
            "if foo > 1
                after = ref
            "else
                s:hell(["git show '%s:%s'", ref, fil])
                after = v:shell_error ? 'DELETED' : ref
            "endif

        else
            before = his[1]
            if foo > 1
                after = ref
            else
                s:hell(["git show '%s:%s'", ref, fil])
                after = v:shell_error ? 'DELETED' : ref
            endif
        endif

        let current = filereadable(fil) ? g:head : 'DELETED'
        s:write(['%-90s %-8s  %-8s  %-8s  B:A  B:H  A:H  B-A  B-H  A-H', fil, before, after, current])
    endfor
    s:write([''])
    exe '3'
    s:git_colors()
    syn region String start="\%>2l" end="\%90c" contains=@NoSpell oneline

    noremap <silent><buffer><2-LeftMouse> :cal <SID>git_diff_nav()<CR>
    nnoremap <silent><buffer><F4> :cal <SID>git_diff_nav()<CR>
    exe printf("nnoremap <silent><buffer><F5> :cal <SID>git_diff('%s')<CR>", ref)
enddef

def! s:git_diff_nav(): void
    let col = col('.')
    let lnr = line('.')
    let lin = getline(lnr)

    let before: string
    let after: string
    let head: string
    let syntax: string

    # FILE
    let file = trim(strcharpart(lin, 0, 90))
    if col > 0 && col < 92
        if filereadable(file)
            sil exe printf('tabnew %s', file)
        endif

    # BEFORE
    elseif col > 91 && col < 102
        before = trim(strcharpart(lin, 91, 8))
        s:git_show(before, file)

    # AFTER
    elseif col > 101 && col < 112
        after = trim(strcharpart(lin, 101, 8))
        s:git_show(after, file)

   # HEAD
   elseif col > 111 && col < 121
        head = trim(strcharpart(lin, 111, 8))
        s:git_show(head, file)

    " BEFORE AFTER
    elseif col > 121 && col < 127
        after = trim(strcharpart(lin, 101, 8))
        before = trim(strcharpart(lin, 91, 8))

       if before == 'DELETED' || after == 'DELETED'
           return
       endif

       s:git_show(after, file)
       syntax = &syntax
       exe 'vsplit'
       s:NewOrReplaceBuffer(printf('%s:%s', before, file))
       s:write_shell(["git show '%s:%s'", before, file])
       if syntax
           exe printf('setf %s', syntax)
       endif
       exe 'windo diffthis'
       norm gg

    # BEFORE HEAD
    #    elseif col > 126 && col < 131
    #        before = trim(strcharpart(lin, 91, 8))
    #        head = trim(strcharpart(lin, 111, 8))
    #        if before == 'DELETED' || head == 'DELETED'
    #            retu
    #        endif
    #
    #        exe printf('tabnew %s', file)
    #        syntax = &syntax
    #        exe 'vsplit'
    #        s:NewOrReplaceBuffer(printf('%s:%s', before, file))
    #        s:write_shell(["git show '%s:%s'", before, file])
    #        exe printf('setf %s', syntax)
    #        exe 'windo diffthis'
    #        norm gg

    # AFTER HEAD
    #    elseif col > 131 && col < 136
    #        after = trim(strcharpart(lin, 101, 8))
    #        head = trim(strcharpart(lin, 111, 8))
    #        if after == 'DELETED' || head == 'DELETED'
    #            return
    #        endif
    #
    #        exe printf('tabnew %s', file)
    #        syntax = &syntax
    #        exe 'vsplit'
    #        s:NewOrReplaceBuffer(printf('%s:%s', after, file))
    #        s:write_shell(["git show '%s:%s'", after, file])
    #        exe printf('setf %s', syntax)
    #        exe 'windo diffthis'
    #        norm gg

    # SXS - BEFORE AFTER
    #    elseif col > 136 && col < 141
    #        after = trim(strcharpart(lin, 101, 8))
    #        before = trim(strcharpart(lin, 91, 8))
    #
    #        if before == 'DELETED' || after == 'DELETED'
    #            return
    #        endif
    #
    #        s:git_show(after, file)
    #        syntax = &syntax
    #        exe 'vsplit'
    #        s:NewOrReplaceBuffer(printf('%s:%s', before, file))
    #        s:write_shell(["git show '%s:%s'", before, file])
    #        if syntax
    #            exe printf('setf %s', syntax)
    #        endif
    #        norm gg

    # SXS - BEFORE HEAD
    #    elseif col > 141 && col < 146
    #        before = trim(strcharpart(lin, 91, 8))
    #        head = trim(strcharpart(lin, 111, 8))
    #        if before == 'DELETED' || head == 'DELETED'
    #            return
    #        endif
    #
    #        exe printf('tabnew %s', file)
    #        syntax = &syntax
    #        exe 'vsplit'
    #        s:NewOrReplaceBuffer(printf('%s:%s', before, file))
    #        s:write_shell(["git show '%s:%s'", before, file])
    #        exe printf('setf %s', syntax)
    #        exe 'windo diffthis'
    #        norm gg

    # SXS - AFTER HEAD
    else
        #        after = trim(strcharpart(lin, 101, 8))
        #        head = trim(strcharpart(lin, 111, 8))
        #        if after == 'DELETED' || head == 'DELETED'
        #            return
        #        endif
        #
        #        exe printf('tabnew %s', file)
        #        syntax = &syntax
        #        exe 'vsplit'
        #        s:NewOrReplaceBuffer(printf('%s:%s', after, file))
        #        s:write_shell(["git show '%s:%s'", after, file])
        #        exe printf('setf %s', syntax)
        #        norm gg
    endif
enddef

def! s:git_fetch(remote: string): void
    s:hell_tab('FETCH', ['git fetch %s', remote])
    setl colorcolumn=
    s:git_colors()
    syn case ignore
    syn match Bad "forced update"
    syn match Good "[new branch]"
    hi Bad guifg=#ee3020
    hi Good guifg=#00b135
enddef


"
" DISPLAY GIT LOG HISTORY AND BRANCHES IN A NEW TAB
"

def! s:git_log_file(path: string): void
    s:MakeTabBuffer('TRACE')
    s:write(['COMMIT   %-80s DATE       AUTHOR', path])
    s:write([repeat('-', 130)])
    s:write_shell(["git log --pretty=format:'%s' -- '%s'"
                    \,'\%<(8)\%h \%<(80,trunc)\%s \%cs \%an'
                    \,path])

    exe '3'
    normal 1|
    setl colorcolumn=
    s:git_colors()

    exe printf("noremap <silent><buffer><2-LeftMouse> :cal <SID>git_trace_nav('%s')<CR>", path)
    exe printf("nnoremap <silent><buffer><F4> :cal <SID>git_trace_nav('%s')<CR>", path)
    exe printf("nnoremap <silent><buffer><F5> :cal <SID>git_log_file('%s')<CR>", path)
enddef

def! s:git_trace_nav(path: string): void
    s:git_show(expand('<cword>'), path)
enddef

" JUMP TO A NEW LOCATION BASED ON CURSOR IN GITLIST
def! s:git_log_nav(): void
    let col = col('.')
    if col > 0 && col < 11
        s:git_diff(expand('<cword>'))
    elseif col > 10 && col < 21
        s:git_diff(expand('<cword>'))
    else
        s:git_log(expand('<cfile>'))
    endif
enddef

def! s:git_prune(remote: string): void
    s:hell_tab('PRUNE', ['git remote prune %s', remote])
enddef

def! s:git_show(ref: string, file: string): void
    if ref == 'DELETED' || ref == 'ADDED'
        return
    endif

    let cmd = printf("git show '%s:%s'", ref, file)
    sil s:hell_tab(printf('%s:%s', ref, file), [cmd])
enddef



" RESERVED                                              F6
nnoremap <silent><F6> :sil !git gui&<CR>

" GIT GUI                                               F7

" GIT STATUS                                            F8

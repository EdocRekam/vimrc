
def! s:git_checkout(ref: string): void
    s:git_head()
    s:hell(['git checkout %s', ref])
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

def! s:git_prune(remote: string): void
    s:hell_tab('PRUNE', ['git remote prune %s', remote])
enddef



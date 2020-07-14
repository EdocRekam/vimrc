vim9script

def! s:WriteShellCallback(bufnr: number, chan: number, msg: string)
    let inf = getbufinfo(bufnr)
    let lnr = inf[0].linecount
    if lnr > 1
        appendbufline(bufnr, lnr - 1, msg)
    else
        appendbufline(bufnr, 1, '')
        setbufline(bufnr, 1, msg)
    endif
enddef

def! WriteShellAsync(cmd: string)
    job_start(cmd, #{out_cb: funcref("s:WriteShellCallback", [bufnr()])})
enddef

messages clear

tabnew
call WriteShellAsync("git show 470d9b4:git.vim")



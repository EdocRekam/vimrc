vim9script

def! s:WriteShellCallback(bufnr: number, chan: number, msg: string)
    appendbufline(bufnr, '$', '# ' .. msg)
enddef

def! WriteShellAsync(cmd: string)
    job_start(cmd, #{out_cb: funcref("s:WriteShellCallback", [bufnr()])})
enddef

messages clear
call WriteShellAsync('git log')


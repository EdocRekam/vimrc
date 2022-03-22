vim9script

def SCB(data: list<string>, c: channel, msg = '')
    data->add(msg)
enddef

# RUN SYSTEM COMMAND STORE RESULT IN LIST
def S(cmd = ''): list<string>
    var data = ['']
    var F = funcref(SCB, [data])
    var j = job_start(cmd, {out_cb: F, err_cb: F})
    while 'run' == j->job_status()
        sleep 100m
    endwhile
    if data->len() > 1
        data->remove(0)
    endif
    return data
enddef

defcompile

var x = S('git log -n6')
for m in x
     Trace(m)
endfor



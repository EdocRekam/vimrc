vim9script

def SCB(d: list<string>, c: channel, msg = '')
    d->add(msg)
enddef

# RUN SYSTEM COMMAND STORE RESULT IN LIST
def S(c = ''): list<string>
    let d = ['']
    let f = funcref(SCB, [d])
    let j = job_start(c, #{out_cb: f, err_cb: f})
    while 'run' == j->job_status()
        sleep 100m
    endw
    if d->len() > 1
        d->remove(0)
    en
    retu d
enddef

defcompile

let x = S('git log -n6')
for m in x
     Trace(m)
endfor



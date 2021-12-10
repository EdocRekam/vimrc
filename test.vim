vim9script

def SCB(d: list<string>, c: channel, msg = '')
    d->add(msg)
enddef

# RUN SYSTEM COMMAND STORE RESULT IN LIST
def S(c = ''): list<string>
    var d = ['']
    var F = funcref(SCB, [d])
    var j = job_start(c, {out_cb: F, err_cb: F})
    while 'run' == j->job_status()
        sleep 100m
    endw
    if d->len() > 1
        d->remove(0)
    en
    retu d
enddef

defcompile

var x = S('git log -n6')
for m in x
     Trace(m)
endfor



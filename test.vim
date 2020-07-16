vim9script

def Log(msg: string)
    let bnr = 10
    let inf = getbufinfo(bnr)
    let lnr = inf[0].linecount
    appendbufline(bnr, lnr - 1, msg)
enddef

call Log('Hlaello World')

vim9script

def! g:Unique()
    let src = getline("'<", "'>")
    let dst: list<string>
    for l in src
        if index(dst, l, 0, 0) < 0
            add(dst, l)
        en
    endfo
    let x = len(src) - len(dst)
    wh x > 0
        add(dst, '')
        x -= 1
    endw
    setline("'<", dst)
enddef

defcompile

# 1
# 2
# 3
# 5
# 6




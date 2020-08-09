vim9script

def! g:Unique()
    let lines = getline("'<", "'>")->uniq()
    for l in lines
        echom l
    endfor
    setline("'<", lines)
enddef

defcompile

# 1
# 2
# 3
# 1
# 5
# 1
# 6


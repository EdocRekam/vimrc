set shellredir='>'
let @a = system('git log --pretty=format:%h%s -n10')
tabnew 'Git Log'
put a

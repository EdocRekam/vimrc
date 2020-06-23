set background=dark
hi clear
if exists("syntax_on")
	syntax reset
end
let g:colors_name="gitmisc"


syn match hash "[0-9a-f]\{7,8}" containedin=String,Comment contains=@NoSpell

" syn keyword Keyword modified untracked

" syn region String start='"' end='"'
" syn region String start="'" end="'"

" syn match Comment "^On branch.*"
" syn match Comment "^Your branch.*"
" syn match Comment "^Changes to be.*"
" syn match Comment "^Changes not staged.*"
" syn match Comment "^Untracked files.*"
" syn match Comment "#.*" contains=@Spell


hi def link hash Keyword

let b:current_syntax = 'gitmisc'

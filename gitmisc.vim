if exists('b:current_syntax')
    finish
endif

syn keyword Keyword modified untracked

syn region String start='"' end='"'
syn region String start="'" end="'"

syn match Comment "^On branch.*"
syn match Comment "^Your branch.*"
syn match Comment "^Changes to be.*"
syn match Comment "^Changes not staged.*"
syn match Comment "^Untracked files.*"
syn match Comment "#.*" contains=@Spell

let b:current_syntax = 'gitmisc'

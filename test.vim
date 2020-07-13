vim9script

def! WriteShell(args: list<any>)
    exe 'sil -1read !' .. call('printf', args)
    norm G
enddef

WriteShell(['git status'])

On branch master
Your branch is up to date with 'hub/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   git2.vim
	modified:   test.vim

no changes added to commit (use "git add" and/or "git commit -a")



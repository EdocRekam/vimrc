
function! s:LoadCSharp()
    setf cs

    if !exists("g:e0647a20")
        let l:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
        let l:script = l:path . '/omni.vim'
        if filereadable(l:script)
            exe 'source ' . l:script
        endif
        unlet l:path
        unlet l:script
    endif
endfunction

" C# :enew|pu=execute('au')
autocmd! filetypedetect BufNewFile,BufRead *.cs call s:LoadCSharp()
autocmd! filetypedetect BufNewFile,BufRead *.Tests call s:LoadCSharp()

" XML
autocmd! filetypedetect BufNewFile,BufRead *.csproj setf xml
autocmd! filetypedetect BufNewFile,BufRead *.props setf xml
autocmd! filetypedetect BufNewFile,BufRead *.targets setf xml

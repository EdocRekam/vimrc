vim9script

def Foo(n: number): number
    echom 'Hello World'
    return 0
enddef

def Test(n: number): number
    echom 'Hello World'
    call Foo(n)
    return 0
enddef

defcompile

call Foo(0)
call Test(0)
disa s:Test


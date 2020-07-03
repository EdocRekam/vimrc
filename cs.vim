" Language: C#

if exists('b:current_syntax')
    finish
endif

" KEYWORDS
" https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/
syn keyword Keyword abstract as async await base checked class const event
syn keyword Keyword explicit extern false fixed fixed implicit interface
syn keyword Keyword internal is lock namespace new null operator out
syn keyword Keyword override params private protected public readonly
syn keyword Keyword ref sealed sizeof stackalloc static this true typeof
syn keyword Keyword unchecked unsafe virtual volatile

syn keyword Include     using
syn keyword Exception   throw try catch finally
syn keyword Repeat      do for foreach in while
syn keyword Conditional if else switch case
syn keyword Conditional break continue default goto return yield

" VALUE TYPES
syn keyword Type bool byte char decimal delegate double enum float int
syn keyword Type long object sbyte short string struct uint ulong ushort
syn keyword Type var void

" STRINGS
syn region String start='"' end='"'
syn region String start="'" end="'"

" COMMENTS
syn region Comment start="/\*" end="\*/" contains=@Spell
syn match  Comment "//.*$" contains=@Spell

let b:current_syntax = 'cs'


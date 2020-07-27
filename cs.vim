" Language: C#

if exists('b:current_syntax')
    finish
endif

" KEYWORDS
" https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/
sy keyword Keyword abstract as async await base checked class const event
sy keyword Keyword explicit extern false fixed fixed get implicit interface
sy keyword Keyword internal is lock namespace new null operator out
sy keyword Keyword override params private protected public readonly
sy keyword Keyword ref sealed set sizeof stackalloc static this true
sy keyword Keyword typeof unchecked unsafe virtual volatile

sy keyword Include     using
sy keyword Exception   throw try catch finally
sy keyword Repeat      do for foreach in while
sy keyword Conditional if else switch case ifen ifn ifne ifns
sy keyword Conditional break continue default goto return yield

" VALUE TYPES
sy keyword Type bool byte char decimal delegate double enum float int
sy keyword Type long object sbyte short string struct uint ulong
sy keyword Type ushort var void

sy keyword Identifier Int32 String
sy keyword Identifier Fact Theory InlineData

sy keyword Function IsNullOrEmpty ToInt32 ToString

" STRINGS
sy region String start='"' end='"'
sy region String start="'" end="'"

" COMMENTS
sy region Comment start="/\*" end="\*/" contains=@Spell
sy match  Comment "//.*$" contains=@Spell

let b:current_syntax = 'cs'


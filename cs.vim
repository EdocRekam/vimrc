" Language: C#

if exists('b:current_syntax')
    finish
en

" KEYWORDS
" https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/
sy keyword Keyword abstract as async await base checked class const event explicit extern false fixed fixed get implicit interface internal is lock namespace new null operator out override params private protected public readonly ref sealed set sizeof stackalloc static this true typeof unchecked unsafe virtual volatile

sy keyword Include using
sy keyword Exception catch finally throw try
sy keyword Repeat do for foreach in while
sy keyword Conditional break case continue default else goto if ife ifen ifn ifne ifnw return switch yield

" VALUE TYPES
sy keyword Type bool byte char decimal delegate double enum float int long object sbyte short string struct uint ulong ushort var void

sy keyword Identifier Int32 String
sy keyword Identifier Fact Theory InlineData

sy keyword Function IsNullOrEmpty IsNullOrWhiteSpace ToInt32 ToString

" STRINGS
sy region String start='"' end='"'
sy region String start="'" end="'"

" COMMENTS
sy region Comment start="/\*" end="\*/" contains=@Spell
sy match  Comment "//.*$" contains=@Spell

let b:current_syntax = 'cs'


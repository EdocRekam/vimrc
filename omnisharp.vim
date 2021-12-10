
# https://github.com/OmniSharp/Omnisharp-vim
#
# 1. INSTALL `OmniSharp-Roslyn`
#         https://github.com/OmniSharp/omnisharp-roslyn/releases
#
# 2. INSTALL `omnisharp-vim`
#         git clone https://github.com/OmniSharp/omnisharp-vim ~/.vim/pack/plugins/start/omnisharp-vim
#         git clone https://github.com/OmniSharp/omnisharp-vim ~/vimfiles/pack/plugins/start/omnisharp-vim
#
# 3. TURN ON PLUGIN SUPPORT
#         filetype indent plugin on
#

# OMNISHARP - GENERAL
g:OmniSharp_server_path = '/usr/local/bin/omnisharp'
g:OmniSharp_server_install = '/usr/local/lib64/omnisharp-roslyn'
g:OmniSharp_server_stdio = 1
g:OmniSharp_start_server = 0
g:OmniSharp_timeout = 5

# OMNISHARP - HIGHLIGHTING
g:OmniSharp_highlighting = 2
g:OmniSharp_hightlight_types = 3
g:omnicomplete_fetch_full_documentation = 1

g:OmniSharp_highlight_groups = {StringLiteral: 'String',
    XmlDocCommentText: 'Comment' }

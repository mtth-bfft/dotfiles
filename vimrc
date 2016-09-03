"" General settings

set ruler               " Show row and column ruler information
set number              " Show line numbers
set laststatus=2	" Permanently show the status bar
set statusline=%F
set statusline+=%y
set statusline+=%r
set statusline+=%l/%L
set statusline+=:
set statusline+=%c	" See :help statusline
set showcmd

set undolevels=1000     " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour
set autoindent          " copy indent from current line when starting a new line

set background=dark     " Dark colourset
syntax on               " Syntax highlighting

set linebreak           " Break lines at word (requires Wrap lines)
set showbreak=+++       " Wrap-broken line prefix
set showmatch           " Highlight matching brace
set errorbells          " Beep or flash screen on errors
set visualbell          " Use visual bell (no beeping)

set hlsearch            " Highlight all search results
set smartcase           " Enable smart-case search
set ignorecase          " Always case-insensitive
set incsearch           " Searches for strings incrementally

filetype indent on
set autoindent          " Auto-indent new lines
set smartindent         " Enable smart-indent
set smarttab            " Enable smart-tabs
set softtabstop=4       " Number of spaces per Tab

""
"" Trailing space highlighting
""

highlight WrongWhitespace ctermbg=red guibg=red
call matchadd('WrongWhitespace', ' \+\t\|\t \+')

highlight ExtraWhitespace ctermbg=red guibg=red
call matchadd('ExtraWhitespace', '\s\+$')

""
"" C-specific settings
""

autocmd FileType c setlocal noexpandtab " do not transform tabs into spaces
autocmd FileType c set tabstop=8      " display tabs as 8 spaces
autocmd FileType c set shiftwidth=8   " number of spaces when starting new lines
autocmd FileType c set softtabstop=8  " delete space-tabs 8 spaces (1 tab) at a time
autocmd FileType c set colorcolumn=80 " red ruler at 80 columns

""
"" Makefile-specific settings
""

autocmd FileType make setlocal noexpandtab " do not transform tabs into spaces
autocmd FileType make set tabstop=8      " display tabs as 8 spaces
autocmd FileType make set shiftwidth=8   " number of spaces when starting new lines
autocmd FileType make set softtabstop=8  " delete space-tabs 8 spaces (1 tab) at a time

""
"" Python-specific settings
""

" Python PEP8 compliant indentation
autocmd FileType python set tabstop=4    " display tabs as 4 spaces
autocmd FileType python set expandtab    " <tab> inserts spaces
autocmd FileType python set shiftwidth=4 " number of spaces when starting new lines
autocmd FileType python set textwidth=72 " break lines when line length increases
autocmd FileType python set softtabstop=4 " delete space-tabs 4 spaces (1 tab) at a time



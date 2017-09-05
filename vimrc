"" General settings

" Copy and paste buffer size
set viminfo='100,<1000,s100,h

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

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
colorscheme custom-colors
syntax on               " Syntax highlighting
highlight colorcolumn ctermbg=7
                        " When a ruler limits text width, paint it in light grey 

set linebreak           " Break lines at word (requires Wrap lines)
set showbreak=↳         " Wrap-broken line prefix
set showmatch           " Highlight matching braces
set errorbells          " Beep or flash screen on errors
set visualbell          " Use visual bell (no beeping)

set hlsearch            " Highlight all search results
set ignorecase          " Start searches in case insensitive mode
set smartcase           " Put searches in case sensitive mode if uppercase is entered
set incsearch           " Show results as query is being typed

filetype indent plugin on
set autoindent          " Copy indentation from previous line to new lines
set smartindent         " Automatically add one indentation level in certain cases (language-aware)
set tabstop=4           " Maximum number of spaces per tabulation
set softtabstop=4       " Width in spaces inserted when using the tab key (mix tab+space if not N*tabstop)
set smarttab!           " Disable context-aware tab key => shiftwidth at line start, otherwise tabstop
set expandtab           " Tab key and newline indentations insert only spaces
set shiftwidth=4        " Number of spaces per indentation, one tab

""
"" Cursor position highlighting
""

autocmd InsertEnter * set cursorcolumn
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set cursorcolumn!
autocmd InsertLeave * set cursorline!

""
"" Line length incentives
""

highlight ExtraLongLines ctermbg=darkred ctermfg=black
" red ruler at 70 columns
autocmd InsertEnter * match ExtraLongLines /\%70v/
" redraw! makes the screen blink
autocmd InsertLeave * match ExtraLongLines /^deadbeef$/

""
"" Tab displaying
""

set listchars=tab:>-
autocmd InsertEnter * set list
autocmd InsertLeave * set list!

""
"" Trailing space highlighting
""

highlight WrongWhitespace ctermbg=darkred
autocmd InsertEnter * 2match WrongWhitespace /\t \|\s\+$\| \t\|\S\+\t\| [^\n]*\n\t\+\|\t[^\n]*\n \+\|\(\n\s*\)\+\%$/
" redraw! makes the screen blink
autocmd InsertLeave * 2match WrongWhitespace /^deadbeef$/

""
"" Generic keywords
""

"highlight GenericKeywords term=bold ctermbg=darkgrey ctermfg=white
"3match GenericKeywords /\s*FIXME/
syntax region GenericKeyword matchgroup=Comment start=/FIXME/ end=/$/ 
highlight GenericKeywords ctermbg=red

""
"" C-specific settings
""

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
autocmd FileType python set tabstop=8    " display tabs as 8 spaces
autocmd FileType python set expandtab    " <TAB> inserts spaces
autocmd FileType python set shiftwidth=4 " number of spaces when starting new lines
autocmd FileType python set softtabstop=4 " delete space-tabs 4 spaces (1 tab) at a time
autocmd FileType python set textwidth=72 " break lines when line length increases


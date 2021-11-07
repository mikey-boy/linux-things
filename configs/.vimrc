" Whitespace
set expandtab
set shiftwidth=4
set softtabstop=4
set wrap

" Search
set hlsearch 
hi Search ctermbg=None ctermfg=Yellow cterm=bold
set ignorecase
set autoindent

" Line Numbers
set number
set numberwidth=2
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" Suggested line length
"set colorcolumn=80
highlight colorcolumn ctermbg=lightred

" Programming
syntax on
filetype plugin indent on

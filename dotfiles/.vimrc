" Whitespace
set expandtab
set shiftwidth=4
set softtabstop=4
set wrap

" Search
set hlsearch 
hi Search ctermbg=None ctermfg=Yellow cterm=bold
" set ignorecase
set autoindent

" Line Numbers
set number
set numberwidth=2
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" Programming
syntax on
filetype plugin indent on

" Key mappings
map [1;5D <C-Left>
map [1;5C <C-Right>


" Custom Commands

function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

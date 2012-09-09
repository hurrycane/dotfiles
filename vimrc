set tabstop=2
set shiftwidth=2
set expandtab

set autoindent
set smarttab

set showmatch
set scrolloff=5
set autowrite

syntax on
filetype on
filetype indent on
filetype plugin on

set nu
set ai
set history=1000 

" Yes, we have a fast terminal
set ttyfast

" Make backup file
set backup
set backupdir=/tmp
set directory=/tmp

" Highlight search matches
set hlsearch

set noequalalways
set splitbelow

" Open where I left off
set viminfo='1000,\"1000,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

if has('gui_running')
  set background=dark
  colorscheme solarized
  set guifont=AndaleMono:h14.00
endif

au BufRead,BufNewFile *.maude set filetype=maude

set background=dark
let g:solarized_termcolors=256
colorscheme solarized

" magic
call pathogen#infect()

cmap w!! %!sudo tee > /dev/null 

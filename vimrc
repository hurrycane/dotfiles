" Init pathogen
execute pathogen#infect()

set tabstop=4
set shiftwidth=4
set expandtab

set autoindent
set smarttab

set showmatch
set scrolloff=5
set autowrite

set cursorline
set synmaxcol=800   " don't try to highlight long lines

set list
set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮
set showbreak=↪\

set laststatus=2

set backspace=indent,eol,start  " backspace through everything in insert mode

syntax on
filetype on
filetype indent on
filetype plugin on

set omnifunc=syntaxcomplete#Complete

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

" Avoid showing trailing whitespace when in insert mode
au InsertEnter * set listchars-=trail:•
au InsertLeave * set listchars+=trail:•

" clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<CR>

" Open where I left off
set viminfo='1000,\"1000,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

if has('gui_running')
  set background=dark
  colorscheme solarized
  set guifont=AndaleMono:h14.00
endif

if !has('gui_running')
  set t_Co=256
endif

au BufRead,BufNewFile *.maude set filetype=maude

set background=dark
let g:solarized_termcolors=256
colorscheme solarized

cmap w!! %!sudo tee > /dev/null 

set nobackup
set nowritebackup

let NERDTreeIgnore = ['\.pyc$']

" disable arrow keys
" map <up> <nop>
" map <down> <nop>
" map <left> <nop>
" map <right> <nop>
" imap <up> <nop>
" imap <down> <nop>
" imap <left> <nop>
" imap <right> <nop>
set ruler
set wrap
set textwidth=120
set formatoptions=qrn1
set colorcolumn=120

set backspace=2
set backspace=indent,eol,start

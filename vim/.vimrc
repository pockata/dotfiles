" VIM tips from http://amix.dk/vim/vimrc.html

" Load vim-plug
"if empty(glob("~/.vim/autoload/plug.vim"))
"    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
"endif

syntax on

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'moll/vim-bbye'
Plug 'kien/ctrlp.vim'
Plug 'Raimondi/delimitMate'
Plug 'morhetz/gruvbox'
Plug 'gregsexton/MatchTag'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'bufkill.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-sensible'
Plug 'terryma/vim-smooth-scroll'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'mattn/emmet-vim'
Plug 'Valloric/MatchTagAlways'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
autocmd! User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif

call plug#end()

set t_Co=256
set background=dark
if !has('gui_running')
  let g:solarized_termcolors=&t_Co
  let g:solarized_termtrans=1
endif

colorscheme gruvbox
let g:gruvbox_contrast_dark="hard"

set number
filetype plugin indent on

" Enable mouse mode
set mouse=a

" Add proper indent when hitting <CR> inside curly braces
let delimitMate_expand_cr = 1

let g:NERDCustomDelimiters = {
    \ 'html': {  'left': '<!-- ', 'right': '-->', 'leftAlt': '/*','rightAlt': '*/' },
    \ 'xhtml': {  'left': '<!-- ', 'right': '-->', 'leftAlt': '/*','rightAlt': '*/'},
\}
let NERD_html_alt_style=1

" Show NERDTree with Ctrl+k Ctrl+b or Ctrl+kb
map <C-k><C-b> :NERDTreeToggle<CR>
map <C-k>b :NERDTreeToggle<CR>

" Sets 4 spaces as indent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

"Always show current position
set ruler

" Highlight current line
set cursorline

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" DO NOT WRAP
set nowrap

" Use system clipboard
set clipboard=unnamedplus

" Remap Delete command to not cut
nnoremap d "_d
vnoremap d "_d

" Remove toolbar in gVim
set go-=T

" Close buffer without closing split
command Bd bp\|bd \#

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" For expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
"set nobackup
"set nowb
"set noswapfile
set backupdir=~/.vim/backups,/tmp
set directory=~/.vim/backups,/tmp

set ai "Auto indent

" Don't implode
noremap j h
noremap k j
noremap l k
noremap ; l

noremap <C-w>j <C-w>h
noremap <C-w>k <C-w>j
noremap <C-w>l <C-w>k
noremap <C-w>; <C-w>l

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-k> mz:m+<cr>`z
nmap <M-l> mz:m-2<cr>`z
vmap <M-k> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-l> :m'<-2<cr>`>my`<mzgv`yo`z

" Change shape of cursor in different modes
  " solid underscore
  let &t_SI .= "\<Esc>[5 q"
  " solid block
  let &t_EI .= "\<Esc>[2 q"
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  " Recent versions of xterm (282 or above) also support
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar

" Ignore files ctrlp https://github.com/kien/ctrlp.vim/issues/58
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

"https://www.reddit.com/r/vim/comments/3er2az/how_to_suppress_vims_warning_editing_a_read_only/
"au BufEnter * set noro

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" Relative line numbers
set relativenumber

" Delete tra iling white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()
autocmd BufWrite *.js :call DeleteTrailingWS()
autocmd BufWrite *.scss :call DeleteTrailingWS()
autocmd BufWrite *.html :call DeleteTrailingWS()
autocmd BufWrite *.css :call DeleteTrailingWS()
autocmd BufWrite *.php :call DeleteTrailingWS()
autocmd BufWrite *.json :call DeleteTrailingWS()
autocmd BufWrite *.sh :call DeleteTrailingWS()

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>


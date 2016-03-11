" VIM tips from http://amix.dk/vim/vimrc.html

" Load vim-plug
"if empty(glob("~/.vim/autoload/plug.vim"))
"    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
"endif

syntax on

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeFind' }
Plug 'Raimondi/delimitMate'
Plug 'chriskempson/base16-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug '1995eaton/vim-better-javascript-completion', { 'for': 'javascript' }
Plug 'EinfachToll/DidYouMean'
Plug 'unblevable/quick-scope'
"Plug 'justinmk/vim-sneak'
Plug 'vim-scripts/wipeout', { 'on':  'Wipeout' }
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-smooth-scroll'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'mattn/emmet-vim'
Plug 'Valloric/MatchTagAlways'
Plug 'tpope/vim-sleuth'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-oblique'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'dbakker/vim-projectroot'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'rking/ag.vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }
autocmd! User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif

call plug#end()

set ttyfast " faster reflow
set shortmess+=I " No intro when starting Vim
set smartindent " Smart... indent
set gdefault " The substitute flag g is on
set hidden " Hide the buffer instead of closing when switching
set synmaxcol=300 " Don't try to highlight long lines

set t_Co=256
set background=dark

colorscheme base16-ocean

let mapleader=","
set number
filetype plugin indent on

" set cursor in split window
set splitright
set splitbelow

let g:airline_powerline_fonts = 1

" remove esc key timeout
set timeoutlen=1000
set ttimeoutlen=0

set autoindent
set complete-=i

" Enable mouse mode
set mouse=a

" Trigger a highlight (quick-scope) in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Add proper indent when hitting <CR> inside curly braces
let delimitMate_expand_cr = 1

let g:NERDCustomDelimiters = {
    \ 'html': {  'left': '<!-- ', 'right': '-->', 'leftAlt': '/*','rightAlt': '*/' },
    \ 'xhtml': {  'left': '<!-- ', 'right': '-->', 'leftAlt': '/*','rightAlt': '*/'},
\}
let NERD_html_alt_style=1

" FZF
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <silent> <c-p> :ProjectRootExe FZF<cr>

" Gitgutter
let g:gitgutter_map_keys = 0

" Show NERDTree with Ctrl+k Ctrl+b or Ctrl+kb
function! SmartNERDTree()
    if exists("b:NERDTree") && b:NERDTree.isTabTree()
        :NERDTreeClose
    else
        :ProjectRootExe
        :NERDTreeFind
    endif
endfunction

map <silent> <C-k><C-b> :call SmartNERDTree()<cr>
map <silent> <C-k>b :call SmartNERDTree()<cr>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e ~/.vimrc<CR>
nmap <silent> <leader>sv :so ~/.vimrc<CR>

" Sets 4 spaces as indent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set lazyredraw

" Show whitespace characters
set list
set listchars=tab:>·,trail:·

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
" ... only on focused pane
autocmd! WinEnter * set cursorline
autocmd! WinLeave * set nocursorline

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
command! Bd bp\|bd \#

" hide mode (shown in airline)
set noshowmode

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
    nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

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
set nobackup
set nowb
set noswapfile

set ai "Auto indent

" Don't implode
noremap j h
noremap k gj
noremap l gk
noremap ; l

noremap <C-w>j <C-w>h
noremap <C-w>k <C-w>j
noremap <C-w>l <C-w>k
noremap <C-w>; <C-w>l

nnoremap <left> :vertical resize +5<cr>
nnoremap <right> :vertical resize -5<cr>
nnoremap <up> :resize +5<cr>
nnoremap <down> :resize -5<cr>

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


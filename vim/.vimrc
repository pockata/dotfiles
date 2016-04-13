" VIM tips from http://amix.dk/vim/vimrc.html

" Load vim-plug
"if empty(glob("~/.vim/autoload/plug.vim"))
"    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
"endif

syntax on

call plug#begin('~/.vim/plugged')

" colorschemes / start screen
Plug 'chriskempson/base16-vim'
Plug 'EinfachToll/DidYouMean'
Plug 'mhinz/vim-startify'

" additional key mappings
Plug 'scrooloose/nerdcommenter'
Plug 'unblevable/quick-scope'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'beloglazov/vim-textobj-quotes'
Plug 'bkad/CamelCaseMotion'

" text manipulation / display
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Valloric/MatchTagAlways'

" code/project management
Plug 'airblade/vim-gitgutter'
Plug 'dbakker/vim-projectroot', { 'on':  'ProjectRootExe' }
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'tpope/vim-sleuth'

" code searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'rking/ag.vim'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-oblique'

" navigation
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeFind' }
Plug 'MattesGroeger/vim-bookmarks'
Plug 't9md/vim-choosewin'
Plug 'terryma/vim-smooth-scroll'

" completion
Plug '1995eaton/vim-better-javascript-completion', { 'for': 'javascript' }
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }
autocmd! User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif

" extra language support
Plug 'sheerun/vim-polyglot'

" statusline
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" distraction free
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }

" misc
Plug 'vim-scripts/wipeout', { 'on':  'Wipeout' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

"Plug 'vim-scripts/SyntaxRange'

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
let g:mapleader=","

set number
filetype plugin indent on

" set cursor in split window
set splitright
set splitbelow

let g:airline_powerline_fonts = 1
let g:airline_mode_map = {
        \ '__' : '------',
        \ 'n'  : 'N',
        \ 'i'  : 'I',
        \ 'R'  : 'R',
        \ 'v'  : 'V',
        \ 'V'  : 'V-L',
        \ 'c'  : 'C',
        \ '' : 'V-B',
        \ 's'  : 'S',
        \ 'S'  : 'S-L',
        \ '' : 'S-B',
        \ 't'  : 'T',
        \ }

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
let NERDTreeShowHidden=1
let g:NERDTreeMapOpenInTab="<C-t>"
let g:NERDTreeMapOpenSplit="<C-s>"
let g:NERDTreeMapOpenVSplit="<C-v>"

" camelcasemotion
call camelcasemotion#CreateMotionMappings('')

" FZF
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" Insert mode completion
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
nmap <Leader>h :History<CR>
nmap <Leader>r :BLines<CR>
nmap <Leader>w :Buffers<CR>
nmap <Leader>c :Commands<CR>

nnoremap <silent> <c-p> :ProjectRootExe FZF<cr>
"nnoremap <silent> <C-S-P> :ProjectRootExe Buffers<cr>

" https://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/
" Smarter? splits
" window
nmap <Leader>swj :topleft  vnew<CR>
nmap <Leader>sw; :botright vnew<CR>
nmap <Leader>swl :topleft  new<CR>
nmap <Leader>swk :botright new<CR>

" buffer
nmap <Leader>sj :leftabove  vnew<CR>
nmap <Leader>s; :rightbelow vnew<CR>
nmap <Leader>sl :leftabove  new<CR>
nmap <Leader>sk :rightbelow new<CR>

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

" Convenient command to see the difference between the
" current buffer and the file it was loaded from,
" thus the changes you made.
" http://vimrcfu.com/snippet/214
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" let terminal resize scale the internal windows
" http://vimrcfu.com/snippet/186
"autocmd VimResized * :wincmd =

" Re-select visual block after indenting
" http://vimrcfu.com/snippet/14
vnoremap < <gv
vnoremap > >gv

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
"autocmd! WinEnter * set cursorline
"autocmd! WinLeave * set nocursorline

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

" Hide current mode (shown in airline)
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

" invoke with '-'
nmap  -  <Plug>(choosewin)
let g:choosewin_overlay_enable = 1

" Move visual block
" http://vimrcfu.com/snippet/77
vnoremap K :m '>+1<CR>gv=gv
vnoremap L :m '<-2<CR>gv=gv

" Change shape of cursor in different modes
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
    " solid underscore
    let &t_SI = "\e[5 q"
    " solid block
    let &t_EI = "\e[2 q"
    " 1 or 0 -> blinking block
    " 3 -> blinking underscore
    " Recent versions of xterm (282 or above) also support
    " 5 -> blinking vertical bar
    " 6 -> solid vertical bar
endif

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

"https://www.reddit.com/r/vim/comments/3er2az/how_to_suppress_vims_warning_editing_a_read_only/
au BufEnter * set noro

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
set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

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
autocmd BufWrite *.c :call DeleteTrailingWS()
autocmd BufWrite *.cpp :call DeleteTrailingWS()

" Better css/sass completion
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd BufNewFile,BufRead *.scss set ft=scss.css

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        exec t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction

command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-w>o :ZoomToggle<CR>
nnoremap <silent> <C-w>o :ZoomToggle<CR>

" VIM tips from http://amix.dk/vim/vimrc.html

" Load vim-plug
"if empty(glob("~/.vim/autoload/plug.vim"))
"    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
"endif

syntax on

call plug#begin('~/.vim/plugged')

" colorschemes / start screen
Plug 'chriskempson/base16-vim'
Plug 'mhinz/vim-startify'

" additional text objects
Plug 'scrooloose/nerdcommenter'
Plug 'unblevable/quick-scope'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'beloglazov/vim-textobj-quotes'
Plug 'jasonlong/vim-textobj-css'
Plug 'akiyan/vim-textobj-php'
Plug 'whatyouhide/vim-textobj-xmlattr'
Plug 'Julian/vim-textobj-brace'
Plug 'vim-scripts/argtextobj.vim'

" additional key mappings
Plug 'rhysd/clever-f.vim' " GOLDEN
Plug 'bkad/CamelCaseMotion'

" text manipulation / display
Plug 'Raimondi/delimitMate'
Plug 'FooSoft/vim-argwrap', { 'on': 'ArgWrap' }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'AndrewRadev/splitjoin.vim', { 'on': ['SplitjoinSplit', 'SplitjoinJoin']}
Plug 'Valloric/MatchTagAlways'
Plug 'terryma/vim-expand-region'

" code/project management
Plug 'airblade/vim-gitgutter'
Plug 'dbakker/vim-projectroot', { 'on': 'ProjectRootExe' }
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'tpope/vim-sleuth'
Plug 'jmcantrell/vim-diffchanges', { 'on': 'DiffChangesDiffToggle' }

" code searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-oblique'
"Plug 'mhinz/vim-grepper'

" navigation
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeFind' }
Plug 'MattesGroeger/vim-bookmarks'
Plug 't9md/vim-choosewin', { 'on': 'ChooseWin' }
Plug 'terryma/vim-smooth-scroll'
Plug 'kovetskiy/next-indentation'

" completion
Plug 'shougo/neocomplete.vim'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install', 'for': 'javascript' }

" extra language support
Plug 'sheerun/vim-polyglot'
Plug 'rhysd/devdocs.vim', { 'on': 'DevDocs' }

" statusline
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" distraction free
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Limelight' }

" misc
Plug 'vim-scripts/wipeout', { 'on':  'Wipeout' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'justinmk/vim-gtfo'
Plug 'tmux-plugins/vim-tmux-focus-events'
"Plug 'vim-scripts/SyntaxRange'

call plug#end()

set ttyfast " faster reflow
set shortmess+=I " No intro when starting Vim
set smartindent " Smart... indent
set gdefault " The substitute flag g is on
set hidden " Hide the buffer instead of closing when switching
set synmaxcol=300 " Don't try to highlight long lines
set virtualedit=onemore " Allow for cursor beyond last character

set t_Co=256
set background=dark

colorscheme base16-ocean

let mapleader="\<Space>"
let g:mapleader="\<Space>"

set number
filetype plugin indent on

" set cursor in split window
set splitright
set splitbelow

let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16_ocean'
let g:airline_left_sep=''
let g:airline_right_sep=''
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

match Error /\%81v.\+/

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
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_jump_expansion = 1
let g:delimitMate_balance_matchpairs = 1

let g:NERDCustomDelimiters = {
    \ 'html': {  'left': '<!-- ', 'right': '-->', 'leftAlt': '/*','rightAlt': '*/' },
    \ 'xhtml': {  'left': '<!-- ', 'right': '-->', 'leftAlt': '/*','rightAlt': '*/'},
\}
let NERD_html_alt_style=1
let NERDTreeShowHidden=1
let g:NERDTreeMapOpenInTab="<C-t>"
let g:NERDTreeMapOpenSplit="<C-s>"
let g:NERDTreeMapOpenVSplit="<C-v>"

let g:clever_f_smart_case = 1

" camelcasemotion
call camelcasemotion#CreateMotionMappings(',')

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#max_list = 15
let g:neocomplete#force_overwrite_completefunc = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.

"inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"function! s:my_cr_function()
"  return (pumvisible() ? "\<C-y>" : "" ) . "\<C-R>=delimitMate#ExpandReturn()\<CR>"
"  " For no inserting <CR> key.
"  "return pumvisible() ? "\<C-y>" : "\<CR>"
"endfunction

function! CleverCr()
    if pumvisible()
        if neosnippet#expandable()
            let exp = "\<Plug>(neosnippet_expand)"
            return exp . neocomplete#smart_close_popup()
        else
            return neocomplete#smart_close_popup()
        endif
    else
        return "\<C-R>=delimitMate#ExpandReturn()\<CR>"
    endif
endfunction

" <CR> close popup and save indent or expand snippet
imap <expr> <CR> CleverCr()

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>   pumvisible() ? "\<C-p>" : "\<C-h>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" Close popup by <Space>.
inoremap <expr><Space> pumvisible() ? "\<C-y>\<Space>" : "\<Space>"

" yank without jank
" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap y myy`y
vnoremap Y myY`y

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=tern#Complete
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:gtfo#terminals = { 'unix' : 'urxvtc -g 50x15 -cd' }

" FZF
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

nmap K <Plug>(devdocs-under-cursor)

" Insert mode completion
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
nmap <Leader>h :History<CR>
nmap <Leader>j :Lines<CR>
nmap <Leader>r :BLines<CR>
nmap <Leader>w :Windows<CR>
nmap <Leader>b :Buffers<CR>
nmap <Leader>c :Commands<CR>

nnoremap <S-Tab> :IndentationGoUp<CR>
nnoremap <Tab> :IndentationGoDown<CR>

nnoremap <silent> <leader>a :ArgWrap<CR>
nnoremap <silent> <c-p> :ProjectRootExe FZF<cr>
"nnoremap <silent> <C-S-P> :ProjectRootExe Buffers<cr>

nnoremap <leader>p p`[v`]=

nnoremap <Leader>u :UndotreeToggle<CR>
" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1

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
    if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
        :NERDTreeClose
    else
        :ProjectRootExe
        :NERDTreeFind
    endif
endfunction

map <silent> <C-k><C-b> :call SmartNERDTree()<cr>
map <silent> <C-k>b :call SmartNERDTree()<cr>



" select pasted text
nmap gp `[v`]

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :execute 'tabnew ' . resolve(expand($MYVIMRC))<CR>
nmap <silent> <leader>sv :so ~/.vimrc<CR>:AirlineRefresh<CR>

" Sets 4 spaces as indent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set lazyredraw

" Show whitespace characters
set list
set listchars=tab:▸\ ,trail:·

" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" set 15 columns to the cursor - when moving horizontally
set sidescroll=1
set sidescrolloff=15

" Turn on the WiLd menu
set wildmenu

" Vsplit when diffing (Gdiff)
set diffopt+=vertical

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

" This turns off Vim’s crazy default regex characters
" and makes searches use normal regexes.
nnoremap / /\v
vnoremap / /\v

" Remove toolbar in gVim
set go-=T

" Close buffer without closing split
command! Bd bp\|bd \#

" :W sudo saves the file
command! W w !sudo tee % > /dev/null

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
noremap <silent> <expr> k (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> l (v:count == 0 ? 'gk' : 'k')
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
    let &t_SR = "\<Esc>Ptmux;\<Esc>\e[3 q\<Esc>\\"
else
    " solid underscore
    let &t_SI = "\e[5 q"
    let &t_SR = "\e[3 q"
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
autocmd BufWrite *.jsx :call DeleteTrailingWS()
autocmd BufWrite *.scss :call DeleteTrailingWS()
autocmd BufWrite *.html :call DeleteTrailingWS()
autocmd BufWrite *.css :call DeleteTrailingWS()
autocmd BufWrite *.php :call DeleteTrailingWS()
autocmd BufWrite *.json :call DeleteTrailingWS()
autocmd BufWrite *.sh :call DeleteTrailingWS()
autocmd BufWrite *.c :call DeleteTrailingWS()
autocmd BufWrite *.cpp :call DeleteTrailingWS()

" identify sass files as such
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
nnoremap <silent> <C-w>o :ZoomToggle<CR>:AirlineRefresh<CR>
nnoremap <silent> <C-w>o :ZoomToggle<CR>:AirlineRefresh<CR>


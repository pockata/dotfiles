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
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'beloglazov/vim-textobj-quotes'
Plug 'akiyan/vim-textobj-php'
Plug 'kana/vim-textobj-function'
Plug 'thinca/vim-textobj-function-javascript'
Plug 'kana/vim-textobj-entire'
Plug 'whatyouhide/vim-textobj-xmlattr'
Plug 'PeterRincker/vim-argumentative'
Plug 'coderifous/textobj-word-column.vim'
Plug 'junegunn/vim-after-object'

" additional key mappings
Plug 'rhysd/clever-f.vim' " GOLDEN
Plug 'bkad/CamelCaseMotion'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-scripts/marvim'

" text manipulation / display
Plug 'Raimondi/delimitMate'
Plug 'FooSoft/vim-argwrap', { 'on': 'ArgWrap' }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'AndrewRadev/splitjoin.vim', { 'on': ['SplitjoinSplit', 'SplitjoinJoin']}
Plug 'Valloric/MatchTagAlways'
Plug 'chrisbra/NrrwRgn'
Plug 'itchyny/vim-parenmatch'

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
"Plug 'junegunn/vim-pseudocl'
"Plug 'junegunn/vim-oblique'
Plug 'henrik/vim-indexed-search'

" navigation
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeFind', 'NERDTreeOpen'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeFind', 'NERDTreeOpen'] }
Plug 'MattesGroeger/vim-bookmarks'
Plug 't9md/vim-choosewin', { 'on': ['<Plug>(choosewin)', 'ChooseWin'] }
Plug 'terryma/vim-smooth-scroll'
Plug 'kovetskiy/next-indentation'
Plug 'takac/vim-hardtime'

" completion
Plug 'shougo/neocomplete.vim'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install', 'for': 'javascript' }

" extra language support
Plug 'scrooloose/syntastic'
Plug 'sheerun/vim-polyglot'

" statusline
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" distraction free
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Limelight' }

" misc
Plug 'vim-scripts/wipeout', { 'on':  'Wipeout' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'benmills/vimux'
Plug 'tmux-plugins/vim-tmux-focus-events'

" FOR CONSIDERATION
"Plug 'Konfekt/FastFold'
"Plug 'mhinz/vim-grepper'
" https://github.com/kana/vim-smartword/blob/master/doc/smartword.txt

"Plug 'janko-m/vim-test'
"function! TerminalSplitStrategy(cmd) abort
"tabnew | call termopen(a:cmd) | startinsert
"endfunction
"let g:test#custom_strategies = get(g:, 'test#custom_strategies', {})
"let g:test#custom_strategies.terminal_split = function('TerminalSplitStrategy')
"let test#strategy = 'terminal_split'

"nnoremap <silent> <leader>rr :TestFile<CR>
"nnoremap <silent> <leader>rf :TestNearest<CR>
"nnoremap <silent> <leader>rs :TestSuite<CR>
"nnoremap <silent> <leader>ra :TestLast<CR>
"nnoremap <silent> <leader>ro :TestVisit<CR>

call plug#end()

set ttyfast " faster reflow
set shortmess+=I " No intro when starting Vim
set smartindent " Smart... indent
set gdefault " The substitute flag g is on
set hidden " Hide the buffer instead of closing when switching
set synmaxcol=300 " Don't try to highlight long lines
set virtualedit=onemore " Allow for cursor beyond last character
set foldmethod=manual
set foldlevel=1

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

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 1
let g:syntastic_php_checkers=['php', 'phpcs', 'phpmd']
"let g:syntastic_aggregate_errors = 1

" Disable default matchparen plugin
let g:loaded_matchparen = 1

" GAME ON
let g:hardtime_default_on = 1
let g:hardtime_ignore_buffer_patterns = [ "NERD.*" ]
let g:hardtime_ignore_quickfix = 1
let g:hardtime_allow_different_key = 1
let g:hardtime_maxcount = 2 " for when I hit the wrong line number
let g:list_of_normal_keys = ["h", "j", "k", "l"]
let g:list_of_visual_keys = ["h", "j", "k", "l"]
let g:list_of_insert_keys = []

let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16_ocean'
let g:airline#extensions#tabline#tabs_label = 'party hard'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

" enable/disable showing only non-zero hunks
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 1

" configure which whitespace checks to enable
let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing' ]
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

" highlight long lines (but only one column)
highlight ColorColumn ctermbg=red ctermfg=white
call matchadd('ColorColumn', '\%81v', 100)

" remove esc key timeout
set timeoutlen=500
set ttimeoutlen=0

set autoindent
set complete-=i

" Enable mouse mode
set mouse=a

" dont continue comments when pushing o/O
set formatoptions-=o

" reformat html -> each tag on own row
" nmap <leader><F3> :%s/<[^>]*>/\r&\r/g<cr>gg=G:g/^$/d<cr><leader>/

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
let NERDTreeMinimalUI = 1
let g:NERDTreeMapOpenInTab="<C-t>"
let g:NERDTreeMapOpenSplit="<C-s>"
let g:NERDTreeMapOpenVSplit="<C-v>"
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }
let g:clever_f_smart_case = 1
let g:clever_f_across_no_line = 1
let g:clever_f_fix_key_direction = 1
let g:clever_f_chars_match_any_signs = '`'

" camelcasemotion
call camelcasemotion#CreateMotionMappings(',')

map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>
map <C-t> <esc>:tabnew<CR>

" Execute macro in q
map Q @q

" Disable K looking stuff up
map K <Nop>

" Merge a tab into a split in the previous window
function! MergeTabs()
    if tabpagenr() == 1
        return
    endif
    let bufferName = bufname("%")
    if tabpagenr("$") == tabpagenr()
        close!
    else
        close!
        tabprev
    endif
    split
    execute "buffer " . bufferName
endfunction

nmap <C-W>u :call MergeTabs()<CR>

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

let g:argumentative_no_mappings = 1
nmap [a <Plug>Argumentative_Prev
nmap ]a <Plug>Argumentative_Next
xmap [a <Plug>Argumentative_XPrev
xmap ]a <Plug>Argumentative_XNext
nmap <a <Plug>Argumentative_MoveLeft
nmap >a <Plug>Argumentative_MoveRight
xmap ia <Plug>Argumentative_InnerTextObject
xmap aa <Plug>Argumentative_OuterTextObject
omap ia <Plug>Argumentative_OpPendingInnerTextObject
omap aa <Plug>Argumentative_OpPendingOuterTextObject

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

"imap <expr><tab> neosnippet#expandable_or_jumpable() ?
"      \ "\<Plug>(neosnippet_expand_or_jump)"
"      \ : pumvisible() ? "\<C-N>" : "\<tab>"
"smap <expr><tab> neosnippet#expandable_or_jumpable() ?
"      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"

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

" Switch between tabs
execute "set <M-1>=\e1"
execute "set <M-2>=\e2"
execute "set <M-3>=\e3"
execute "set <M-4>=\e4"
execute "set <M-5>=\e5"
execute "set <M-6>=\e6"
execute "set <M-7>=\e7"
execute "set <M-8>=\e8"
execute "set <M-9>=\e9"
nnoremap <M-1> 1gt
nnoremap <M-2> 2gt
nnoremap <M-3> 3gt
nnoremap <M-4> 4gt
nnoremap <M-5> 5gt
nnoremap <M-6> 6gt
nnoremap <M-7> 7gt
nnoremap <M-8> 8gt
nnoremap <M-9> 9gt

" p: go to the previously open file.
nnoremap <Leader>o <C-^>

" Delete all hidden buffers
nnoremap <silent> <Leader><BS>b :call DeleteHiddenBuffers()<CR>
function! DeleteHiddenBuffers() " {{{
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    silent execute 'bwipeout' buf
  endfor
endfunction " }}}

nmap got :VimuxRunCommand("")<CR>

" FZF
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

function! SearchVisualSelectionWithAg()
    execute 'Ag' s:getVisualSelection()
endfunction

function! SearchWordWithAg()
  execute 'Ag' expand('<cword>')
endfunction

nnoremap <silent> H :call SearchWordWithAg()<CR>
vnoremap <silent> H :call SearchVisualSelectionWithAg()<CR>

" Insert mode completion
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
nmap <Leader>h :History<CR>
nmap <Leader>j :Lines<CR>
nmap <Leader>r :BLines<CR>
nmap <Leader>w :Windows<CR>
nmap <Leader>b :Buffers<CR>
nmap <Leader>c :Commands<CR>
nmap <Leader>g :GitFiles?<CR>

" Go to first character of line on first press
" Go to start of line on second press
" http://ddrscott.github.io/blog/2016/vim-toggle-movement/
function! ToggleHomeZero()
    let pos = getpos('.')
    execute "normal! ^"
    if pos == getpos('.')
        execute "normal! 0"
    endif
endfunction

nnoremap <silent> 0 :call ToggleHomeZero()<CR>

vnoremap <silent> <S-Tab> [{
vnoremap <silent> <Tab> ]}
nnoremap <silent> <S-Tab> [{
nnoremap <silent> <Tab> ]}

nnoremap <silent> <leader>a :ArgWrap<CR>
nnoremap <silent> <c-p> :ProjectRootExe FZF<cr>

" move horizontally
nnoremap z; 20zl
nnoremap zj 20zh

nnoremap <leader>p p`[v`]=

nnoremap <Leader>u :UndotreeToggle<CR>
" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout = 2

autocmd VimEnter * silent! call after_object#enable('=', ':', '#', ' ', '|')

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
let g:gitgutter_max_signs = 200
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 1
nmap <silent> ]h :GitGutterNextHunk<CR>
nmap <silent> [h :GitGutterPrevHunk<CR>

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
set showbreak=↪\ 
set list
set listchars=tab:→\ ,trail:·,extends:›,precedes:‹

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

augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

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
"noremap <silent> <expr> k (v:count == 0 ? 'gj' : 'j')
"noremap <silent> <expr> l (v:count == 0 ? 'gk' : 'k')
noremap k j
noremap l k
noremap ; l

noremap <C-w>j <C-w>h
noremap <C-w>k <C-w>j
noremap <C-w>l <C-w>k
noremap <C-w>; <C-w>l

" Be aware of whether you are right or left vertical split
" so you can use arrows more naturally.
" Inspired by https://github.com/ethagnawl.
function! IntelligentVerticalResize(direction) abort
  let l:window_resize_count = 5
  let l:current_window_is_last_window = (winnr() == winnr('$'))

  if (a:direction ==# 'left')
    let [l:modifier_1, l:modifier_2] = ['+', '-']
  else
    let [l:modifier_1, l:modifier_2] = ['-', '+']
  endif

  let l:modifier = l:current_window_is_last_window ? l:modifier_1 : l:modifier_2
  let l:command = 'vertical resize ' . l:modifier . l:window_resize_count . '<CR>'
  execute l:command
endfunction
nnoremap <silent> <Right> :call IntelligentVerticalResize('right')<CR>
nnoremap <silent> <Left> :call IntelligentVerticalResize('left')<CR>

nnoremap <up> :resize +5<cr>
nnoremap <down> :resize -5<cr>

" invoke with '-'
nmap - <Plug>(choosewin)
let g:choosewin_overlay_enable = 1
let g:choosewin_blink_on_land = 0
let g:choosewin_overlay_clear_multibyte = 1

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
nnoremap <silent> <C-w><C-o> :ZoomToggle<CR>:AirlineRefresh<CR>

" ----------------------------------------------------------------------------
" :Shuffle | Shuffle selected lines
" ----------------------------------------------------------------------------
function! s:shuffle() range
ruby << RB
  first, last = %w[a:firstline a:lastline].map { |e| VIM::evaluate(e).to_i }
  (first..last).map { |l| $curbuf[l] }.shuffle.each_with_index do |line, i|
    $curbuf[first + i] = line
  end
RB
endfunction
command! -range Shuffle <line1>,<line2>call s:shuffle()


" ----------------------------------------------------------------------------
" Get Visual Selection helper function
" ----------------------------------------------------------------------------
function! s:getVisualSelection() range
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    let old_clipboard = &clipboard
    set clipboard&
    normal! ""gvy
    let selection = getreg('"')
    call setreg('"', old_reg, old_regtype)
    let &clipboard = old_clipboard
    return selection
endfunction

" ----------------------------------------------------------------------------
" <Leader>?/! | Google it / Feeling lucky
" ----------------------------------------------------------------------------
function! s:goog(pat, lucky)
  let q = '"'.substitute(a:pat, '["\n]', ' ', 'g').'"'
  let q = substitute(q, '[[:punct:] ]',
       \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
  call system(printf('xdg-open "https://www.google.com/search?%sq=%s"',
                   \ a:lucky ? 'btnI&' : '', q))
endfunction

nnoremap <silent> <leader>/ :call <SID>goog(expand("<cWORD>"), 0)<cr>
vnoremap <silent> <leader>/ :call <SID>goog(<SID>getVisualSelection(), 0)<cr>

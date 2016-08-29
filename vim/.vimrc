" VIM tips from http://amix.dk/vim/vimrc.html

" Load vim-plug
"if empty(glob("~/.vim/autoload/plug.vim"))
"    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
"endif

" required for alt/meta mappings  https://github.com/tpope/vim-sensible/issues/69
set encoding=utf-8

let g:did_install_default_menus = 1  " avoid stupid menu.vim (saves ~100ms)

let s:plugins = filereadable(expand("~/.vim/autoload/plug.vim", 1))
if !s:plugins "{{{
  fun! InstallPlug() "bootstrap plug.vim on new systems
    silent call mkdir(expand("~/.vim/autoload", 1), 'p')
    exe '!curl -fLo '.expand("~/.vim/autoload/plug.vim", 1).' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endfun
endif

let g:plug_window = 'enew'

syntax on

call plug#begin('~/.vim/plugged')

" colorschemes / start screen
Plug 'chriskempson/base16-vim'
Plug 'mhinz/vim-startify', { 'on': 'Startify'}
Plug 'alessandroyorba/alduin'

" additional text objects
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'rhysd/vim-textobj-anyblock'
Plug 'kana/vim-textobj-entire'
Plug 'whatyouhide/vim-textobj-xmlattr'
Plug 'glts/vim-textobj-comment'
Plug 'PeterRincker/vim-argumentative'

Plug 'terryma/vim-expand-region', {
    \'on': ['<Plug>(expand_region_expand)', '<Plug>(expand_region_shrink)']
\}

" additional key mappings
Plug 'rhysd/clever-f.vim' " GOLDEN
Plug 'bkad/CamelCaseMotion'
Plug 'scrooloose/nerdcommenter'
Plug 'christoomey/vim-tmux-navigator'

" text manipulation / display
Plug 'Raimondi/delimitMate'
Plug 'FooSoft/vim-argwrap', { 'on': 'ArgWrap' }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'Valloric/MatchTagAlways'
Plug 'junegunn/limelight.vim', { 'on': 'Limelight' }

" code/project management
Plug 'airblade/vim-gitgutter'
Plug 'dbakker/vim-projectroot'
"Plug '/airblade/vim-rooter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
"Plug 'jmcantrell/vim-diffchanges', { 'on': 'DiffChangesDiffToggle' }
Plug 'yssl/QFEnter'
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'rhysd/committia.vim'
Plug 'rhysd/conflict-marker.vim'
Plug 'rhysd/npm-debug-log.vim', { 'for': 'npmdebug' } " TODO: make this work

" code searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-oblique'
"Plug 'ddrscott/vim-side-search'
Plug 'nhooyr/neoman.vim'

" navigation
Plug 'scrooloose/nerdtree', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFind', 'NERDTreeOpen'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFind', 'NERDTreeOpen'] }
Plug 'MattesGroeger/vim-bookmarks'
Plug 't9md/vim-choosewin', { 'on': ['<Plug>(choosewin)', 'ChooseWin'] }
Plug 'terryma/vim-smooth-scroll'
Plug 'takac/vim-hardtime'
Plug 'itchyny/vim-cursorword'
Plug 'kana/vim-smartword'

" completion
Plug 'shougo/neocomplete.vim'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'mxw/vim-jsx', { 'for': 'jsx' }
Plug 'ternjs/tern_for_vim', { 'do': 'npm install', 'for': 'javascript' }
Plug 'junegunn/vim-peekaboo'

" extra language support
Plug 'scrooloose/syntastic'
Plug 'sheerun/vim-polyglot'

" statusline
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" misc
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
"Plug 'benmills/vimux'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'wesQ3/vim-windowswap'

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

" Use ctrl + semicolon mapping
" http://stackoverflow.com/a/28276482/334432
nmap  [; <C-Semicolon>
"nmap! [; <C-Semicolon>

set ttyfast " faster reflow
set shortmess+=I " No intro when starting Vim
set smartindent " Smart... indent
set gdefault " The substitute flag g is on
set hidden " Hide the buffer instead of closing when switching
set synmaxcol=300 " Don't try to highlight long lines
set virtualedit=onemore,block " Allow for cursor beyond last character
set foldmethod=indent
set foldlevel=8
set foldminlines=3

set switchbuf=usetab,newtab

let base16colorspace=256
set t_Co=256
set background=light

colorscheme base16-ocean

let mapleader="\<Space>"
let g:mapleader="\<Space>"

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

" GAME ON
let g:hardtime_default_on = 1
let g:hardtime_ignore_buffer_patterns = [ "NERD.*", "undotree.*", "help.*" ]
let g:hardtime_ignore_quickfix = 1
let g:hardtime_allow_different_key = 1
let g:hardtime_maxcount = 2 " for when I hit the wrong line number
let g:list_of_normal_keys = ["j", "k", "l", ";"]
let g:list_of_visual_keys = ["j", "k", "l", ";"]
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

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.linenr = ''

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

" update the matched search background to not obscure the cursor
highlight Search ctermbg=139

" highlight long lines (but only one column)
highlight ColorColumn ctermbg=red ctermfg=white
autocmd BufWinEnter * call matchadd('ColorColumn', '\%81v', -1)

" make the ~ characters on empty lines 'invisible'
highlight NonText ctermfg=bg

" make current line number stand out (yellow)
highlight CursorLineNr ctermfg=3

" remove esc key timeout
set timeoutlen=500
set ttimeoutlen=0

set autoindent
set complete-=i

" Show incomplete commands
set showcmd

" Enable mouse mode
set mouse=a

" dont continue comments when pushing o/O
set formatoptions-=o

" No scratch (little box that shows a definition)
set completeopt-=preview

" reformat html -> each tag on own row
" nmap <leader><F3> :%s/<[^>]*>/\r&\r/g<cr>gg=G:g/^$/d<cr><leader>/

" Add proper indent when hitting <CR> inside curly braces
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_jump_expansion = 1
let g:delimitMate_balance_matchpairs = 0

let g:NERDCustomDelimiters = {
    \ 'html': {  'left': '<!-- ', 'right': '-->', 'leftAlt': '/*','rightAlt': '*/' },
    \ 'xhtml': {  'left': '<!-- ', 'right': '-->', 'leftAlt': '/*','rightAlt': '*/'},
\}
let NERD_html_alt_style=1
let NERDTreeShowHidden=1
let NERDTreeHijackNetrw = 0
let NERDTreeMinimalUI = 1
let g:NERDTreeMapOpenInTab="<C-t>"
let g:NERDTreeMapOpenSplit="<C-s>"
let g:NERDTreeMapOpenVSplit="<C-v>"
let g:NERDTreeAutoCenter = 1
let g:NERDTreeWinSize = 25
let g:NERDTreeSortHiddenFirst = 1
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

nnoremap ' <Plug>(clever-f-repeat-forward)<cr>
nnoremap , <Plug>(clever-f-repeat-back)<cr>

" QFEnter
" http://vi.stackexchange.com/questions/8534/make-cnext-and-cprevious-loop-back-to-the-begining
let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>']
let g:qfenter_vopen_map = ['<C-v>']
let g:qfenter_hopen_map = ['<C-s>']
let g:qfenter_topen_map = ['<C-t>']

" from unimpaired
nmap <silent> [l :<C-U>lprevious<CR>
nmap <silent> ]l :<C-U>lnext<CR>
nmap <silent> [q :<C-U>cprevious<CR>
nmap <silent> ]q :<C-U>cnext<CR>

" Delay opening of peekaboo window (in ms. default: 0)
let g:peekaboo_delay = 750
" vim-textobj-anyblock remap
"map iq ib

" Windowswap
let g:windowswap_map_keys = 0 "prevent default bindings
nnoremap <silent> <C-W><C-W> :call WindowSwap#EasyWindowSwap()<CR>

" camelcasemotion
autocmd VimEnter * call camelcasemotion#CreateMotionMappings(',')

map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>
map <C-t> <esc>:tabnew<CR>

" easier to reach
nnoremap [j [m
nnoremap ]j ]m

"nnoremap <C-Tab> gt
"nnoremap <C-S-Tab> gT

" paste register content and escape it
cnoremap <c-x> <c-r>=<SID>PasteEscaped()<cr>
function! s:PasteEscaped()
  echo "\\".getcmdline()."\""
  let char = getchar()
  if char == "\<esc>"
    return ''
  else
    let register_content = getreg(nr2char(char))
    let escaped_register = escape(register_content, '\'.getcmdtype())
    return substitute(escaped_register, '\n', '\\n', 'g')
  endif
endfunction

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
    vsplit
    execute "buffer " . bufferName
endfunction

nmap <C-W>u :call MergeTabs()<CR>
nnoremap <C-W>t <C-W>T

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_fuzzy_completion = 1
let g:neocomplete#enable_auto_delimiter = 1
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
nmap <Leader>aj <Plug>Argumentative_Prev
nmap <Leader>a; <Plug>Argumentative_Next
xmap <Leader>aj <Plug>Argumentative_XPrev
xmap <Leader>a; <Plug>Argumentative_XNext
nmap <Leader>a< <Plug>Argumentative_MoveLeft
nmap <Leader>a> <Plug>Argumentative_MoveRight
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
        if neosnippet#expandable_or_jumpable()
            return "\<Plug>(neosnippet_expand_or_jump)"
          else
            return "\<C-y>"
        endif
    else
        return "\<Plug>delimitMateCR"
    endif
endfunction

" <CR> close popup and save indent or expand snippet
imap <expr> <CR> CleverCr()
imap <expr> <tab> neosnippet#jumpable() ?
      \ "\<Plug>(neosnippet_jump)"
      \ : pumvisible() ? "\<C-n>" : "\<tab>"


"smap <expr><tab> neosnippet#expandable_or_jumpable() ?
"      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"

" <TAB>: completion.

inoremap <expr><S-TAB>   pumvisible() ? "\<C-p>" : "\<C-h>"

" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" Close popup by <Space>.
inoremap <expr><Space> pumvisible() ? "\<C-y>\<Space>" : "\<Space>"

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.javascript = '\%(\h\w*\|[^. \t]\.\w*\)'
let g:neocomplete#sources#omni#input_patterns.markdown = ''
let g:neocomplete#sources#omni#input_patterns.gitcommit = ''
let g:neocomplete#sources#omni#functions = get(g:, 'neocomplete#sources#omni#functions', {})

let g:neocomplete#sources#omni#functions.javascript = 'tern#Complete'

autocmd Filetype javascript setlocal omnifunc=tern#Complete

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
inoremap <M-1> <ESC>1gt
inoremap <M-2> <ESC>2gt
inoremap <M-3> <ESC>3gt
inoremap <M-4> <ESC>4gt
inoremap <M-5> <ESC>5gt
inoremap <M-6> <ESC>6gt
inoremap <M-7> <ESC>7gt
inoremap <M-8> <ESC>8gt
inoremap <M-9> <ESC>9gt

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

nnoremap <Leader>cd :lcd %:p:h<CR>

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
nmap <Leader>gf :GitFiles?<CR>
nnoremap <leader>gs :Gstatus<CR><C-W><S-T>

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

nnoremap <silent> <leader>a :ArgWrap<CR>
nnoremap <silent> <c-p> :FZF<cr>

" move horizontally
nnoremap z; 30zl
nnoremap zj 30zh

"nnoremap <leader>p p`[v`]=

nnoremap <silent> <Leader>u :UndotreeToggle<CR>
" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout = 2

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

let g:gitgutter_sign_added = '▌'
let g:gitgutter_sign_modified = '▐'
let g:gitgutter_sign_removed = '▖'
let g:gitgutter_sign_removed_first_line = '▘'
let g:gitgutter_sign_modified_removed = '▞'

" jump between changed areas (hunks)
nmap <silent> ]h :GitGutterNextHunk<CR>
nmap <silent> [h :GitGutterPrevHunk<CR>
" text objects for hunks
omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual
" stage/unstage hunk
nmap <Leader>hs <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterUndoHunk
" detailed preview of changes in hunk
nmap <Leader>hp <Plug>GitGutterPreviewHunk

" Show NERDTree
function! SmartNERDTree()
    if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
        :NERDTreeClose
    else
        :ProjectRootExe NERDTreeFind
    endif
endfunction

map <silent> <Leader>kb :call SmartNERDTree()<cr>

function! s:startup()
  let cnt = argc()
  if (cnt == 0 || cnt == 1 && isdirectory(argv(0)))
    Startify
    NERDTree
    wincmd w
  endif
endfunction

autocmd VimEnter * call s:startup()
autocmd User Startified nnoremap <buffer> k j
autocmd User Startified nnoremap <buffer> l k

let g:startify_list_order = [
    \ ['   MRU '. getcwd()], 'dir',
    \ ['   MRU'],            'files',
    \ ['   Sessions'],       'sessions',
    \ ['   Bookmarks'],      'bookmarks',
    \ ['   Commands'],       'commands',
    \ ]


" Disable netrw
let loaded_netrwPlugin = 1

" select pasted text
nmap gp `[v`]

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :execute 'tabnew ' . resolve(expand($MYVIMRC))<CR>
nmap <silent> <leader>sv :so ~/.vimrc<CR>:AirlineRefresh<CR>

nmap <silent> <leader>eh :tabnew /etc/hosts<CR>

" Sets 4 spaces as indent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set lazyredraw
set shiftround

" Show whitespace characters
set showbreak=↪\ 
set list
set listchars=tab:→\ ,trail:·,extends:›,precedes:‹,nbsp:.

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

" How many lines to scroll at a time, make scrolling appears faster
set scrolljump=5

"Allows splits to be squashed to one line
set winminheight=0
set winminwidth=0

" Turn on the WiLd menu
set wildmenu

" Vsplit when diffing (Gdiff)
set diffopt+=vertical

"Always show current position
set ruler

" Highlight current line

set cursorline relativenumber number

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
nnoremap <silent> <Leader>l :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

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
set noswapfile

" Let's save undo info!
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "", 0700)
endif

set undofile                " Save undo's after file closes
set undodir=~/.vim/undo     " where to save undo histories
set undolevels=500
set undoreload=500

set ai "Auto indent

" Default settings. (NOTE: Remove comments in dictionary before sourcing)
nmap + <Plug>(expand_region_expand)
vmap + <Plug>(expand_region_expand)
vmap _ <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'ib'  :1,
      \ 'il'  :0,
      \ 'ip'  :0,
      \ }

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

let g:tmux_navigator_no_mappings = 1
noremap <silent> <C-j> :TmuxNavigateLeft<CR>
noremap <silent> <C-k> :TmuxNavigateDown<CR>
noremap <silent> <C-l> :TmuxNavigateUp<CR>
noremap <silent> <C-Semicolon> :TmuxNavigateRight<CR>

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

nnoremap <silent> <up> :resize +5<cr>
nnoremap <silent> <down> :resize -5<cr>

" invoke with '-'
nmap - <Plug>(choosewin)
let g:choosewin_overlay_enable = 1
let g:choosewin_blink_on_land = 0
let g:choosewin_overlay_clear_multibyte = 1

" Move visual block
" http://vimrcfu.com/snippet/77
vnoremap K :m '>+1<CR>gv=gv
vnoremap L :m '<-2<CR>gv=gv

" let terminal resize scale the internal windows
" http://vimrcfu.com/snippet/186
autocmd VimResized * silent! :wincmd =

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
autocmd BufNewFile,BufRead *.scss set ft=scss.css sw=4

autocmd Filetype css setlocal iskeyword+=-

" http://vim.wikia.com/wiki/Always_start_on_first_line_of_git_commit_message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" Enhance `gf`, use these file extensions
" https://www.reddit.com/r/vim/comments/4kjgmz/weekly_vim_tips_and_tricks_thread_11/d3g6l8y
autocmd FileType javascript setl suffixesadd=.js,.jsx,.json,.html

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
" TODO: auto open/close NERDTree
nnoremap <silent> <C-w>o :ZoomToggle<CR>:NERDTreeClose<CR>:AirlineRefresh<CR>
nnoremap <silent> <C-w><C-o> :ZoomToggle<CR>:AirlineRefresh<CR>

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

" ----------------------------------------------------------------------------
" Help in new tabs
" ----------------------------------------------------------------------------
function! s:helptab()
  if &buftype == 'help'
    wincmd T
    nnoremap <buffer> q :q<cr>
  endif
endfunction
autocmd BufEnter *.txt call s:helptab()

" ----------------------------------------------------------------------------
" Clean empty buffers
" http://stackoverflow.com/a/10102604
" ----------------------------------------------------------------------------
function! s:CleanEmptyBuffers()
  let buffers = filter(range(0, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0')
  if !empty(buffers)
    exe 'bw '.join(buffers, ' ')
  endif
endfunction

autocmd BufHidden * call s:CleanEmptyBuffers()

" follow symlink and set working directory
autocmd BufWinEnter * ProjectRootLCD

" ----------------------------------------------------------------------------
" Todo
" ----------------------------------------------------------------------------
function! s:todo() abort
  let entries = []
  for cmd in ['ag --vimgrep --hidden "(TODO|FIXME|XXX|NOTE|OPTIMIZE|HACK|BUG):" 2> /dev/null']

    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif

    for line in lines
      let lst = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')
      if len(lst) < 1 | continue | endif

      let [fname, lno, text] = lst[1:3]

      " grab text after todo/fixme/xxx tag
      let mt = matchlist(text, '\(TODO\|FIXME\|XXX\|NOTE\|OPTIMIZE\|HACK\|BUG\):\(.*\)')[1:2]

      call add(entries, { 'filename': fname, 'lnum': lno, 'text': join(mt, ':') })
    endfor
    break
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction
command! Todo call s:todo()


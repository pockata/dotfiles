" Disable built in stuff
let g:loaded_vimballPlugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_rrhelper = 1
let g:did_install_default_menus = 1
let g:loaded_netrwPlugin = 1

set background=dark

" ============================================================================
" VIM PLUG {{{
" ============================================================================

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd! VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" cabbrev pc PlugClean
cabbrev ps PlugStatus
cabbrev pi PlugInstall
cabbrev pu PlugUpgrade \| PlugUpdate

" Open plug window in new tab
let g:plug_window = 'tabnew'
let g:plug_pwindow = 'vertical rightbelow new'

"}}}
" ============================================================================
" BASIC SETTINGS {{{
" ============================================================================

" syntax on

" Sets 4 spaces as indent
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set shiftround
set lazyredraw

" for gitgutter_realtime
set updatetime=250

" Show whitespace characters
set showbreak=↪\ 
set breakindent
set list
set listchars=tab:→\ ,trail:·,extends:›,precedes:‹,nbsp:.

" Sets how many lines of history VIM has to remember
set history=10000

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

set spelllang=en_us

"Always show current position
set ruler

" Highlight current line
set nocursorline
set relativenumber
set number

" augroup CursorLineOnlyInActiveWindow
"     autocmd!
"     autocmd WinEnter,BufEnter * if &diff != 1 | setlocal cursorline | endif
"     autocmd WinLeave,BufLeave * setlocal nocursorline
" augroup END

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" DO NOT WRAP
set nowrap

" Use system clipboard
set clipboard^=unnamed,unnamedplus

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

set showmatch

" Makes search act like search in modern browsers
set incsearch
if has('nvim')
    set inccommand=nosplit
endif

augroup diff_update
    au!
    au BufWritePost * if &diff == 1 | diffupdate | endif
augroup END

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
endif

" For expressions turn magic on
set magic

" How many tenths of a second to blink when matching brackets
set mat=1

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Remember info about open buffers on close
set viminfo^=%

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set noswapfile

set backupcopy=yes

" Let's save undo info!
set undofile                " Save undo's after file closes
set undolevels=500
set undoreload=500

if !has('nvim')
    set undodir=~/.vim/undo//     " where to save undo histories
    if !isdirectory(&undodir)
        call mkdir(&undodir, "", 0700)
    endif
endif

set shortmess+=Ic " No intro when starting Vim
set hidden " Hide the buffer instead of closing when switching
set synmaxcol=500 " Don't try to highlight long lines
set virtualedit=onemore,block " Allow for cursor beyond last character
set nostartofline
set nofoldenable
set foldmethod=indent
set foldlevel=0
set foldminlines=3
set nobomb
set nojoinspaces " one space after J or gq

set switchbuf=useopen,usetab

nnoremap ' `

set t_ut=

if has('termguicolors')
    " when termguicolors renders black/white
    " :h xterm-true-color
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" set cursor in split window
set splitright
set splitbelow

set nrformats-=octal

" remove esc key timeout
set timeoutlen=500
set ttimeoutlen=0

set autoindent
set complete-=i

set confirm

" Show incomplete commands
set showcmd

" Enable mouse mode
set mouse=a

set display+=uhex
" set matchpairs+=<:>

set formatoptions+=r " Insert comment leader after hitting <Enter>
set formatoptions+=o " Insert comment leader after hitting o or O in normal mode
set formatoptions+=t " Auto-wrap text using textwidth
set formatoptions+=c " Autowrap comments using textwidth
set formatoptions+=j " Delete comment character when joining commented lines

" No scratch (little box that shows a definition)
set completeopt-=preview
" set completeopt-=menu
set completeopt+=menu,menuone,noinsert,noselect

let mapleader="\<Space>"
let g:mapleader="\<Space>"

augroup vimrc
    autocmd!
augroup END

" Use ctrl + semicolon mapping
" http://stackoverflow.com/a/28276482/334432
nmap  <C-Semicolon>

" }}}
" ============================================================================
" PLUGINS {{{
" ============================================================================

call plug#begin('~/.vim/plugged')

Plug 'lilydjwg/colorizer', { 'on': '<Plug>Colorizer' }
    let g:colorizer_startup = 0
    nmap ,c <Plug>Colorizer

Plug 'gerw/vim-HiLinkTrace', { 'on': 'HLT' }

" colorschemes / start screen
Plug 'AlessandroYorba/Alduin'
Plug 'ronny/birds-of-paradise.vim'
Plug 'nightsense/wonka'
Plug 'junegunn/seoul256.vim'
    let g:seoul256_background = 236
    let g:seoul256_light_background = 255

    augroup SeoulConfig
        autocmd!

        autocmd ColorScheme seoul256-light highlight CursorLine guibg=#f2dede

        " make the ~ characters on empty lines 'invisible'
        autocmd ColorScheme * highlight EndOfBuffer guifg=#312e39

        autocmd ColorScheme seoul256 highlight Normal guibg=#312e39
        " Don't highlight the numbers line (only the editor line)
        autocmd ColorScheme seoul256 highlight CursorLineNr guibg=#312e39
        autocmd ColorScheme seoul256 highlight LineNr guibg=#312e39

        autocmd ColorScheme seoul256 highlight clear SignColumn
        autocmd ColorScheme seoul256 highlight GitGutterAdd guibg=#312e39 guifg=#b8bb26
        autocmd ColorScheme seoul256 highlight GitGutterChange guibg=#312e39 guifg=#fabd2f
        autocmd ColorScheme seoul256 highlight GitGutterDelete guibg=#312e39 guifg=#fb4934
        autocmd ColorScheme seoul256 highlight GitGutterChangeDelete guibg=#312e39 guifg=#fabd2f

        if has('nvim')
            autocmd ColorScheme seoul256 highlight Normal guibg=312e39
            " Don't highlight the numbers line (only the editor line)
            autocmd ColorScheme seoul256 highlight CursorLineNr guibg=312e39
            autocmd ColorScheme seoul256 highlight LineNr guibg=312e39
        endif
    augroup END

" Plug 'machakann/vim-highlightedyank'
"     let g:highlightedyank_highlight_duration = 100
"
"     augroup YankConfig
"         autocmd!
"         autocmd ColorScheme * highlight HighlightedyankRegion guibg=purple guifg=white
"     augroup END

" additional text objects
Plug 'kana/vim-textobj-user'
    augroup TextobjUserConfig
        autocmd!

        " PHP textobject
        autocmd VimEnter * call textobj#user#plugin('php', {
                    \   'code': {
                    \     'pattern': ['<?php\>', '?>'],
                    \     'select-a': 'aP',
                    \     'select-i': 'iP',
                    \   },
                    \ })
    augroup END

Plug 'kana/vim-textobj-function'
Plug 'thinca/vim-textobj-function-javascript'
Plug 'kentaro/vim-textobj-function-php'
Plug 'haya14busa/vim-textobj-function-syntax'

Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'
Plug 'whatyouhide/vim-textobj-xmlattr'

" Replace? with /vim-textobj-methodcall
Plug 'Chun-Yang/vim-textobj-chunk'
    let g:textobj_chunk_no_default_key_mappings = 1

    omap is <Plug>(textobj-chunk-i)
    omap as <Plug>(textobj-chunk-a)

Plug 'PeterRincker/vim-argumentative'
    let g:argumentative_no_mappings = 1

    nmap <Leader>aj <Plug>Argumentative_Prev
    nmap <Leader>a; <Plug>Argumentative_Next
    nmap <Leader>aJ <Plug>Argumentative_MoveLeft
    nmap <Leader>a: <Plug>Argumentative_MoveRight
    xmap ia <Plug>Argumentative_InnerTextObject
    xmap aa <Plug>Argumentative_OuterTextObject
    omap ia <Plug>Argumentative_OpPendingInnerTextObject
    omap aa <Plug>Argumentative_OpPendingOuterTextObject

" " TODO: Send pull request for configurable splitter_map
" Plug 'vimtaku/vim-textobj-keyvalue'

Plug 'zandrmartin/vim-textobj-blanklines'
Plug 'tkhren/vim-textobj-numeral'
    " textobj-numeral
    let g:textobj_numeral_no_default_key_mappings = 1

    vmap an <Plug>(textobj-numeral-a)
    omap an <Plug>(textobj-numeral-a)
    vmap in <Plug>(textobj-numeral-i)
    omap in <Plug>(textobj-numeral-i)

" Plug 'thinca/vim-textobj-between'

Plug 'coderifous/textobj-word-column.vim'
    let g:skip_default_textobj_word_column_mappings = 1

    xnoremap <silent> aV :<C-u>call TextObjWordBasedColumn("aw")<cr>
    onoremap <silent> aV :call TextObjWordBasedColumn("aw")<cr>
    xnoremap <silent> iV :<C-u>call TextObjWordBasedColumn("iw")<cr>
    onoremap <silent> iV :call TextObjWordBasedColumn("iw")<cr>

Plug 'glts/vim-textobj-comment'
" or thinca/vim-textobj-comment

" additional key mappings
Plug 'justinmk/vim-sneak' " GOLDEN
    let g:sneak#label = 1
    let g:sneak#streak = 1
    let g:sneak#s_next = 1
    let g:sneak#absolute_dir = 1
    let g:sneak#textobject_z = 0
    let g:sneak#use_ic_scs = 1
    let g:sneak#streak_esc = "\<CR>"

    nmap s <Plug>SneakLabel_s
    nmap S <Plug>SneakLabel_S

    " 1-character enhanced 'f'
    nmap f <Plug>Sneak_f
    nmap F <Plug>Sneak_F
    " visual-mode
    xmap f <Plug>Sneak_f
    xmap F <Plug>Sneak_F
    " operator-pending-mode
    omap f <Plug>Sneak_f
    omap F <Plug>Sneak_F

    " 1-character enhanced 't'
    nmap t <Plug>Sneak_t
    nmap T <Plug>Sneak_T
    " visual-mode
    xmap t <Plug>Sneak_t
    xmap T <Plug>Sneak_T
    " operator-pending-mode
    omap t <Plug>Sneak_t
    omap T <Plug>Sneak_T

Plug 'bkad/CamelCaseMotion'
    " camelcasemotion
    augroup CamelCaseMotionConfig
        autocmd!
        autocmd VimEnter * call camelcasemotion#CreateMotionMappings(',')
    augroup END

    imap <silent> <M-Left> <C-o><Plug>CamelCaseMotion_b
    imap <silent> <M-Right> <C-o><Plug>CamelCaseMotion_e

Plug 'christoomey/vim-tmux-navigator'
    let g:tmux_navigator_no_mappings = 1

    noremap <silent> <C-j> :TmuxNavigateLeft<CR>
    noremap <silent> <C-k> :TmuxNavigateDown<CR>
    noremap <silent> <C-l> :TmuxNavigateUp<CR>
    noremap <silent> <C-Semicolon> :TmuxNavigateRight<CR>

Plug 'triglav/vim-visual-increment'

" text manipulation / display
" TODO: configure
Plug 'jiangmiao/auto-pairs'
Plug 'FooSoft/vim-argwrap', { 'on': 'ArgWrap' }
    nnoremap <silent> <leader>aw :ArgWrap<CR>

" TODO: configure
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/inline_edit.vim'
" Plug 'AndrewRadev/whitespaste.vim'
" CONFIGURE THIS!
" Plug 'AndrewRadev/switch.vim'

" Plug 'rhysd/vim-textobj-lastinserted'

" TODO: Send issue report about not working in PHP
Plug 'adriaanzon/vim-textobj-matchit'
" If heredoc's are not covered by textobj-matchit,
" try fourjay/vim-textobj-heredoc

" for CSS
" inotom/vim-textobj-cssprop

" Collision with textobj-function?
"
" Create issue about properly adjusting visual selection
" when surrounding a string multiple times, e.g.
" value -> ['value']
Plug 'machakann/vim-sandwich'
    let g:sandwich_no_default_key_mappings = 1
    let g:operator_sandwich_no_default_key_mappings = 1
    let g:textobj_sandwich_no_default_key_mappings = 1
    let g:sandwich_no_tex_ftplugin = 1

    augroup SANDWICHConfig
        autocmd!
        autocmd VimEnter * :runtime! macros/sandwich/keymap/surround.vim
        " autocmd VimEnter * :call operator#sandwich#set('all', 'all', 'cursor', 'keep')
        autocmd VimEnter * :call operator#sandwich#set('all', 'all', 'autoindent', 4)
    augroup END


Plug 'tpope/vim-repeat'
Plug 'tomtom/tcomment_vim'

" code/project management
Plug 'airblade/vim-gitgutter'
    " Gitgutter
    let g:gitgutter_map_keys = 0
    let g:gitgutter_max_signs = 500
    let g:gitgutter_realtime = 1
    let g:gitgutter_eager = 1
    let g:gitgutter_override_sign_column_highlight = 1

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

Plug 'dbakker/vim-projectroot'
Plug 'tpope/vim-fugitive'
    nnoremap <leader>gs :tabedit %<CR>:Gstatus<CR>
    nnoremap <leader>gw :Gwrite<CR>
    nnoremap <leader>gc :Gcommit<CR>
    nnoremap <leader>gd :-tabedit %<CR>:Gdiff<CR>
    nnoremap <leader>ga :Gcommit --amend --reuse-message=HEAD

    nnoremap <leader>do :diffoff \| windo if &diff \| hide \| endif<cr>

    augroup FugitiveConfig
        autocmd!

        autocmd BufReadPost fugitive://* set bufhidden=delete
        autocmd BufRead fugitive://* xnoremap <buffer> dp :diffput<CR>|xnoremap <buffer> do :diffget<CR>

        " Got to commit tree when you go deep while browsing a repo
        autocmd User Fugitive 
                    \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
                    \   nnoremap <buffer> .. :edit %:h<CR> |
                    \ endif

        " Create [c / ]c mappings for patch diffs (GV) by jumping to the
        " next match of /^@@
        " :call search('^@@', 'sW')
        autocmd User Fugitive
                    \ if fugitive#buffer().type() == 'commit' |
                    \   nnoremap <silent> <buffer> [c :call search('^@@', 'sWb')<CR>|
                    \   nnoremap <silent> <buffer> ]c :call search('^@@', 'sW')<CR>|
                    \ endif
    augroup END

Plug 'tommcdo/vim-fugitive-blame-ext'

Plug 'rhysd/committia.vim'

    let g:committia_hooks = {}
    function! g:committia_hooks.diff_open(info)
        setlocal norelativenumber
        setlocal nonumber
        setlocal foldminlines=200
    endfunction

    function! g:committia_hooks.edit_open(info)
        " Additional settings
        setlocal spell

        " If no commit message, start with insert mode
        if a:info.vcs ==# 'git' && getline(1) ==# ''
            startinsert
        end

        " Scroll the diff window from insert mode
        " Map <C-n> and <C-p>
        imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
        imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)

    endfunction

Plug 'yssl/QFEnter'
    " http://vi.stackexchange.com/questions/8534/make-cnext-and-cprevious-loop-back-to-the-begining
    let g:qfenter_keymap = {}
    let g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>']
    let g:qfenter_keymap.vopen = ['<C-v>']
    let g:qfenter_keymap.hopen = ['<C-s>']
    let g:qfenter_keymap.topen = ['<C-t>']

Plug 'junegunn/gv.vim', { 'on': 'GV' }
    function! s:gv_expand()
        let line = getline('.')
        GV --name-status
        call search('\V'.line, 'c')
        normal! zz
    endfunction

    augroup GVConfig
        autocmd!
        autocmd FileType GV nnoremap <buffer> <silent> + :call <sid>gv_expand()<cr>
        autocmd FileType GV unmap <buffer> <c-p>
        autocmd FileType GV unmap <buffer> <c-n>
    augroup END

    nnoremap <leader>gv :GV<CR>

Plug 'rhysd/conflict-marker.vim'

Plug 'ludovicchabant/vim-gutentags'
    let g:gutentags_cache_dir = '~/.vim/gutentags'
    let g:gutentags_enabled = 0
" code searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
    let g:fzf_action = {
                \ 'ctrl-t': 'tab split',
                \ 'ctrl-s': 'split',
                \ 'ctrl-v': 'vsplit'
                \ }
    " [Buffers] Jump to the existing window if possible
    let g:fzf_buffers_jump = 1
    let g:fzf_prefer_tmux = 1
    let g:fzf_layout = { 'right': '~40%' }

    " TODO: replace this with a wrapper for the keybindings as
    " VimResized is unpredictable/inconsistent
    func! s:fzf_change_layout() abort
        if winwidth(0) < 139
            let g:fzf_layout = { 'down': '~40%' }
        else
            let g:fzf_layout = { 'right': '~40%' }
        endif
    endf

    augroup FZFConfig
        autocmd!
        autocmd VimEnter,VimResized * :call <SID>fzf_change_layout()
    augroup END

    " <leader>h conflicts with GitGutter's hunk mappings
    nnoremap <Leader>h :History<CR>
    nnoremap <Leader>j :Lines<CR>
    nnoremap <Leader>r :BLines<CR>
    nnoremap <Leader>w :Windows<CR>
    nnoremap <Leader>b :Buffers<CR>
    nnoremap <Leader>c :Commands<CR>
    nnoremap <Leader>gf :GitFiles?<CR>

    " TODO: fallback to :Files when not in a git dir? (like in smart_dirvish)
    nnoremap <c-p> :GitFiles<CR>
    nnoremap <c-t> :Files<CR>

Plug 'brooth/far.vim'

Plug 'junegunn/vim-slash'

" navigation
Plug 'itchyny/vim-cursorword'
Plug 'kana/vim-smartword'
" https://github.com/kana/vim-niceblock/
Plug 'talek/obvious-resize'
    let g:obvious_resize_default = 5
    nnoremap <silent> <Up> :<C-U>ObviousResizeUp<CR>
    nnoremap <silent> <Down> :<C-U>ObviousResizeDown<CR>
    nnoremap <silent> <Left> :<C-U>ObviousResizeLeft<CR>
    nnoremap <silent> <Right> :<C-U>ObviousResizeRight<CR>

Plug 'justinmk/vim-dirvish'
    " let g:dirvish_mode = ':sort r /[^\/]$/'
    let g:dirvish_mode = ':sort ,^.*[\/],'

    func! s:smart_dirvish() abort
        let folder = expand('%') . '.git'
        if isdirectory(folder)
            GitFiles
        else
            Files %
        endif
    endf

    augroup DirvishConfig
        autocmd!
        autocmd FileType dirvish
                    \  nnoremap <silent> <buffer> <C-t> :call dirvish#open('tabedit', 0)<CR>
                    \ |xnoremap <silent> <buffer> <C-t> :call dirvish#open('tabedit', 0)<CR>
                    \ |noremap <silent> <buffer> <C-v> :call dirvish#open('vsplit', 0)<CR>
                    \ |xnoremap <silent> <buffer> <C-v> :call dirvish#open('vsplit', 0)<CR>
                    \ |noremap <silent> <buffer> <C-s> :call dirvish#open('split', 0)<CR>
                    \ |xnoremap <silent> <buffer> <C-s> :call dirvish#open('split', 0)<CR>
                    \ |nnoremap <silent> <buffer> <c-p> :call <SID>smart_dirvish()<CR>

        " Map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
        autocmd FileType dirvish nnoremap <silent><buffer>
                    \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>
    augroup END

" alternative 
" https://github.com/Konfekt/vim-smartbraces
Plug 'justinmk/vim-ipmotion'

" completion
" Plug 'Shougo/echodoc.vim'
"     let g:echodoc#enable_at_startup = 1

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

    " Use LanguageClient's linter instead of ALE
    let g:LanguageClient_diagnosticsEnable = 0
    let g:LanguageClient_diagnosticsDisplay = {}

" npm install -g vscode-css-languageserver-bin
" npm install -g vscode-html-languageserver-bin
    let g:LanguageClient_serverCommands = {
        \ 'javascript': ['javascript-typescript-stdio'],
        \ 'javascript.jsx': ['javascript-typescript-stdio'],
        \ 'css': ['css-languageserver', '--stdio'],
        \ 'scss': ['css-languageserver', '--stdio'],
        \ 'html': ['html-languageserver', '--stdio'],
        \ 'hbs': ['html-languageserver', '--stdio'],
        \ }

        " \ 'php': ['php', expand('~/.vim/plugged/php-language-server/bin/php-language-server.php')],
    nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>

" Plug 'felixfbecker/php-language-server', {'do': 'composer install && composer run-script parse-stubs'}

Plug 'Shougo/deoplete.nvim'
    let g:deoplete#enable_at_startup = 1

    autocmd VimEnter * call deoplete#custom#source('_', 'min_pattern_length', 3)

    inoremap <silent><expr> <S-TAB>
                \ pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <silent><expr> <CR>
                \ pumvisible() ? "\<C-y>" : "\<CR>"

Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
    " install python-neovim from pacman
    set pyxversion=3

" Plug 'prabirshrestha/asyncomplete.vim'
"     inoremap <silent><expr> <S-TAB>
"                 \ pumvisible() ? "\<C-p>" : "\<S-Tab>"
"     inoremap <silent><expr> <TAB>
"                 \ pumvisible() ? "\<C-n>" : "\<Tab>"
"     inoremap <silent><expr> <CR>
"                 \ pumvisible() ? "\<C-y>" : "\<CR>"
"
"     inoremap <c-space> <Plug>(asyncomplete_force_refresh)
"
" Plug 'prabirshrestha/asyncomplete-buffer.vim'
"     autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
"         \ 'name': 'buffer',
"         \ 'whitelist': ['*'],
"         \ 'blacklist': ['go'],
"         \ 'completor': function('asyncomplete#sources#buffer#completor'),
"         \ }))
"
" Plug 'prabirshrestha/asyncomplete-file.vim'
"     autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
"         \ 'name': 'file',
"         \ 'whitelist': ['*'],
"         \ 'priority': 10,
"         \ 'completor': function('asyncomplete#sources#file#completor')
"         \ }))
"
" Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
"     if has('python3')
"         autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
"             \ 'name': 'ultisnips',
"             \ 'whitelist': ['*'],
"             \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
"             \ }))
"     endif
"
" Plug 'yami-beta/asyncomplete-omni.vim'
"         autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
"             \ 'name': 'omni',
"             \ 'whitelist': ['*'],
"             \ 'blacklist': ['html'],
"             \ 'completor': function('asyncomplete#sources#omni#completor')
"             \  }))
"
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
"
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
"
" " Language servers form vim-lsp
" Plug 'felixfbecker/php-language-server', {'do': 'composer install && composer run-script parse-stubs'}
"     autocmd User lsp_setup call lsp#register_server({
"             \ 'name': 'php-language-server',
"             \ 'cmd': {server_info->['php', expand('~/.vim/plugged/php-language-server/bin/php-language-server.php')]},
"             \ 'whitelist': ['php'],
"             \ })
"
" " https://github.com/prabirshrestha/vim-lsp/wiki/Servers-Css
" " npm install -g vscode-css-languageserver-bin
" if executable('css-languageserver')
"     autocmd User lsp_setup call lsp#register_server({
"             \ 'name': 'css-languageserver',
"             \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
"             \ 'whitelist': ['css', 'less', 'sass'],
"             \ })
" endif
"
" " https://github.com/prabirshrestha/vim-lsp/wiki/Servers-TypeScript
" " npm install -g typescript typescript-language-server
" if executable('typescript-language-server')
"     au User lsp_setup call lsp#register_server({
"       \ 'name': 'typescript-language-server',
"       \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
"       \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
"       \ 'whitelist': ['typescript', 'javascript', 'javascript.jsx']
"       \ })
" endif

" extra language support
Plug 'sheerun/vim-polyglot'
    " " These cause intense lags on HTML inside heredoc in PHP
    " let php_html_load = 1
    " let php_html_in_strings = 1

Plug 'vim-scripts/nc.vim--Eno'
Plug 'sirtaj/vim-openscad'

" Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install' }
"     let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
"     let g:deoplete#ignore_sources.php = ['omni']

Plug 'w0rp/ale'
    let g:ale_sign_warning = '!'
    let g:ale_sign_error = '✖'
    let g:ale_echo_msg_error_str = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
    let g:ale_lint_on_text_changed='never'
    let g:ale_scss_stylelint_options='--config=stylelint-config-recommended'
    let g:ale_linters = {'html': [], 'javascript': ['eslint']}
    let g:ale_set_loclist = 0

    nmap <silent> [e <Plug>(ale_previous_wrap)
    nmap <silent> ]e <Plug>(ale_next_wrap)
    nmap <leader>da ALEToggleBuffer

    augroup ALEConfig
        autocmd!
        autocmd ColorScheme seoul256 highlight clear ALEErrorSign
                                    \|highlight clear ALEWarningSign

        autocmd ColorScheme birds-of-paradise highlight ALEErrorSign guibg=#493a35 guifg=#ef5d32
                                            \ |highlight ALEWarningSign guibg=#493a35 guifg=#efac32
                                            \ |highlight ErrorMsg guibg=#ef5d32
    augroup END

" Plug 'mattn/emmet-vim', { 'on': 'EmmetInstall' }
"     let g:user_emmet_install_global = 0
"     let g:user_emmet_leader_key='<C-M>'
"
"     augroup EmmetConfig
"         autocmd!
"         autocmd FileType html,css EmmetInstall
"     augroup END

" " Automatically bookmark last files accessed by directory
" augroup filemarks
"     autocmd!
"     autocmd BufEnter *.{js,jsx,coffee} normal! mJ
"     autocmd BufEnter */parsers/*       normal! mP
"     autocmd BufEnter */epics/*         normal! mE
"     autocmd BufEnter */routes/*        normal! mR
"     autocmd BufEnter */reducers/*      normal! mS
"     autocmd BufEnter */components/*    normal! mC
"     autocmd BufEnter */utils/*         normal! mU
"     autocmd BufEnter */api/*           normal! mA
"     autocmd BufEnter */api/*           normal! mA

"     autocmd BufWinLeave */src/* normal! mQ
"     autocmd InsertEnter */src/* normal! mI
"     autocmd TextChanged	*/src/* normal! mO
"     autocmd TextChangedI */src/* normal! mO
" augroup END

" TODO: Replace with custom statusline
" https://gist.github.com/ericbn/f2956cd9ec7d6bff8940c2087247b132
" https://superuser.com/a/477221
" https://github.com/mkitt/tabline.vim/blob/master/plugin/tabline.vim
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
    let g:airline_powerline_fonts = 1
    let g:airline_theme = 'sierra'
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

    let g:airline#extensions#ale#enabled = 1

    "" enable/disable showing only non-zero hunks
    let g:airline#extensions#hunks#enabled = 0
    "let g:airline#extensions#hunks#non_zero_only = 1

    let g:airline#extensions#wordcount#enabled = 1

    " vim-windowswap integration
    let g:airline#extensions#windowswap#enabled = 1
    let g:airline#extensions#windowswap#indicator_text = 'SWAP'

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

" misc
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
    " If undotree is opened, it is likely one wants to interact with it.
    let g:undotree_SetFocusWhenToggle=1
    let g:undotree_WindowLayout = 2

    nnoremap <silent> <Leader>u :UndotreeToggle<CR>

" Plug 'tmux-plugins/vim-tmux-focus-events'

Plug 'wesQ3/vim-windowswap'
    let g:windowswap_map_keys = 0

    nnoremap <silent> <C-W><C-W> :call WindowSwap#EasyWindowSwap()<CR>

Plug 'AndrewRadev/undoquit.vim'
    nnoremap <silent> <c-w>c :call undoquit#SaveWindowQuitHistory()<cr><c-w>c

" TODO: Improve this to function like vim-ref
" sunaku/vim-dasht

Plug 'thinca/vim-ref', { 'on': 'Ref' }
    let g:ref_open='vsplit'
    let g:ref_phpmanual_path = '/tmp/php-chunked-xhtml/'
    cabbrev man Ref man

    let g:ref_source_webdict_sites = {
                \   'je': {
                \     'url': 'http://dictionary.infoseek.ne.jp/jeword/%s',
                \   },
                \   'ej': {
                \     'url': 'http://dictionary.infoseek.ne.jp/ejword/%s',
                \   },
                \   'wiki': {
                \     'url': 'http://en.wikipedia.org/wiki/%s',
                \   },
                \ }
    let g:ref_source_webdict_sites.default = 'wiki'

    function! g:ref_source_webdict_sites.wiki.filter(output)
        return join(split(a:output, "\n")[17 :], "\n")
    endfunction

    augroup RefConfig
        autocmd!
        autocmd FileType ref-* setlocal number wrap
        autocmd FileType ref-* nnoremap <buffer> <silent> q :<C-u>close<CR>
    augroup END

call plug#end()

cabbrev rg lgrep

if executable("rg")
    set grepprg=rg\ --hidden\ --glob\ '!.git'\ --vimgrep\ --with-filename
    set grepformat=%f:%l:%c:%m
endif

augroup QuickfixConfig
    autocmd!

    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
augroup END

augroup Colors
    autocmd!

    " make the precedes & extends characters red
    autocmd ColorScheme * highlight NonText guifg=red

    " update the matched search background to not obscure the cursor
    autocmd ColorScheme * highlight Search guibg=purple guifg=white

    " Highlight spelling errors
    autocmd ColorScheme * highlight SpellBad guifg=red

    " highlight long lines (but only one column)
    autocmd ColorScheme * highlight ColorColumn guibg=#cc241d guifg=#fbf1c7 ctermbg=red ctermfg=white

    let colorcolumn_blacklist = ['Startify', 'htm', 'html', 'git', 'markdown', 'GV', 'fugitiveblame', '']
    autocmd BufWinEnter * if index(colorcolumn_blacklist, &ft) < 0 |
                \ call clearmatches() |
                \ call matchadd('ErrorMsg', '\s\+$', 100) |
                \ call matchadd('ErrorMsg', '\%81v', 100)

augroup END

augroup Filetypes
    autocmd!
    autocmd FileType * setlocal sw=4 expandtab

    " make K look up the docs, not man
    autocmd FileType vim setlocal keywordprg=:help

    " follow symlink and set working directory
    autocmd! BufReadPost * call FollowSymlink() | ProjectRootLCD

    autocmd FileType apache setlocal commentstring=#%s

    autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType python     setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType css,scss   setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml        setlocal omnifunc=xmlcomplete#CompleteTags
    " autocmd FileType php        setlocal omnifunc=phpcomplete#CompletePHP
    autocmd FileType c          setlocal omnifunc=ccomplete#Complete
    autocmd FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete

    autocmd FileType markdown,gitcommit setlocal spell
    "autocmd Filetype javascript setlocal omnifunc=tern#Complete

    " Jump to first file
    autocmd BufCreate .git/index :call feedkeys("\<C-n>")
    autocmd BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    "https://www.reddit.com/r/vim/comments/3er2az/how_to_suppress_vims_warning_editing_a_read_only/
    autocmd BufEnter /etc/hosts set noro

    autocmd FileType php nnoremap <silent> <buffer> <expr> K ":silent exec \"!xdg-open 'http://php.net/en/" . expand('<cword>') . "'\"<CR>:redraw!\<CR>"

    autocmd Filetype *
                \    if &omnifunc == "" |
                \        setlocal omnifunc=syntaxcomplete#Complete |
                \    endif

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                \ |   exe "normal! g`\""
                \ | endif

    " TODO: Create a blacklist and trim everything else
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
    " autocmd BufWrite *.c :call DeleteTrailingWS()
    " autocmd BufWrite *.cpp :call DeleteTrailingWS()

    autocmd Filetype css,scss,html,htm,html.handlebars setlocal iskeyword+=-

    " Enhance `gf`, to use these file extensions
    " https://www.reddit.com/r/vim/comments/4kjgmz/weekly_vim_tips_and_tricks_thread_11/d3g6l8y
    autocmd FileType javascript setlocal suffixesadd=.js,.jsx,.json,.html

    autocmd BufWinEnter *.txt silent! if &buftype == 'help' | wincmd T | nnoremap <buffer> q :q<cr> | endif
augroup END

colorscheme birds-of-paradise

augroup EarthsongConfig
    autocmd!

    autocmd ColorScheme earthsong-light highlight Normal guibg=#FFF2EB

    " Dirvish
    autocmd ColorScheme earthsong highlight link DirvishPathTail Question
augroup END

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

nnoremap <silent> ]z :call NextClosedFold('j')<cr>
nnoremap <silent> [z :call NextClosedFold('k')<cr>
function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction

" :h complete_CTRL-E
inoremap <expr> <C-e> pumvisible() ? "\<Esc>$A" : "\<C-o>$"

" Close preview and quickfix windows.
nnoremap <silent> <C-W>z :wincmd z<Bar>cclose<Bar>lclose<CR>

" reformat html -> each tag on own row
command! FormatHTML :%s/<[^>]*>/\r&/

" from unimpaired
nnoremap <silent> [b :<C-U>bprevious<CR>
nnoremap <silent> ]b :<C-U>bnext<CR>
nnoremap <silent> [l :<C-U>lprevious<CR>
nnoremap <silent> ]l :<C-U>lnext<CR>
nnoremap <silent> [q :<C-U>cprevious<CR>
nnoremap <silent> ]q :<C-U>cnext<CR>
nnoremap <silent> [t :<C-U>tprevious<CR>
nnoremap <silent> ]t :<C-U>tnext<CR>

" if your '{' or '}' are not on the first column
" :help [[
" TODO: test this
map [[ ?{<CR>w99[{
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
map [] k$][%?}<CR>

" Muscle memory
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>

" Source
nnoremap <leader>S ^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>
vnoremap <leader>S y:@"<CR>:echo 'Sourced lines.'<CR>

" paste n format
nnoremap <leader>p p`[v`]=

" Reformat whole file and move back to original position
nnoremap g= gg=G``
nnoremap ,t :tabc<CR>

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

" Expand dirname for current file.
cnoreabbrev <expr> %% expand('%:h')

" Enable replacement in visual mode
cnoreabbrev vis s/\%V

" Insert some "Lorem ipsum" text.
inoreabbrev lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.
            \ Fusce vel orci at risus convallis bibendum eget vitae turpis. Integer
            \ sagittis risus quis lacus volutpat congue. Aenean porttitor facilisis
            \ risus, a varius purus vestibulum non. In porttitor molestie diam, nec
            \ placerat neque malesuada non. Aenean auctor, mi in suscipit bibendum, quam
            \ risus tincidunt enim, id pretium leo risus ac lectus. Ut eget nisl nunc.
            \ Vivamus vestibulum semper aliquam. Mauris rutrum convallis malesuada.

" Execute macro in q
map Q @q

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

" Move current window into tab on the left
nmap <C-W>m :call MergeTabs()<CR>
nnoremap <C-W>t <C-W>T

" Split vertically the alternate file
nnoremap <C-W>a <C-W>v<C-^>

" Execute macro over visual lines
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Switch between tabs with `alt+{num}` in the terminal
if !has('nvim')
    for nr in range(1, 9)
        execute "set <M-".nr.">=\e".nr
    endfor
endif

for nr in range(1, 9)
    " inoremap <M-1> <ESC>1gt
    execute "inoremap <M-".nr."> <ESC>".nr."gt"
    " nnoremap <M-1> 1gt
    execute "nnoremap <M-".nr."> ".nr."gt"
endfor

" " ctrl (+ shift) + Tab
" nnoremap <silent> } :tabNext<CR>
" nnoremap <silent> { :tabnext<CR>

" " move to prev/next window in tab
" nnoremap <Tab> <C-w>w
" nnoremap <S-Tab> <C-w>W

" p: go to the previously open file.
nnoremap <Leader>o <C-^>

" cd to file/project
nnoremap <silent> <Leader>cd :lcd %:h<CR>
nnoremap <silent> <Leader>cp :ProjectRootLCD<CR>

function! SearchVisualSelectionWithAg()
    execute 'Ag' s:getVisualSelection()
endfunction

function! SearchWordWithAg()
    execute 'Ag' expand('<cword>')
endfunction

nnoremap <silent> H :call SearchWordWithAg()<CR>
vnoremap <silent> H :call SearchVisualSelectionWithAg()<CR>

" "wincmd p" might not work initially, although there are two windows.
fun! MyWincmdPrevious()
    let w = winnr()
    wincmd p
    if winnr() == w
        wincmd w
    endif
endfun

" Diff this window with the previous one.
command! DiffThese diffthis | call MyWincmdPrevious() | diffthis | wincmd p

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
            \ | wincmd p | diffthis
endif

nnoremap co<space> :set <C-R>=(&diffopt =~# 'iwhite') ? 'diffopt-=iwhite' : 'diffopt+=iwhite'<CR><CR>

nnoremap <leader>as :let @a=@"<CR>:echom "Saved clipboard to @a"<CR>

func! s:get_visual_selection_list() abort
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection ==? 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return lines
endf

"read the current line into command line
cnoremap <c-r><c-l> <c-r>=getline('.')<cr>

"read last visual-selection into command line
cnoremap <c-r><c-v> <c-r>=join(<sid>get_visual_selection_list(), " ")<cr>
inoremap <c-r><c-v> <c-r>=join(<sid>get_visual_selection_list(), " ")<cr>

" ----------------------------------------------------------------------------
" Readline-style key bindings in command-line (excerpt from rsi.vim)
" ----------------------------------------------------------------------------
cnoremap <C-A> <Home>

" Make Ctrl-a/e jump to the start/end of the current line in the insert mode
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^

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

" move horizontally
nnoremap z; 30zl
nnoremap zj 30zh

function! s:startup()
    if exists('g:loaded_startify')
        return
    endif

    let cnt = argc()

    if (cnt == 0)
        Dirvish
    elseif (cnt == 1 && isdirectory(argv(0)))
        exe "cd " . argv(0)
        Dirvish
    endif
endfunction

autocmd vimrc VimEnter * call s:startup()
" autocmd User Startified wincmd v | Gstatus | wincmd k

" select pasted text
nnoremap gp `[v`]

" select inserted text
" https://vimrcfu.com/snippet/145
nnoremap gi `[v`]

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :execute 'vsplit ' . resolve("~/.vimrc")<CR>
nmap <silent> <leader>sv :so ~/.vimrc<CR>:AirlineRefresh<CR>

" Open hosts file
nmap <silent> <leader>eh :vsplit /etc/hosts<CR>
nmap <silent> <leader>ed :tabe ~/dotfiles<CR>
nmap <silent> <leader>ep :tabe ~/Projects<CR>

" Don't implode
noremap j h

" Move vertically by visual line unless preceded by a count. If a movement is
" greater than 5 then automatically add to the jumplist.
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
xnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
onoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> l v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'
xnoremap <expr> l v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'
onoremap <expr> l v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

noremap ; l

nnoremap gk j
nnoremap gl k

noremap <C-w>j <C-w>h
noremap <C-w>k <C-w>j
noremap <C-w>l <C-w>k
noremap <C-w>; <C-w>l

" Change shape of cursor in different modes
if !has("gui_running") && !has("nvim")
    " if &term == 'screen-256color'
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
endif

if has('nvim')
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc

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
" TODO: find a plugin
nnoremap <silent> <C-w>o :ZoomToggle<CR>
nnoremap <silent> <C-w><C-o> :ZoomToggle<CR>

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
" Clean empty buffers
" http://stackoverflow.com/a/10102604
" ----------------------------------------------------------------------------
function! s:CleanEmptyBuffers()
    let buffers = filter(range(0, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0')
    if !empty(buffers)
        silent! exe 'bw '.join(buffers, ' ')
    endif
endfunction

autocmd vimrc BufHidden * silent! call <SID>CleanEmptyBuffers()

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

" https://github.com/StanAngeloff/dotfiles/blob/master/.vimrc
" TODO: handle jkl;
set langmap+=чявертъуиопшщасдфгхйклзьцжбнмЧЯВЕРТЪУИОПШЩАСДФГХЙКЛЗѝЦЖБНМ;`qwertyuiop[]asdfghjklzxcvbnm~QWERTYUIOP{}ASDFGHJKLZXCVBNM,ю\\,Ю\|,

" follow symlinked file
function! FollowSymlink()
    let current_file = expand('%:p')
    " check if file type is a symlink
    if getftype(current_file) == 'link'
        " if it is a symlink resolve to the actual file path
        "   and open the actual file
        let actual_file = resolve(current_file)
        execute 'file ' . actual_file

        redraw
    end
endfunction

" a little more informative version of the above
nmap <Leader>sI :call <SID>SynStack()<CR>

function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" ----------------------------------------------------------------------------
" Todo
" ----------------------------------------------------------------------------

" TODO: Add bang! option to use regex without semicolon
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

" ----------------------------------------------------------------------------
" Profile
" ----------------------------------------------------------------------------
function! s:profile(bang)
    if a:bang
        profile pause
        noautocmd qall
    else
        profile start /tmp/profile.log
        profile func *
        profile file *
    endif
endfunction
command! -bang Profile call s:profile(<bang>0)

" Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap <silent> <Leader>l :nohlsearch<BAR><C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" un-join (split) the current line at the cursor position
" TODO: Fix collision with splitjoin
nnoremap g<CR> i<c-j><esc>k$

function! s:plugs_sink(line)
    let dir = g:plugs[a:line].dir
    for pat in ['doc/*.txt', 'README.md']
        let match = get(split(globpath(dir, pat), "\n"), 0, '')
        if len(match)
            execute 'tabedit' match
            return
        endif
    endfor
    tabnew
    execute 'Dirvish' dir
endfunction

command! Plugs call fzf#run(fzf#wrap({
    \ 'source':  sort(keys(g:plugs)),
    \ 'sink':    function('s:plugs_sink')}))

" command! Plugs call fzf#run({
"   \ 'source':  map(sort(keys(g:plugs)), 'g:plug_home."/".v:val'),
"   \ 'options': '--delimiter / --nth -1',
"   \ 'down':    '~40%',
"   \ 'sink':    'Dirvish'})

" Edit the contents of a register.
func! s:edit_reg() abort
  let c = nr2char(getchar())
  call feedkeys(":let @".c."='".c."'\<C-F>")
endfunc
nnoremap <silent> c" :call <SID>edit_reg()<CR>

" Scratch file
" https://www.reddit.com/r/vim/comments/7iy03o/you_aint_gonna_need_it_your_replacement_for/dr2qo4k/
command! SC vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile

function! RenameFile() abort
    let old_name = expand('%')
    let new_name = input('[Renaming File] New file: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction

command! Rename call RenameFile()

" re-highlight file
nnoremap <silent><F6> <ESC>:execute 'colo' colors_name<cr>:syntax sync fromstart<cr>

nnoremap got :call system('urxvt -cd '.getcwd().' &')<cr>
nnoremap goT :call system('urxvt -cd '.expand("%:p:h").' &')<cr>

" ----------------------------------------------------------------------------
" :Count
" ----------------------------------------------------------------------------
command! Count execute printf('%%s/%s//gn', escape(<q-args>, '/')) | normal! ``


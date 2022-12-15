-- Use ctrl + semicolon mapping
-- http://stackoverflow.com/a/28276482/334432
nmap("", "<C-Semicolon>")

-- backtick is harder to reach so remap it
nnoremap("'", "`")

-- Close preview and quickfix windows
nmap("<C-W>z", '<silent>', ":wincmd z<Bar>cclose<Bar>lclose<CR>")

-- from unimpaired
nmap('[b', '<silent>', ':<C-U>bprevious<CR>')
nmap(']b', '<silent>', ':<C-U>bnext<CR>')
nmap('[l', '<silent>', ':<C-U>lprevious<CR>')
nmap(']l', '<silent>', ':<C-U>lnext<CR>')
nmap('[q', '<silent>', ':<C-U>cprevious<CR>')
nmap(']q', '<silent>', ':<C-U>cnext<CR>')
nmap('[t', '<silent>', ':<C-U>tabprevious<CR>')
nmap(']t', '<silent>', ':<C-U>tabnext<CR>')

-- quick tab moving
nnoremap('<t', ':tabmove -1<CR>')
nnoremap('>t', ':tabmove +1<CR>')

-- Superceded by Treesitter textobjects
-- -- if your '{' or '}' are not on the first column
-- -- :help [[
-- -- TODO: test this
-- noremap('[[', '?{<CR>w99[{')
-- noremap('][', '/}<CR>b99]}')
-- noremap(']]', 'j0[[%/{<CR>')
-- noremap('[]', 'k$][%?}<CR>')

-- Muscle memory
noremap('<C-s>', '<esc>:w<CR>')
inoremap('<C-s>', '<esc>:w<CR>')

-- Jump by half a page and center the cursor vertically
nnoremap("<c-d>", "<c-d>zz")
nnoremap("<c-u>", "<c-u>zz")


-- hm?
nnoremap("J", "mzJ`z")

-- Source
nmap("<leader>S", "^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>")
vmap('<leader>S', "y:@\"<CR>:echo 'Sourced lines.'<CR>")

-- paste n format
nmap('<leader>p', 'p`[v`]=')

-- Reformat whole file and move back to original position
nmap('g=', "gg=G``")
nmap(',t', ":tabc<CR>")

-- Copy current buffer path to system clipboard
-- I picked 5 because it's also the '%' key.
nmap('<Leader>5', '<silent>', ':let @+ = expand("%:p")<CR>:echom "copied: " . expand("%:p")<CR>')

-- Execute the last macro
nmap('Q', "@@")

-- Split vertically the alternate file
nmap('<C-W>a', "<C-W>v<C-^>")
-- Warn about no alternative file
-- nnoremap <C-W>a :expand('#') != '' ? '\<C-W>v\<C-^>' : echom "No alternate file"

-- simplify moving the pane to another window
nnoremap('<C-W>t', '<C-W>T')

-- Switch between tabs with `alt+{num}` in the terminal
for i = 1, 9 do
	-- inoremap <M-1> <ESC>1gt
	imap(string.format("<M-%d>", i), string.format("<ESC>%dgt", i))
	-- nnoremap <M-1> 1gt
	nmap(string.format("<M-%d>", i), string.format("%dgt", i))
end

-- -- ctrl (+ shift) + Tab
-- nnoremap <silent> } :tabNext<CR>
-- nnoremap <silent> { :tabnext<CR>

-- -- move to prev/next window in tab
-- TODO: Figure out why <tab> conflicts with <c-i>
-- nmap('<Tab>', "<C-w>w")
-- nmap('<S-Tab>', "<C-w>W")

-- p: go to the previously open file.
nmap('<Leader>o', "<C-^>")


-- change whitespace option while diffing
nmap('co<space>', ":set <C-R>=(&diffopt =~# 'iwhite') ? 'diffopt-=iwhite' : 'diffopt+=iwhite'<CR><CR>")

-- save the current clipboard contents to the register `a`
nmap('<leader>as', ':let @a=@"<CR>:echom "Saved clipboard to @a"<CR>')

-- Readline-style key bindings in command-line (excerpt from rsi.vim)
cmap('<C-A>', "<Home>")

-- Make Ctrl-a/e jump to the start/end of the current line in the insert mode
imap('<C-e>', '<expr>', [[pumvisible() ? '<Esc>$A' : '<C-o>$']])
imap('<C-a>', "<C-o>^")

-- move horizontally
nmap('z;', "30zl")
nmap('zj', "30zh")

-- select pasted text
nnoremap('gp', "`[v`]")

-- Thanks Prime. Set an Undo break point
inoremap(',', ',<c-g>u')
inoremap('.', '.<c-g>u')
inoremap('/', '/<c-g>u')

-- Move lines around without using `ddp`
vnoremap('K', ":m '>+1<CR>gv=gv")
vnoremap('L', ":m '<-2<CR>gv=gv")

-- Keep visual mode indenting
xnoremap("<", "<silent>", "<gv")
xnoremap(">", "<silent>", ">gv")

-- paste without yanking in visual mode with `P`
xnoremap("P", '<expr>', "'\"_d\"'.v:register.'P'")

-- select inserted text
-- https://vimrcfu.com/snippet/145
nnoremap('gi', "`[v`]")

-- limit scope of search to visual selection
-- https://www.reddit.com/r/vim/comments/df852s/tip_use_v_to_limit_scope_of_search_to_visual/
xnoremap('/', [[<Esc>`</\%V\v]])
xnoremap('?', [[<Esc>`>?%V\v]])
xnoremap('s', [[<Esc>:'<,'>s/\%V]])

-- replace current word under cursor
nnoremap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/I<Left><Left>")

-- default in nvim 0.6
-- -- https://www.reddit.com/r/vim/comments/dgbr9l/mappings_i_would_change_for_more_consistent_vim/
-- nnoremap('Y', "y$")

-- Quickly edit/reload the vimrc file
-- nmap('<leader>ev', '<silent>', ":execute 'vsplit ' . resolve('~/.config/nvim/init.lua')<CR>")
nmap('<leader>eo', '<silent>', ":execute 'vsplit ' . resolve('~/dotfiles/vim/vim-nvim-compat.vim')<CR>")
-- nmap('<leader>sv', '<silent>', ':so ~/.vimrc<CR>:AirlineRefresh<CR>')

-- Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap('<Leader>l', '<silent>', ":nohlsearch<BAR><C-R>=&diff?'<Bar>diffupdate':''<CR><CR><C-L>")

nmap('goT', ":call system('alacritty --working-directory '.getcwd().' &')<CR>")
nmap('got', ":call system('alacritty --working-directory '.expand(\"%:p:h\").' &')<CR>")

-- Disable buffer maps set in man.vim
vim.g.no_man_maps=1

-- The keybinds that can get me thrown into jail
noremap('j', "h")

-- Move vertically by visual line unless preceded by a count. If a movement is
-- greater than 5 then automatically add to the jumplist.
noremap('k', '<expr>', "v:count ? (v:count > 3 ? \"m'\" . v:count : '') . 'j' : 'gj'")
noremap('l', '<expr>', "v:count ? (v:count > 3 ? \"m'\" . v:count : '') . 'k' : 'gk'")

noremap(';', "l")

nmap('gk', "j")
nmap('gl', "k")

-- ; is useful with f/t so remap it to '
nnoremap("'", ";")

-- Navigate folds
nnoremap("]z", "<silent>", ":call NextClosedFold('j')<cr>")
nnoremap("[z", "<silent>", ":call NextClosedFold('k')<cr>")

-- View highlight groups under cursor
nnoremap("<leader>sI", "<silent>", ":TSHighlightCapturesUnderCursor<cr>")

-- -- Shrug ¯\_(ツ)_/¯
-- inoremap("#shrug", [[¯\_(ツ)_/¯]])

-- nnoremap <leader>gll :let g:_search_term = expand("%")<CR><bar>:Gclog -- %<CR>:call search(g:_search_term)<CR>
-- nnoremap <leader>gln :cnext<CR>:call search(_search_term)<CR>
-- nnoremap <leader>glp :cprev<CR>:call search(_search_term)<CR>

-- delete without copying
nnoremap("<Leader>d", '"_d')
vnoremap("<Leader>d", '"_d')

nnoremap("<Leader>c", '"_c')
vnoremap("<Leader>c", '"_c')

-- add empty lines before/after the cursor. from unimpaired.vim
vim.cmd [[
function! BlankUp(count) abort
  put!=repeat(nr2char(10), a:count)
  ']+1
  silent! call repeat#set("\<Plug>unimpairedBlankUp", a:count)
endfunction

function! BlankDown(count) abort
  put =repeat(nr2char(10), a:count)
  '[-1
  silent! call repeat#set("\<Plug>unimpairedBlankDown", a:count)
endfunction

nnoremap <silent> [<space>   :<C-U>call BlankUp(v:count1)<CR>
nnoremap <silent> ]<space> :<C-U>call BlankDown(v:count1)<CR>
inoremap <silent> <S-Enter>   <ESC>:call BlankDown(v:count1)<CR>i
]]



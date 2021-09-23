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
nmap('[t', '<silent>', ':<C-U>tprevious<CR>')
nmap(']t', '<silent>', ':<C-U>tnext<CR>')

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

-- paste without yanking in visual mode with `P`
xnoremap("P", '<expr>', "'\"_d\"'.v:register.'P'")

-- select inserted text
-- https://vimrcfu.com/snippet/145
nnoremap('gi', "`[v`]")

-- go substitute because the default map for sleeping is silly
-- https://vimrcfu.com/snippet/191
--
-- TODO: Conflicts with Switch.vim
nnoremap('gs', ":%s//g<Left><Left>")
xnoremap('gs', ":s//g<Left><Left>")

-- limit scope of search to visual selection
-- https://www.reddit.com/r/vim/comments/df852s/tip_use_v_to_limit_scope_of_search_to_visual/
-- TODO: Add mappings for replace (:s/)
xnoremap('/', [[<Esc>`</\%V\v]])
xnoremap('?', [[<Esc>`>?%V\v]])

-- https://www.reddit.com/r/vim/comments/dgbr9l/mappings_i_would_change_for_more_consistent_vim/
nnoremap('Y', "y$")

-- Quickly edit/reload the vimrc file
-- nmap('<leader>ev', '<silent>', ":execute 'vsplit ' . resolve('~/.config/nvim/init.lua')<CR>")
nmap('<leader>eo', '<silent>', ":execute 'vsplit ' . resolve('~/dotfiles/vim/vim-nvim-compat.vim')<CR>")
-- nmap('<leader>sv', '<silent>', ':so ~/.vimrc<CR>:AirlineRefresh<CR>')

-- Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap('<Leader>l', '<silent>', ":nohlsearch<BAR><C-R>=&diff?'<Bar>diffupdate':''<CR><CR><C-L>")

nmap('goT', ":call system('urxvt -cd '.getcwd().' &')<CR>")
nmap('got', ":call system('urxvt -cd '.expand(\"%:p:h\").' &')<CR>")


-- The keybinds that can get me thrown into jail
noremap('j', "h")

-- Move vertically by visual line unless preceded by a count. If a movement is
-- greater than 5 then automatically add to the jumplist.
noremap('k', '<expr>', "v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'j' : 'gj'")
noremap('l', '<expr>', "v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'k' : 'gk'")

noremap(';', "l")

-- nmap('gk', "j")
-- nmap('gl', "k")

-- Navigate folds
nnoremap("]z", "<silent>", ":call NextClosedFold('j')<cr>")
nnoremap("[z", "<silent>", ":call NextClosedFold('k')<cr>")


local o = vim.o
local wo = vim.wo
local bo = vim.bo

-- use tabs for indent
o.shiftround = true

create_augroup(
	'set_tabsize',
	'FileType * setlocal autoindent noexpandtab tabstop=4 shiftwidth=4'
)

create_augroup('set_iskeyword', {
	'Filetype * setlocal iskeyword+=-'
})

-- don't draw every frame when doing macros
o.lazyredraw = true

-- for git status in beside the line numbers
o.updatetime = 250
wo.signcolumn = "yes"

wo.breakindent = true

-- show spaces
wo.list = true
vim.o.listchars = 'tab:  ,lead:·,trail:·,extends:›,precedes:‹,nbsp:␣'

-- always keep this much lines/chars visible around the cursor
o.scrolloff = 7
o.sidescrolloff = 7
o.scrolljump = 7


-- Allows splits to be squashed to one line (for ZoomToggle)
o.winminheight = 0
o.winminwidth = 0

-- diff options
o.diffopt = o.diffopt .. ",vertical"

create_augroup('diff_update', 'BufWritePost * if &diff == 1 | diffupdate | endif')

-- handle wrapping
o.whichwrap = "b,s,<,>,h,l"
o.wrap = false

-- clipboard
o.clipboard = "unnamedplus"

-- hide current mode (shown in status line instead)
o.showmode = false

-- search & replace
o.ignorecase = true
o.smartcase = true
o.inccommand = "nosplit"

-- save undo history
o.undofile = true

-- TODO: Get alternative or implement with Lua
-- augroup BufWritePre /tmp/* setlocal noundofile

-- UI
wo.number = true
wo.relativenumber = true

wo.cursorline = true
create_augroup('CursorLineOnlyInActiveWindow', {
	'WinEnter,BufEnter * if &diff != 1 | setlocal cursorline | endif',
	'WinLeave,BufLeave * setlocal nocursorline'
})

o.shortmess = o.shortmess .. "Ic" -- remove intro when starting Vim
o.hidden = true -- allow switching buffers without saving
bo.synmaxcol = 500 -- don't highlight long lines
o.termguicolors = true -- use true colors in TUI
o.splitright = true
o.splitbelow = true

o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Editing
o.virtualedit = "onemore,block" -- allow for cursor beyond last character
o.joinspaces = false -- one space after J or gq
o.switchbuf = "uselast"
o.confirm = true -- show confirmation for actions that abort immediately
o.mouse = "a" -- always allow mouse usage
o.display = o.display .. ",uhex"

-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/options.lua#L71
-- insert comment leader after hitting <Enter>
bo.formatoptions = bo.formatoptions .. "r"
-- insert comment leader after hitting o or O in normal mode
bo.formatoptions = bo.formatoptions .. "o"
-- auto-wrap text using textwidth
bo.formatoptions = bo.formatoptions .. "t"
-- autowrap comments using textwidth
bo.formatoptions = bo.formatoptions .. "c"
-- delete comment character when joining commented lines
bo.formatoptions = bo.formatoptions .. "j"
-- break long lines in insert mode
bo.formatoptions = bo.formatoptions .. "l"

-- o.completeopt = "menuone,noinsert,noselect"
o.completeopt = "menuone,noselect"

-- Folding
wo.foldmethod = 'manual'
-- wo.foldexpr = 'nvim_treesitter#foldexpr()'
wo.foldminlines = 5

-- vim.wo.foldcolumn = '0' -- defines 1 col at window left, to indicate folding
-- vim.o.foldlevelstart = 99 -- start file with all folds opened
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

-- MISC
o.timeoutlen = 500
o.ttimeoutlen = 0
bo.bomb = false -- don't write a BOM mark at the start of the file

vim.g.mapleader = " "

create_augroup('YankHighlight',
	{'TextYankPost * silent! lua vim.highlight.on_yank()'}
)


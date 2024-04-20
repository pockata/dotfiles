local opt = vim.opt
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

o.spell = false
-- spellopts doesn't work if set via opt directly
-- o.spelloptions = "noplainbuffer,camel"
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function ()
		vim.opt_local.spelloptions = "noplainbuffer,camel"
	end
})

-- for git status in beside the line numbers
o.updatetime = 50
vim.opt.swapfile = false
vim.opt.backup = false

wo.signcolumn = "yes"

wo.breakindent = true

-- show spaces
wo.list = true
vim.o.listchars = 'tab:  ,lead:·,trail:·,extends:›,precedes:‹,nbsp:␣'

-- always keep this much lines/chars visible around the cursor
-- TODO: Autocmd to set scrolloff to 20 on tall screens so `zt` and `zb`
-- is reasonable
o.scrolloff = 7
o.sidescrolloff = 7
o.scrolljump = 7

o.gdefault = true

-- Allows splits to be squashed to one line (for ZoomToggle)
o.winminheight = 0
o.winminwidth = 0

-- diff options
o.diffopt = o.diffopt .. ",vertical,algorithm:histogram,linematch:60"

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
-- default in nvim 0.6
-- o.inccommand = "nosplit"

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

o.shortmess = o.shortmess .. "c" -- remove intro when starting Vim
-- o.hidden = true -- allow switching buffers without saving
bo.synmaxcol = 500 -- don't highlight long lines
o.termguicolors = true -- use true colors in TUI
o.splitright = true
o.splitbelow = true

o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Editing
o.virtualedit = "block" -- allow for cursor beyond last character
-- o.joinspaces = false -- one space after J or gq
-- o.switchbuf = "uselast"
o.confirm = true -- show confirmation for actions that abort immediately
o.mouse = "a" -- always allow mouse usage
-- o.display = o.display .. ",uhex"

-- https://github.com/tjdevries/config_manager/blob/eb8c846bdd480e6ed8fb87574eac09d31d39befa/xdg_config/nvim/plugin/options.lua#L84
opt.formatoptions = opt.formatoptions
+ "r" -- insert comment leader after hitting <Enter>
- "o" -- insert comment leader after hitting o or O in normal mode
+ "/" -- do not insert the comment leader for a // comment after a statement, only when // is at the start of the line.
+ "t" -- auto-wrap text using textwidth
+ "c" -- autowrap comments using textwidth
+ "j" -- delete comment character when joining commented lines
+ "l" -- break long lines in insert mode
+ "q" -- allow formatting comments w/ gq
+ "n" -- respect numbered lists when formatting text

o.completeopt = "menuone,noinsert,noselect"
-- o.completeopt = "menuone,noselect"

-- Folding
wo.foldmethod = 'manual'
wo.foldexpr = 'nvim_treesitter#foldexpr()'
wo.foldminlines = 5

-- vim.wo.foldcolumn = '0' -- defines 1 col at window left, to indicate folding
-- vim.o.foldlevelstart = 99 -- start file with all folds opened
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

-- MISC
o.timeoutlen = 500
o.ttimeoutlen = 0
-- bo.bomb = false -- don't write a BOM mark at the start of the file

vim.g.mapleader = " "
vim.g.maplocalleader = ","

create_augroup('YankHighlight',
	{ 'TextYankPost * silent! lua vim.highlight.on_yank()' }
)

-- vim.cmd [[colorscheme gruvbox]]

create_augroup('GlobalColorConfig', {
	'ColorScheme * highlight EndOfBuffer guifg=bg',

	'ColorScheme * highlight SignColumn guibg=bg',
	-- 'ColorScheme * highlight GitSignsAdd guibg=bg',
	-- 'ColorScheme * highlight GitSignsChange guibg=bg',
	-- 'ColorScheme * highlight GitSignsDelete guibg=bg',
	-- 'ColorScheme * highlight GitSignsChangeDelete guibg=bg',
})

-- TODO: Make a PR to packer.nvim for a new user autocommand for loading things
-- after all plugins load
vim.cmd [[colorscheme deus]]


-- vim.cmd [[colorscheme gruvbox]]
vim.cmd([[
	augroup GlobalScheme
		autocmd!
		autocmd ColorScheme * highlight EndOfBuffer guifg=bg
		autocmd ColorScheme * highlight SignColumn guibg=bg
		" make the line numbers more prominent (useful for :set rnu)
		autocmd ColorScheme * highlight LineNr guifg=fg

		" autocmd ColorScheme * highlight GitSignsAdd guibg=bg,
		" autocmd ColorScheme * highlight GitSignsChange guibg=bg,
		" autocmd ColorScheme * highlight GitSignsDelete guibg=bg,
		" autocmd ColorScheme * highlight GitSignsChangeDelete guibg=bg,
	augroup END
]])

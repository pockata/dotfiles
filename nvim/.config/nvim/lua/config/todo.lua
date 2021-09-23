require("todo-comments").setup {
	signs = false,
	-- highlight only the keyword
	highlight = {
		keyword = "bg",
		after = "",
	},
	search = {
		command = "rg",
		args = {
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--hidden",
		},
	}
}

-- add a little alias
vim.cmd [[command! Todo TodoTelescope]]


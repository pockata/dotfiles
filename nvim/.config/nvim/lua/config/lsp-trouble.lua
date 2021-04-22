require("trouble").setup {
	action_keys = {
		previous = "l",
		next = "k",
	}
}

nnoremap("<leader>xx", "<cmd>LspTroubleToggle<CR>")


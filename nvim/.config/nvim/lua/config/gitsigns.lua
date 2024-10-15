require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "-" },
		topdelete = { text = "-" },
		changedelete = { text = "~_" },
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				return "]czz"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[czz"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "<leader>hs", '<cmd>lua require"gitsigns".stage_hunk()<CR>')
		map("v", "<leader>hs", '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>')
		map("n", "<leader>hu", '<cmd>lua require"gitsigns".reset_hunk()<CR>')
		map("n", "<leader>hR", '<cmd>lua require"gitsigns".reset_buffer()<CR>')
		map("n", "<leader>hp", '<cmd>lua require"gitsigns".preview_hunk()<CR>')
		map("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line()<CR>')

		-- Text objects
		map("o", "ih", ':<C-U>lua require"gitsigns".select_hunk()<CR>')
		map("x", "ih", ':<C-U>lua require"gitsigns".select_hunk()<CR>')
		map("o", "ah", ':<C-U>lua require"gitsigns".select_hunk()<CR>')
		map("x", "ah", ':<C-U>lua require"gitsigns".select_hunk()<CR>')
	end,
})

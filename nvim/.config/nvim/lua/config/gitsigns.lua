require('gitsigns').setup {
	signs = {
		-- -- add          = { text = '▌' },
		-- -- change       = { text = '▐' },
		-- -- delete       = { text = '▖' },
		-- -- topdelete    = { text = '▘' },
		-- -- changedelete = { text = '▞' },
		add          = {hl = 'diffAdded'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
		change       = {hl = 'diffChanged', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
		delete       = {hl = 'diffDeleted', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
		topdelete    = {hl = 'diffDeleted', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
		changedelete = {hl = 'diffRemoved', text = '~_', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
	},
	keymaps = {
		-- Default keymap options
		noremap = true,
		buffer = true,

		['n ]c'] = { expr = true, "&diff ? ']czz' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>zz'"},
		['n [c'] = { expr = true, "&diff ? '[czz' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>zz'"},

		['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
		['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
		['n <leader>hu'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
		['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
		['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
		['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

		-- Text objects
		['o ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
		['x ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
		['o ah'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
		['x ah'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>'
	}
}


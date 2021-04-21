require('nvim-treesitter.configs').setup({
	ensure_installed = {
		'bash', 'comment', 'cpp', 'css', 'go', 'html',
		'javascript', 'json', 'jsonc', 'lua', 'regex',
		'typescript', 'yaml'
	},
	highlight = {
		enable = true
	},
	playground = {
		enable = true,
		disable = {},
		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
		persist_queries = false -- Whether the query persists across vim sessions
	},
	-- for playground
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = {"BufWrite", "CursorHold"},
	},
	textobjects = {
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
				["]a"] = "@parameter.inner",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
				["[a"] = "@parameter.inner",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<Leader>a:"] = "@parameter.inner",
			},
			swap_previous = {
				["<Leader>aJ"] = "@parameter.inner",
			},
		},
		select = {
			enable = true,
			keymaps = {
				-- use the queries from supported languages with textobjects.scm
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ia'] = '@parameter.inner',
				['aa'] = '@parameter.outer',
				-- ['aC'] = '@class.outer',
				-- ['iC'] = '@class.inner',
				['ao'] = '@conditional.outer',
				['io'] = '@conditional.inner',
				['as'] = '@block.outer',
				['is'] = '@block.inner',
				['al'] = '@loop.outer',
				['il'] = '@loop.inner',
				-- ['is'] = '@statement.inner',
				-- ['as'] = '@statement.outer',
				['ac'] = '@comment.outer',
				['am'] = '@call.outer',
				['im'] = '@call.inner',
			}
		},
	},
	indent = {
		enable = true
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			-- TODO: better keybindings
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	}
})


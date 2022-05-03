require('nvim-treesitter.configs').setup({
	ensure_installed = {
		'bash', 'comment', 'cpp', 'css', 'go', 'html',
		'javascript', 'json', 'jsonc', 'lua', 'regex',
		'typescript', 'yaml'
	},
	highlight = {
		enable = true,
		-- for better syntax highlighting
		-- https://github.com/CodeGradox/onehalf-lush
		additional_vim_regex_highlighting = false,
	},
	matchup = {
		enable = true,
	},
	context_commentstring = {
		-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#commentnvim
		enable = true,
		enable_autocmd = false,
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
				["]f"] = "@function.outer",
				["]]"] = "@class.outer",
				["]a"] = "@parameter.inner",
				-- jump to the next variable assignment
				[']v'] = '@p.assign.key',
			},
			goto_next_end = {
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
				["[["] = "@class.outer",
				["[a"] = "@parameter.inner",
				-- jump to the prev variable assignment
				['[v'] = '@p.assign.key',
			},
			goto_previous_end = {
			},
		},
		-- swap = {
		-- 	enable = true,
		-- 	swap_next = {
		-- 		["<Leader>a:"] = "@parameter.inner",
		-- 	},
		-- 	swap_previous = {
		-- 		["<Leader>aJ"] = "@parameter.inner",
		-- 	},
		-- },
		select = {
			enable = true,
			-- like in targets.vim
			lookahead = false,
			keymaps = {
				-- use the queries from supported languages with textobjects.scm
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['iv'] = '@p.assign.value',
				['ik'] = '@p.assign.key',
				['av'] = '@p.assign.value',
				['ak'] = '@p.assign.key',
				-- ['ia'] = '@parameter.inner',
				-- ['aa'] = '@parameter.outer',
				-- -- ['aC'] = '@class.outer',
				-- -- ['iC'] = '@class.inner',
				-- ['ao'] = '@conditional.outer',
				-- ['io'] = '@conditional.inner',
				-- ['as'] = '@block.outer',
				-- ['is'] = '@block.inner',
				-- -- ['al'] = '@loop.outer',
				-- -- ['il'] = '@loop.inner',
				-- -- ['is'] = '@statement.inner',
				-- -- ['as'] = '@statement.outer',
				-- ['ac'] = '@comment.outer',
				-- ['ic'] = '@comment.inner',
				-- ['am'] = '@call.outer',
				-- ['im'] = '@call.inner',
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


require('nvim-treesitter.configs').setup({
	ensure_installed = {
		'bash', 'comment', 'cpp', 'css', 'go', 'html',
		'javascript', 'json', 'jsonc', 'lua', 'regex',
		'typescript', 'yaml', 'query'
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	matchup = {
		enable = true,
		disable_virtual_text = true,
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
		persist_queries = false, -- Whether the query persists across vim sessions
		keybindings = {
			toggle_query_editor = 'o',
			toggle_hl_groups = 'i',
			toggle_injected_languages = 't',
			toggle_anonymous_nodes = 'a',
			toggle_language_display = 'I',
			focus_language = 'f',
			unfocus_language = 'F',
			update = 'R',
			goto_node = '<cr>',
			show_help = '?',
		},
	},
	-- for playground
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	},
	textobjects = {
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]f"] = "@function.outer",
				-- ["]]"] = "@class.outer",
				-- ["]a"] = "@parameter.inner",
				-- jump to the next variable assignment
				[']v'] = '@p.assign.key',
			},
			goto_next_end = {},
			goto_previous_start = {
				["[f"] = "@function.outer",
				-- ["[["] = "@class.outer",
				-- ["[a"] = "@parameter.inner",
				-- jump to the prev variable assignment
				['[v'] = '@p.assign.key',
			},
			goto_previous_end = {},
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
			lookbehind = true,
			keymaps = {
				-- use the queries from supported languages with textobjects.scm
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['iv'] = '@p.assign.value',
				['ik'] = '@p.assign.key',
				['av'] = '@p.assign.value',
				['ak'] = '@p.assign.key',
				['as'] = '@p.scope',
				['is'] = '@p.scope',
				['ir'] = '@p.return.inner',
				['ar'] = '@p.return.outer',
				['ix'] = '@p.jsxAttrVal',
				['ax'] = '@p.jsxAttr',
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
})

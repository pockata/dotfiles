require('nvim-treesitter.configs').setup({
	ensure_installed = {
		'bash', 'comment', 'cpp', 'scss', 'css', 'go', 'html',
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

	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>", -- set to `false` to disable one of the mappings
			node_incremental = "<CR>",
			scope_incremental = "<S-CR>",
			node_decremental = "<BS>",
		},
		is_supported = function()
			-- ignore the command line q:
			local mode = vim.api.nvim_get_mode().mode
			if mode == "c" then
				return false
			end
			return true
		end
	},

	textobjects = {
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]f"] = "@function.outer",
				[']k'] = '@assignment.lhs',
				[']v'] = '@assignment.rhs',
				["]d"] = "@conditional.outer",
				["]r"] = "@return.outer"
			},
			goto_next_end = {
				["]F"] = "@function.outer",
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
				['[k'] = '@assignment.lhs',
				['[v'] = '@assignment.rhs',
				["[d"] = "@conditional.outer",
				["[r"] = "@return.outer"
			},
			goto_previous_end = {
				["[F"] = "@function.outer",
			},
			-- Below will go to either the start or the end, whichever is closer.
			goto_next = {
				["]r"] = "@return.outer",
			},
			goto_previous = {
				["[r"] = "@return.outer",
			}
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
				['ik'] = '@assignment.lhs',
				['ak'] = '@assignment.outer',
				['iv'] = '@assignment.rhs',
				['av'] = '@assignment.rhs',
				["as"] = { query = "@scope", desc = "Select language scope" },
				['ir'] = '@return.inner',
				['ar'] = '@return.outer',
				['ix'] = '@p.jsxAttrVal',
				['ax'] = '@p.jsxAttr',
				['at'] = '@p.htmltag.outer',
				['it'] = '@p.htmltag.inner',
				['ad'] = '@conditional.outer',
				['id'] = '@conditional.inner',
				-- ['it'] = '@p.htmltag.inner',

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

		lsp_interop = {
			enable = true,
			border = "rounded",
			floating_preview_opts = {},
			peek_definition_code = {
				-- ["<leader>df"] = "@function.outer",
				["<leader>dj"] = "@block.outer",
			},
		},
	},

	indent = {
		enable = true
	},
})

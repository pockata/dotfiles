local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	---@diagnostic disable-next-line: missing-fields
	formatting = {
		format = require("lspkind").cmp_format({
			maxwidth = 50,
			with_text = true,
			menu = {
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[Snip]",
				nvim_lua = "[Lua]",
				tmux = "[Tmux]",
				path = "[Path]",
			},
		}),
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-e>"] = cmp.config.disable,
		["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

		["<c-k>"] = cmp.mapping(function()
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			end
		end, { "i", "s" }),

		["<c-l>"] = cmp.mapping(function()
			if luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { "i", "s" }),

		["<c-;>"] = cmp.mapping(function()
			-- This is useful for choice nodes
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			end
		end, { "i", "s" }),
	}),

	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "path" },
		{
			name = "buffer",
			-- max_item_count = 10,
			-- keyword_length = 3,
			option = {
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end,
			},
		},
		{
			name = "tmux",
			-- max_item_count = 10,
			option = {
				all_panes = true,
				sorting = {
					priority_weight = 10,
				},
			},
		},
	}),
})

local cmp = require('cmp')
-- local cmp_buffer = require('cmp_buffer')
local luasnip = require("luasnip")

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- local source_mapping = {
-- 	buffer = "[Buffer]",
-- 	nvim_lsp = "[LSP]",
-- 	nvim_lua = "[Lua]",
-- 	path = "[Path]",
-- 	vsnip = "[Vsnip]",
-- 	tmux = "[tmux]",
-- }
--
-- local lspkind = require("lspkind")

cmp.setup({
	formatting = {
		format = require("lspkind").cmp_format({
			maxwidth = 50,
			with_text = true,
			menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[Snip]",
				tmux = "[Tmux]",
				path = "[Path]"
			})
		}),
	},
	-- window = {
	-- 	completion = cmp.config.window.bordered(),
	-- 	documentation = cmp.config.window.bordered(),
	-- },
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4)),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		['<C-e>'] = cmp.config.disable,

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn.pumvisible() == 1 then
				feedkey('<C-n>', "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn.pumvisible() == 1 then
				feedkey('<C-p>', "")
			else
				fallback()
			end
		end, { "i", "s" }),

		["<c-j>"] = cmp.mapping(function()
			print "c-j"
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			end
		end, { "i" }),

		["<c-k>"] = cmp.mapping(function()
			print "c-k"
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { "i" }),

		["<c-l>"] = cmp.mapping(function()
			-- This is useful for choice nodes
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			end
		end)
	}),

	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'path' },
		{
			name = 'buffer',
			-- max_item_count = 10,
			-- keyword_length = 3,
			option = {
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end
			}
		},
		{
			name = 'tmux',
			-- max_item_count = 10,
			option = {
				all_panes = true,
				sorting = {
					priority_weight = 10,
				}
			}
		},
	}),

	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,

			-- copied from cmp-under, but I don't think I need the plugin for this.
			-- I might add some more of my own.
			function(entry1, entry2)
				local _, entry1_under = entry1.completion_item.label:find "^_+"
				local _, entry2_under = entry2.completion_item.label:find "^_+"
				entry1_under = entry1_under or 0
				entry2_under = entry2_under or 0
				if entry1_under > entry2_under then
					return false
				elseif entry1_under < entry2_under then
					return true
				end
			end,

			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
})

vim.keymap.set("i", "<c-i>", require "luasnip.extras.select_choice")

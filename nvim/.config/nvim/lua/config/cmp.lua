local cmp = require('cmp')
local cmp_buffer = require('cmp_buffer')
local luasnip = require("luasnip")

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
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
		-- format = function(entry, vim_item)
		-- 	vim_item.kind = require("lspkind").presets.default[vim_item.kind]
		-- 	local menu = source_mapping[entry.source.name]
		-- 	if entry.source.name == 'cmp_tabnine' then
		-- 		if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
		-- 			menu = entry.completion_item.data.detail .. ' ' .. menu
		-- 		end
		-- 		vim_item.kind = ''
		-- 	end
		-- 	vim_item.menu = menu
		-- 	return vim_item
		-- end
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

	sources = cmp.config.sources(
		{
			{ name = 'nvim_lsp' },
			{ name = 'luasnip' },
		},
		{
			{ name = 'path' },
			{
				name = 'buffer',
				max_item_count = 10,
				keyword_length = 3,
				option = {
					get_bufnrs = function()
						return vim.api.nvim_list_bufs()
					end
				}
			},
			{
				name = 'tmux',
				max_item_count = 10,
				option = {
					all_panes = true,
					sorting = {
						priority_weight = 10,
					}
				}
			},
		}
	),
	-- sorting = {
	-- 	comparators = {
	-- 		-- https://github.com/hrsh7th/cmp-buffer#locality-bonus-comparator-distance-based-sorting
	-- 		function(...) return cmp_buffer:compare_locality(...) end,
	-- 	}
	-- },
})

vim.keymap.set("i", "<c-i>", require "luasnip.extras.select_choice")

-- Disable cmp inside Telescope prompt
-- It's handled internally in cmp, but it doesn't seem to work for me so we do
-- it explicitly
vim.cmd [[
	autocmd FileType TelescopePrompt * lua require('cmp').setup.buffer { enabled = false }
]]

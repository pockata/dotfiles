local cmp = require('cmp')
-- local cmp_buffer = require('cmp_buffer')

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

cmp.setup({
	formatting = {
		format = require("lspkind").cmp_format({
			maxwidth = 50,
			with_text = true,
			menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				vsnip = "[Vsnip]",
				tmux = "[tmux]",
				path = "[path]"
			})
		}),
	},
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4)),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = false })),
		['<C-e>'] = cmp.config.disable,

		["<Tab>"] = cmp.mapping(cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn.pumvisible() == 1 then
				feedkey('<C-n>', "")
			elseif vim.fn["vsnip#available"]() == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" })),

		["<S-Tab>"] = cmp.mapping(cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn.pumvisible() == 1 then
				feedkey('<C-p>', "")
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" })),
	},
	sources = cmp.config.sources({
		{
			name = 'nvim_lsp',
			sorting = {
				priority_weight = 2,
			},
		},
		{
			name = 'vsnip',
			keyword_length = 2,
		},
		{ name = 'path' },
		-- { name = 'nvim_lsp_signature_help' },
		{
			name = 'buffer',
			max_item_count = 10,
			keyword_length = 4,
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
				sorting= {
					priority_weight = 5,
				}
			}
		},
	}),
	-- sorting = {
	-- 	comparators = {
	-- 		-- https://github.com/hrsh7th/cmp-buffer#locality-bonus-comparator-distance-based-sorting
	-- 		function(...) return cmp_buffer:compare_locality(...) end,
	-- 	}
	-- },
})

-- Disable cmp inside Telescope prompt
-- It's handled internally in cmp, but it doesn't seem to work for me so we do
-- it explicitly
vim.cmd [[
	autocmd FileType TelescopePrompt * lua require('cmp').setup.buffer { enabled = false }
]]


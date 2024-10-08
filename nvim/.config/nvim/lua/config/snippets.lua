local ls = require("luasnip")

-- vim.keymap.set({ "i", "s" }, "<c-k>", function()
-- 	if ls.expand_or_locally_jumpable() then
-- 		ls.expand_or_jump()
-- 	end
-- end, { silent = true })
--
-- vim.keymap.set({ "i", "s" }, "<c-l>", function()
-- 	if ls.locally_jumpable(-1) then
-- 		ls.jump(-1)
-- 	end
-- end, { silent = true })
--
-- vim.keymap.set({ "i", "s" }, "<c-e>", function()
-- 	-- This is useful for choice nodes
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end, { silent = true })

local function merge(first_table, second_table)
	local result = {}
	for _, v in pairs(first_table) do
		table.insert(result, v)
	end
	for _, v in pairs(second_table) do
		table.insert(result, v)
	end
	return result
end

-- some shorthands...
local s = ls.snippet
-- local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
local l = require("luasnip.extras").lambda
-- local rep = require("luasnip.extras").rep
-- local p = require("luasnip.extras").partial
-- local m = require("luasnip.extras").match
-- local n = require("luasnip.extras").nonempty
-- local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
-- local conds = require("luasnip.extras.conditions")
-- local conds_expand = require("luasnip.extras.conditions.expand")

-- local events = require "luasnip.util.events"

-- Every unspecified option will be set to the default.
ls.setup({
	history = true,
	-- Update more often, :h events for more info.
	update_events = "TextChanged,TextChangedI",

	-- Snippets aren't automatically removed if their text is deleted.
	-- `delete_check_events` determines on which events (:h events) a check for
	-- deleted snippets is performed.
	-- This can be especially useful when `history` is enabled.
	delete_check_events = "TextChanged",

	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { " « Current choise", "Comment" } },
			},
			passive = {
				virt_text = { { " « ", "Comment" } },
			},
		},
	},
	enable_autosnippets = true,
})

-- load the snippets from friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- load filetype-specific snippets
for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/config/snippets/*.lua", true)) do
	loadfile(ft_path)()
end

-- examples https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua
ls.add_snippets("all", {
	-- https://github.com/molleweide/LuaSnip-snippets.nvim/blob/main/lua/luasnip_snippets/snippets/comments.lua

	-- basic expanding comment header
	-- currently only working for lua
	-- TODO: Use nvim-ts-context-commentstring
	s("header 1", {
		t("##########"),
		l(l._1:gsub(".", "#"), 1),
		t({ "##########", "" }),
		t("###       "),
		i(1, "title"),
		t({ "       ###", "" }),
		t("##########"),
		l(l._1:gsub(".", "#"), 1),
		t({ "##########", "" }),
	}),
}, { key = "all" })

local global_js_snippets = {
	s("comm", {
		t({ "/**", "" }),
		t({ " * " }),
		i(1, "value"),
		t({ "", "" }),
		t({ " */" }),
	}),
	s(
		"type",
		fmt("/** @type {<>} */", {
			i(1, "type"),
		}, {
			delimiters = "<>",
		})
	),
}

ls.add_snippets("javascript", merge(global_js_snippets, {}), { key = "javascript" })

ls.add_snippets(
	"javascriptreact",
	merge(global_js_snippets, {
		s(
			"us",
			fmt("const [{}, set{}] = useState({});", {
				i(1, "value"),
				f(function(args)
					local name = args[1][1]
					return name:sub(1, 1):upper() .. name:sub(2, -1)
				end, { 1 }),
				i(2, "initialValue"),
			})
		),
	}),
	{ key = "javascriptreact" }
)

ls.add_snippets("go", {
	s(
		"pf",
		fmt(
			'log.Printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")\n'
				.. 'log.Printf("{} %+v", {})\n'
				.. 'log.Printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")\n',
			{
				i(1, "statement"),
				i(2, "vars"),
			}
		)
	),

	s(
		"ie",
		fmt("if err != nil {\n" .. "\treturn <>\n" .. "}", {
			i(1, "err"),
		}, {
			delimiters = "<>",
		})
	),
}, { key = "go" })

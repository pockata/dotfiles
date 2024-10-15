local neogen = require("neogen")
local i = require("neogen.types.template").item

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>nf", function()
	neogen.generate({ type = "func" })
end, opts)
vim.keymap.set("n", "<leader>nt", function()
	neogen.generate({ type = "type" })
end, opts)
vim.keymap.set("n", "<leader>nc", function()
	neogen.generate({ type = "class" })
end, opts)

-- similar to the default config, but removes descriptions and moves the cursor inside the type brackets
local customJSDoc = {
	{ nil, "/** $1 */", { no_results = true, type = { "func", "class" } } },
	{ nil, "/** @type {$1} */", { no_results = true, type = { "type" } } },

	{ nil, "/**", { type = { "class", "func" } } },
	{ i.Parameter, " * @param {$1} %s", { type = { "func" } } },
	{
		{ i.Type, i.Parameter },
		" * @param {$1} %s",
		{ required = i.Tparam, type = { "func" } },
	},
	{ i.Return, " * @returns {$1}", { type = { "func" } } },
	{ nil, " */", { type = { "class", "func" } } },
}

neogen.setup({
	-- use luasnip for expansion
	snippet_engine = "luasnip",

	languages = {
		javascript = {
			template = {
				annotation_convention = "custom",
				custom = customJSDoc,
			},
		},
		javascriptreact = {
			template = {
				annotation_convention = "custom",
				custom = customJSDoc,
			},
		},
	},

	placeholders_text = {
		["description"] = "",
		["tparam"] = "",
		["parameter"] = "",
		["return"] = "",
		["class"] = "",
		["throw"] = "",
		["varargs"] = "",
		["type"] = "",
		["attribute"] = "",
		["args"] = "",
		["kwargs"] = "",
	},
})

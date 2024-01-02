local harpoon = require("harpoon")
local Extensions = require("harpoon.extensions")

-- REQUIRED
harpoon:setup({
	settings = {
		save_on_toggle = true
	}
})
-- REQUIRED

vim.keymap.set("n", "<leader>ta", function() harpoon:list():append() end)
vim.keymap.set("n", "<leader>tc", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<a-j>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<a-k>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<a-l>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<a-;>", function() harpoon:list():select(4) end)

harpoon:extend({
	[Extensions.event_names.UI_CREATE] = function(ctx)
		vim.keymap.set("n", "<C-v>", function()
			harpoon.ui:select_menu_item({ vsplit = true })
		end, { buffer = ctx.bufnr })

		vim.keymap.set("n", "<C-s>", function()
			harpoon.ui:select_menu_item({ split = true })
		end, { buffer = ctx.bufnr })
	end,
})

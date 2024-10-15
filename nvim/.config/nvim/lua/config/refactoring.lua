local refactoring = require("refactoring")
refactoring.setup({
	show_success_message = true,
})

vim.keymap.set("x", "<localleader>rf", function()
	refactoring.refactor("Extract Function")
end)

-- Extract function supports only visual mode
vim.keymap.set("x", "<localleader>rF", function()
	refactoring.refactor("Extract Function To File")
end)

-- Extract variable supports only visual mode
vim.keymap.set("x", "<localleader>re", function()
	refactoring.refactor("Extract Variable")
end)

-- Inline func supports only normal
vim.keymap.set("n", "<localleader>rI", function()
	refactoring.refactor("Inline Function")
end)

-- Inline var supports both normal and visual mode
vim.keymap.set({ "n", "x" }, "<localleader>ri", function()
	refactoring.refactor("Inline Variable")
end)

vim.keymap.set("n", "<localleader>rb", function()
	refactoring.refactor("Extract Block")
end)

-- Extract block supports only normal mode
vim.keymap.set("n", "<localleader>rbf", function()
	refactoring.refactor("Extract Block To File")
end)

-- You can also use below = true here to to change the position of the printf
-- statement (or set two remaps for either one). This remap must be made in normal mode.
vim.keymap.set("n", "<localleader>rp", function()
	refactoring.debug.printf({ below = false })
end)

vim.keymap.set("n", "<localleader>rP", function()
	refactoring.debug.printf({ below = true })
end)

-- Print var

-- Supports both visual and normal mode
vim.keymap.set({ "x", "n" }, "<localleader>rv", function()
	refactoring.debug.print_var()
end)

-- Supports only normal mode
vim.keymap.set("n", "<localleader>rc", function()
	refactoring.debug.cleanup({})
end)

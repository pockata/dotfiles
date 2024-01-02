local refactor = require("refactoring")
refactor.setup()

-- telescope refactoring helper
local function refactor(prompt_bufnr)
	local content = require("telescope.actions.state").get_selected_entry(
		prompt_bufnr
	)
	require("telescope.actions").close(prompt_bufnr)
	require("refactoring").refactor(content.value)
end
-- NOTE: M is a global object
-- for the sake of simplicity in this example
-- you can extract this function and the helper above
-- and then require the file and call the extracted function
-- in the mappings below
M = {}
M.refactors = function()
	local opts = require("telescope.themes").get_cursor() -- set personal telescope options
	require("telescope.pickers").new(opts, {
		prompt_title = "refactors",
		finder = require("telescope.finders").new_table({
			results = require("refactoring").get_refactors(),
		}),
		sorter = require("telescope.config").values.generic_sorter(opts),
		attach_mappings = function(_, map)
			map("i", "<CR>", refactor)
			map("n", "<CR>", refactor)
			return true
		end
	}):find()
end

vim.keymap.set("x", "<localleader>rf", function() require('refactoring').refactor('Extract Function') end)
-- Extract function supports only visual mode
-- vim.keymap.set("x", "<localleader>rf", function() require('refactoring').refactor('Extract Function To File') end)
-- Extract variable supports only visual mode
vim.keymap.set("x", "<localleader>re", function() require('refactoring').refactor('Extract Variable') end)
-- Inline func supports only normal
vim.keymap.set("n", "<localleader>rI", function() require('refactoring').refactor('Inline Function') end)
-- Inline var supports both normal and visual mode
vim.keymap.set({ "n", "x" }, "<localleader>ri", function() require('refactoring').refactor('Inline Variable') end)

vim.keymap.set("n", "<localleader>rb", function() require('refactoring').refactor('Extract Block') end)
-- Extract block supports only normal mode
vim.keymap.set("n", "<localleader>rbf", function() require('refactoring').refactor('Extract Block To File') end)

-- You can also use below = true here to to change the position of the printf
-- statement (or set two remaps for either one). This remap must be made in normal mode.
vim.keymap.set(
	"n",
	"<localleader>rp",
	function() require('refactoring').debug.printf({below = false}) end
)

-- Print var

-- Supports both visual and normal mode
vim.keymap.set({"x", "n"}, "<localleader>rv", function() require('refactoring').debug.print_var() end)

-- Supports only normal mode
vim.keymap.set("n", "<localleader>rc", function() require('refactoring').debug.cleanup({}) end)

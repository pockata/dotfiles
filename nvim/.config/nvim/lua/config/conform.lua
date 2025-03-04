local conform = require("conform")
conform.setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end

		-- Disable "format_on_save lsp_fallback" for languages that don"t
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = { c = true, cpp = true }
		return {
			timeout_ms = 500,
			lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
		}
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform can also run multiple formatters sequentially
		-- python = { "isort", "black" },
		--
		-- You can use a sub-list to tell conform to run *until* a formatter
		-- is found.

		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		svelte = { "prettierd" },
		yaml = { "prettierd" },

		css = { "prettierd" },
		scss = { "prettierd" },
	},
})

-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting for all buffers
		vim.g.disable_autoformat = true
	else
		vim.b.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

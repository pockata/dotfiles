local lspconfig = require("lspconfig")
local lsp_installer = require("nvim-lsp-installer")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics,
	{
		underline = false,
		virtual_text = true,
		signs = true,
		update_in_insert = false,
	}
)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover, {
		border = "rounded",
		width = 80,
	}
)

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- show LSP signatures while typing function arguments
	require('lsp_signature').on_attach({
		-- Floating window borders
		bind = true, -- This is mandatory, otherwise border config won't get registered.
		hint_enable = false,
		-- hint_prefix = "LEK > ",
		-- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
		handler_opts = {
			border = "rounded"
		},
		floating_window = true,
		hi_parameter = "IncSearch",
		always_trigger = false,
		-- extra_trigger_chars = {"("}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
	}, bufnr)

	-- Mappings
	local opts = { noremap = true, silent = true }

	-- TODO: These are attached on a per-buffer basis. Offer an alternative for
	-- non-lsp buffers like a built-in fallback (K, gd) or show a warning that
	-- the feature requires an active LSP server
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<leader>cs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	-- buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	-- buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	-- buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<leader>gn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	-- buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev({ float = { border = "rounded" }})<CR>zz', opts)
	buf_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next({ float = { border = "rounded" }})<CR>zz', opts)
	-- buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

	-- Set some keybinds conditional on server capabilities
	if client.server_capabilities.documentFormattingProvider then
		buf_set_keymap("n", "g=", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	end

	if client.server_capabilities.documentRangeFormattingProvider then
		buf_set_keymap("v", "g=", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	end
end

local function setup_servers()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
	-- capabilities.textDocument.completion.completionItem.snippetSupport = true

	-- -- from https://github.com/ray-x/lsp_signature.nvim/blob/master/tests/init_paq.lua
	-- capabilities.textDocument.completion.completionItem.resolveSupport = {
	-- 	properties = { "documentation", "detail", "additionalTextEdits" },
	-- }

	require("nvim-lsp-installer").setup {}

	local servers = lsp_installer.get_installed_servers()
	for _, server in ipairs(servers) do
		local conf = {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		-- TODO: Check out json/yaml schema configs
		-- https://github.com/Allaman/nvim/blob/main/lua/config/lsp.lua

		-- load config/lsp/{server}.lua and pass the default config file
		pcall(function() conf = require('config.lsp.' .. server.name)(conf) end)

		-- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
		lspconfig[server.name].setup(conf)
		-- vim.cmd [[ do User LspAttachBuffers ]]
	end
end

setup_servers()

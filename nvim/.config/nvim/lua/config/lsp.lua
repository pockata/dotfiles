local lspconfig = require("lspconfig")

-- Checkout handlers from here
-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/lsp/handlers.lua
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
	vim.lsp.handlers.hover,
	{
		border = "rounded",
		width = 80,
	}
)

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings
	local opts = { noremap = true, silent = true }

	-- TODO: These are attached on a per-buffer basis. Offer an alternative for
	-- non-lsp buffers like a built-in fallback (K, gd) or show a warning that
	-- the feature requires an active LSP server
	if client.name == "tsserver" then
		buf_set_keymap('n', 'gD', '<cmd>TypescriptGoToSourceDefinition<CR>', opts)
	else
		buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	end

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
	-- these are handles with Telescope
	-- buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<CR>', opts)
	-- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)

	-- buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev({ float = { border = "rounded" }})<CR>zz', opts)
	buf_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next({ float = { border = "rounded" }})<CR>zz', opts)
	buf_set_keymap('i', '<c-h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	-- buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

	-- Set some keybinds conditional on server capabilities
	if client.server_capabilities.documentFormattingProvider then
		buf_set_keymap("n", "g=", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", opts)
		-- vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	end

	if client.server_capabilities.documentRangeFormattingProvider then
		buf_set_keymap("v", "g=", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	end

	-- if client.server_capabilities.inlayHintProvider then
	-- 	vim.lsp.inlay_hint(bufnr, true)
	-- end

	-- toggle inlay hints
	vim.keymap.set("n", "<leader>i", function()
		local inlay_hint = vim.lsp.inlay_hint
		if type(inlay_hint) == "table" and inlay_hint.enable then
			inlay_hint.enable(nil, not inlay_hint.is_enabled())
		end
	end)
end

local function setup_servers()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = {
			"gopls",
			"tsserver",
			"lua_ls",
			-- "cssls",
			"cssmodules_ls",
			"jsonls",
			"yamlls",

			-- "css-lsp",
			-- "eslint_d",
			-- "gopls",
			-- "json-lsp",
			-- "lua-language-server",
			-- "typescript-language-server",
			-- "yaml-language-server",
		}
	})
	require("mason-lspconfig").setup_handlers({
		function(server)
			local conf = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- TODO: Check out json/yaml schema configs
			-- https://github.com/Allaman/nvim/blob/main/lua/config/lsp.lua

			-- load config/lsp/{server}.lua and pass the default config file
			pcall(function() conf = require('config.lsp.' .. server)(conf) end)

			if server == "tsserver" then
				require("typescript").setup({
					go_to_source_definition = {
						fallback = false, -- fall back to standard LSP definition on failure
					},
					server = conf,
				})
			else
				-- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
				lspconfig[server].setup(conf)
			end

			-- vim.cmd [[ do User LspAttachBuffers ]]
		end
	})
end

setup_servers()

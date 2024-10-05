return function(conf)
	conf.settings = {
		completions = {
			completeFunctionCalls = true
		},
	}

	conf.init_options = {
		preferences = {
			quotePreference = "double",
			importModuleSpecifierPreference = "non-relative",
			includeCompletionsForImportStatements = true,
			importModuleSpecifierEnding = "minimal",
			includeInlayParameterNameHints = "all",
			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
		codeActionsOnSave = {
			source = {
				addMissingImports = true,
			}
		},
	}

	conf.handlers = {
		["textDocument/publishDiagnostics"] = function(
			_,
			result,
			ctx,
			config
		)
			if result.diagnostics == nil then
				return
			end

			-- ignore some tsserver diagnostics
			local idx = 1
			while idx <= #result.diagnostics do
				local entry = result.diagnostics[idx]

				local formatter = require('format-ts-errors')[entry.code]
				entry.message = formatter and formatter(entry.message) or entry.message

				-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
				if entry.code == 80001 then
					-- { message = "File is a CommonJS module; it may be converted to an ES module.", }
					table.remove(result.diagnostics, idx)
				else
					idx = idx + 1
				end
			end

			vim.lsp.diagnostic.on_publish_diagnostics(
				_,
				result,
				ctx,
				config
			)
		end,
	}

	return conf
end

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
		},
		codeActionsOnSave = {
			source = {
				addMissingImports = true,
			}

		}
	}

	return conf
end

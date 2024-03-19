return function(conf)
	-- for postfix snippets and analyzers
	conf.settings = {
		gopls = {
			experimentalPostfixCompletions = true,
			usePlaceholders = false,
			analyses = {
				unreachable = true,
				unusedparams = true,
				nilness = true,
				shadow = true,
			},
			staticcheck = true,

			-- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	}
	return conf
end

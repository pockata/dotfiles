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
		},
	}
	return conf
end

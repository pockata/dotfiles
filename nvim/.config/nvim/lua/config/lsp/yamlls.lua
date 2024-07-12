return function(conf)
	conf.settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	}

	return conf
end

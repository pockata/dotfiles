local root_markers = { ".git/", ".eslintrc.js", ".eslintrc" }

local eslint = {
	lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
	lintStdin = true,
	lintFormats = {"%f:%l:%c: %m"},
	lintIgnoreExitCode = true,
	formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
	formatStdin = true
}

return function(conf)
	conf.settings = {
		rootMarkers = root_markers,
		languages = {
			javascript = {eslint},
			javascriptreact = {eslint},
			["javascript.jsx"] = {eslint},
			typescript = {eslint},
			["typescript.tsx"] = {eslint},
			typescriptreact = {eslint}
		}
	}

	conf.filetypes = vim.tbl_keys(conf.settings.languages)

	return conf
end


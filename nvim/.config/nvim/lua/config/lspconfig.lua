
-- Diagnostic Signs
vim.fn.sign_define('DiagnosticSignError',
	{ text = '✗', texthl = 'LspDiagnosticsSignError' })

vim.fn.sign_define('DiagnosticSignWarning',
	{ text = '', texthl = 'LspDiagnosticsSignWarning' })

vim.fn.sign_define('DiagnosticSignInformation',
	{ text = '', texthl = 'LspDiagnosticsSignInformation' })

vim.fn.sign_define('DiagnosticSignHint',
	{ text = '', texthl = 'LspDiagnosticsSignHint' })


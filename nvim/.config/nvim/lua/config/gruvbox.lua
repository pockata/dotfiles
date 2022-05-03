vim.g.gruvbox_contrast_dark = 'medium'
vim.g.gruvbox_invert_selection = 0
vim.g.gruvbox_invert_tabline = true

create_augroup('GruvboxMods', {
	'ColorScheme gruvbox highlight SignColumn guibg=#282828',
	'ColorScheme gruvbox highlight GruvboxGreenSign guibg=#282828',
	'ColorScheme gruvbox highlight LspDiagnosticsDefaultHint guifg=orange',
	'ColorScheme gruvbox highlight LspDiagnosticsDefaultError guifg=red',
	'ColorScheme gruvbox highlight Whitespace guifg=#504945',
})

-- -- If I set it in theme.lua funny things start to happen
-- vim.cmd [[colorscheme gruvbox]]


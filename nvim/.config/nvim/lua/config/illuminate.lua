-- Set the highlight once on startup and on colorscheme change
local setHighlight = [[highlight! IlluminatedCurWord gui=underline guibg=bg]]

vim.cmd(setHighlight)

create_augroup('IlluminateConfig', {
	'ColorScheme * ' .. setHighlight
})

-- Set the highlight once on startup and on colorscheme change
local setHighlight = [[highlight! illuminatedWord gui=underline]]

vim.cmd(setHighlight)

create_augroup('IlluminateConfig', {
	'ColorScheme * ' .. setHighlight
})


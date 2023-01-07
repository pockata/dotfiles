-- vim: set path+=./lua:
local g = vim.g

-- Disable some built-in plugins we don't want
local disabled_built_ins = {
	'gzip', 'rrhelper', 'getscript', 'getscriptPlugin', 'vimball',
	'vimballPlugin', '2html', 'matchit', 'matchparen', 'tarPlugin', 'tar',
	'zipPlugin', 'zip', --[[ 'netrw', 'netrwPlugin', 'netrwSettings',--]]
	'rplugin', 'logiPat'
}
for _, plugin in pairs(disabled_built_ins) do g['loaded_' .. plugin] = 1 end

require('utils')
require('functions')
require('settings')
require('keymaps')
require('theme')
require('plugins')


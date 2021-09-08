-- vim: set path+=./lua:
local g = vim.g

-- Disable some built-in plugins we don't want
local disabled_built_ins = {
	'gzip', 'rrhelper', 'getscriptPlugin', 'vimballPlugin', 'matchit',
	'tarPlugin', 'tar', 'zipPlugin', 'zip', 'netrwPlugin', 'rplugin'
}
for i = 1, 11 do g['loaded_' .. disabled_built_ins[i]] = 1 end

require('utils')
require('functions')
require('settings')
require('keymaps')
require('plugins')
require('theme')


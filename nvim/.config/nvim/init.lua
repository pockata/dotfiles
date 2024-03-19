-- vim: set path+=./lua:
local g = vim.g

-- -- bootstrap Lazy.nvim
-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
-- 	vim.fn.system({
-- 		"git",
-- 		"clone",
-- 		"--filter=blob:none",
-- 		"https://github.com/folke/lazy.nvim.git",
-- 		"--branch=stable", -- latest stable release
-- 		lazypath,
-- 	})
-- end
--
-- vim.opt.rtp:prepend(lazypath)

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


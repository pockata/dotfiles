local cmd = vim.cmd

-- Create an augroup
function create_augroup(name, autocmds)
	cmd('augroup ' .. name)
	cmd('autocmd!')

	if type(autocmds) == 'string' then
		autocmds = {autocmds}
	end

	for _, autocmd in ipairs(autocmds) do
		cmd('autocmd ' .. autocmd)
	end

	cmd('augroup END')
end

local function map_key(type, lhs, opts, rhs, noremap)
	if rhs == nil then
		rhs = opts
		opts = nil
	end

	local mods = {
		noremap = noremap == nil and false or noremap,
		silent = opts ~= nil and string.find(opts, '<silent>') ~= nil,
		expr = opts ~= nil and string.find(opts, '<expr>') ~= nil,
	}

	vim.api.nvim_set_keymap(type, lhs, rhs, mods)
end

local function noremap_key(type, lhs, opts, rhs)
	map_key(type, lhs, opts, rhs, true)
end

function map(lhs, opts, rhs)
	nmap(lhs, opts, rhs)
	vmap(lhs, opts, rhs)
	omap(lhs, opts, rhs)
end

function noremap(lhs, opts, rhs)
	nnoremap(lhs, opts, rhs)
	vnoremap(lhs, opts, rhs)
	onoremap(lhs, opts, rhs)
end

function nnoremap(lhs, opts, rhs)
	noremap_key('n', lhs, opts, rhs)
end

function inoremap(lhs, opts, rhs)
	noremap_key('i', lhs, opts, rhs)
end

function vnoremap(lhs, opts, rhs)
	noremap_key('v', lhs, opts, rhs)
end

function xnoremap(lhs, opts, rhs)
	noremap_key('x', lhs, opts, rhs)
end

function onoremap(lhs, opts, rhs)
	noremap_key('o', lhs, opts, rhs)
end

function tnoremap(lhs, opts, rhs)
	noremap_key('t', lhs, opts, rhs)
end

function cnoremap(lhs, opts, rhs)
	noremap_key('c', lhs, opts, rhs)
end

function nmap(lhs, opts, rhs)
	map_key('n', lhs, opts, rhs)
end

function imap(lhs, opts, rhs)
	map_key('i', lhs, opts, rhs)
end

function vmap(lhs, opts, rhs)
	map_key('v', lhs, opts, rhs)
end

function xmap(lhs, opts, rhs)
	map_key('x', lhs, opts, rhs)
end

function omap(lhs, opts, rhs)
	map_key('o', lhs, opts, rhs)
end

function tmap(lhs, opts, rhs)
	map_key('t', lhs, opts, rhs)
end

function smap(lhs, opts, rhs)
	map_key('s', lhs, opts, rhs)
end

function cmap(lhs, opts, rhs)
	map_key('c', lhs, opts, rhs)
end


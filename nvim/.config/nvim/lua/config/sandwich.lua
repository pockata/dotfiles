vim.g.sandwich_no_default_key_mappings = 1
vim.g.operator_sandwich_no_default_key_mappings = 1
vim.g.textobj_sandwich_no_default_key_mappings = 1
vim.g.sandwich_no_tex_ftplugin = 1

-- select a text surrounded by braket or same characters user input
xmap("is", "<Plug>(textobj-sandwich-query-i)")
xmap("as", "<Plug>(textobj-sandwich-query-a)")
omap("is", "<Plug>(textobj-sandwich-query-i)")
omap("as", "<Plug>(textobj-sandwich-query-a)")

-- select the nearest surrounded text automatically
-- default is iss, but use isb for consistency with built-in vib/vab
xmap("isb", "<Plug>(textobj-sandwich-auto-i)")
xmap("asb", "<Plug>(textobj-sandwich-auto-a)")
omap("isb", "<Plug>(textobj-sandwich-auto-i)")
omap("asb", "<Plug>(textobj-sandwich-auto-a)")

-- -- Textobjects to select a text surrounded by same characters user input
-- xmap("im", "<Plug>(textobj-sandwich-literal-query-i)")
-- xmap("am", "<Plug>(textobj-sandwich-literal-query-a)")
-- omap("im", "<Plug>(textobj-sandwich-literal-query-i)")
-- omap("am", "<Plug>(textobj-sandwich-literal-query-a)")

-- by default dsf works on func(arg) and not on obj.method(arg)
-- see :h sandwich-miscellaneous
vim.cmd [[
	let g:sandwich#magicchar#f#patterns = [
	\   {
	\     'header' : '\<\%(\h\k*\.\)*\h\k*',
	\     'bra'    : '(',
	\     'ket'    : ')',
	\     'footer' : '',
	\   },
	\ ]
]]

-- Running ysiwf (surrounding the current word with a function) should trigger
-- insert mode and leverage completion instead of the default input mode in the
-- vim command line
-- https://github.com/machakann/vim-sandwich/wiki/Magic-characters#function-surroundings
vim.cmd [[
	function! SetCustomRecipes()
		" the docs state we should extend g:sandwich#default_recipes, but when
		" using surround.vim keymaps (see below), we have to extend
		" g:sandwich#recipes
		let g:sandwich#recipes = deepcopy(g:sandwich#recipes)
		let g:sandwich#recipes += [
		\   {
		\     'buns': ['(', ')'],
		\     'cursor': 'head',
		\     'command': ['startinsert'],
		\     'kind': ['add', 'replace'],
		\     'action': ['add'],
		\     'input': ['f']
		\   },
		\ ]
	endfunc
]]

create_augroup('SANDWICHConfig', {
	"VimEnter * :runtime! macros/sandwich/keymap/surround.vim",
	-- see :h *g:operator#sandwich#options*
	-- move the cursor at the start of the surrounded object
	"VimEnter * :call operator#sandwich#set('all', 'all', 'cursor', 'inner_head')",
	-- keep the same indent level on operator actions
	"VimEnter * :call operator#sandwich#set('all', 'all', 'autoindent', 4)",
	"VimEnter * :call SetCustomRecipes()"
})


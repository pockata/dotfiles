vim.g.sandwich_no_default_key_mappings = 1
vim.g.operator_sandwich_no_default_key_mappings = 1
vim.g.textobj_sandwich_no_default_key_mappings = 1
vim.g.sandwich_no_tex_ftplugin = 1

create_augroup('SANDWICHConfig', {
	"VimEnter * :runtime! macros/sandwich/keymap/surround.vim",
	-- "VimEnter * :call operator#sandwich#set('all', 'all', 'cursor', 'keep')"
	"VimEnter * :call operator#sandwich#set('all', 'all', 'autoindent', 4)"
})


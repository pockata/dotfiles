require("harpoon").setup({
	global_settings = {
		-- set marks specific to each git branch inside git repository
		mark_branch = true,
	},
})

vim.cmd [[
	autocmd! Filetype harpoon nnoremap <silent> <buffer> K :silent! move+<CR>|
		\ nnoremap <silent> <buffer> L :silent! move--<CR>|
		\ nnoremap <buffer>J <nop>

	function! s:setHighlight()
		highlight link HarpoonCurrentFile String
	endfunction

	" set the highlight immediately and on colorscheme change
	call s:setHighlight()
	autocmd! ColorScheme * :call s:setHighlight()

	nnoremap <silent><leader>ta :lua require("harpoon.mark").add_file()<CR>
	nnoremap <silent><leader>tc :lua require("harpoon.ui").toggle_quick_menu()<CR>

	nnoremap <silent><a-j> :lua require("harpoon.ui").nav_file(1)<CR>
	nnoremap <silent><a-k> :lua require("harpoon.ui").nav_file(2)<CR>
	nnoremap <silent><a-l> :lua require("harpoon.ui").nav_file(3)<CR>
	nnoremap <silent><a-;> :lua require("harpoon.ui").nav_file(4)<CR>
]]

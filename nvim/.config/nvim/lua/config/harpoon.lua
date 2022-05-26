vim.cmd [[
	nnoremap <silent><leader>ta :lua require("harpoon.mark").add_file(); print("Harpooned!")<CR>
	nnoremap <silent><leader>tc :lua require("harpoon.ui").toggle_quick_menu()<CR>
	" nnoremap <silent><leader>tc :lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>

	nnoremap <silent><a-j> :lua require("harpoon.ui").nav_file(1)<CR>
	nnoremap <silent><a-k> :lua require("harpoon.ui").nav_file(2)<CR>
	nnoremap <silent><a-l> :lua require("harpoon.ui").nav_file(3)<CR>
	nnoremap <silent><a-;> :lua require("harpoon.ui").nav_file(4)<CR>

	nnoremap <silent><[m> :lua require("harpoon.ui").nav_prev()<CR>
	nnoremap <silent><]m> :lua require("harpoon.ui").nav_next()<CR>
]]

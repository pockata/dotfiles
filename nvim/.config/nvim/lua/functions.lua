-- Navigate folds
vim.api.nvim_exec(
	[[
	function! NextClosedFold(dir)
		let cmd = 'norm!z' . a:dir
		let view = winsaveview()
		let [l0, l, open] = [0, view.lnum, 1]
		while l != l0 && open
			exe cmd
			let [l0, l] = [l, line('.')]
			let open = foldclosed(l) < 0
		endwhile
		if open
			call winrestview(view)
		endif
	endfunction
]],
	true
)

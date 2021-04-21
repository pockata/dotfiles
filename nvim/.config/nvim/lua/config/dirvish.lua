vim.g.dirvish_mode = ":sort ,^.*[\\/],"

create_augroup('DirvishConfig', {
		[[FileType dirvish call FugitiveDetect(expand("%")) | nnoremap <silent> <buffer> <C-t> :call dirvish#open('tabedit', 0)<CR> |xnoremap <silent> <buffer> <C-t> :call dirvish#open('tabedit', 0)<CR> |noremap <silent> <buffer> <C-v> :call dirvish#open('vsplit', 0)<CR> |xnoremap <silent> <buffer> <C-v> :call dirvish#open('vsplit', 0)<CR> |noremap <silent> <buffer> <C-s> :call dirvish#open('split', 0)<CR> |xnoremap <silent> <buffer> <C-s> :call dirvish#open('split', 0)<CR> |nnoremap <silent> <buffer> <c-p> :call SmartDirvish()<CR>]],
		[[FileType dirvish nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>]]
})

vim.api.nvim_exec([[
	func! SmartDirvish() abort
		let folder = expand('%') . '.git'
		if isdirectory(folder)
			GitFiles
		else
			Files %
		endif
	endf
]], true)


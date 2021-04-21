vim.cmd [[
function! s:gv_expand()
	let line = getline('.')
	GV --name-status
	call search('\V'.line, 'c')
	normal! zz
endfunction
]]

create_augroup('GVConfig', {
	'FileType GV nnoremap <buffer> <silent> + <cmd>call <sid>gv_expand()<cr>',
	'FileType GV unmap <buffer> <c-p>',
	'FileType GV unmap <buffer> <c-n>',
})


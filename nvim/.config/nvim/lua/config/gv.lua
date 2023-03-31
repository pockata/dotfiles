-- TODO: Make GVexpand respect current GV filters (GV master..branch_name)
vim.cmd [[
function! GVexpand()
	let line = getline('.')
	GV --name-status
	call search('\V'.line, 'c')
	normal! zz
endfunction
]]

create_augroup('GVConfig', {
	'FileType GV nnoremap <buffer> <silent> + <cmd>call GVexpand()<cr>',
	'FileType GV unmap <buffer> <c-p>',
	'FileType GV unmap <buffer> <c-n>',
})


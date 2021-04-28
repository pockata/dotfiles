require('hop').setup({})

nmap('s', '<silent>', '<cmd>HopChar2<CR>')
nmap('S', '<silent>', '<cmd>HopWord<CR>')

nnoremap('f', '<silent>', '<cmd>call WrapHop("f")<CR>')
xnoremap('f', '<silent>', '<cmd>call WrapHop("f")<CR>')
onoremap('f', '<silent>', '<cmd>call WrapHop("f")<CR>')

nnoremap('t', '<silent>', '<cmd>call WrapHop("t")<CR>')
xnoremap('t', '<silent>', '<cmd>call WrapHop("t")<CR>')
onoremap('t', '<silent>', '<cmd>call WrapHop("t")<CR>')

-- remove the underline from highlighted characters
create_augroup('HopConfig', {
	'VimEnter,ColorScheme * highlight HopNextKey gui=bold'
})

-- Wrap HopChar1 to use t/f if used with a count
-- Also implement t properly by making the selection non-inclusive
vim.cmd([[
function! WrapHop(key)
	if (v:count)
		call feedkeys(v:count . a:key, "n")
	else
		HopChar1
		if (a:key == 't')
			normal! h
		endif
	endif
endfunction
]])


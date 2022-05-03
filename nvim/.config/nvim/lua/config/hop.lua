require('hop').setup({})

nmap('S', '<silent>', '<cmd>HopChar2<CR>')
nmap('s', '<silent>', '<cmd>HopWord<CR>')

-- noremap('f', '<silent>', '<cmd>call WrapHop("f")<CR>')
-- noremap('t', '<silent>', '<cmd>call WrapHop("t")<CR>')

-- noremap('f', '<silent>', '<cmd>HopChar1<CR>')
-- noremap('t', '<silent>', '<cmd>HopChar1<CR>')

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


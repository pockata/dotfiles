nnoremap("<leader>gs", "<cmd>-tabedit %<CR>:Git<CR>:only<CR>");
nnoremap("<leader>gw", "<cmd>Gwrite<CR>");
nnoremap("<leader>gc", "<cmd>Git commit --verbose<CR>");
nnoremap("<leader>gd", "<cmd>-tabedit %<CR>:Gdiff<CR>");
nnoremap("<leader>ga", ":Git commit --amend --reuse-message=HEAD");

-- Open current line in the browser
nnoremap("<leader>gb", "<cmd>.GBrowse<CR>")
-- Open visual selection in the browser
vnoremap("<leader>gb", "<cmd>GBrowse<CR>")
nnoremap("<leader>do", "<cmd>diffoff | windo if &diff | hide | endif<cr>")

create_augroup('FugitiveConfig', {
	"BufReadPost fugitive://* set bufhidden=delete",
	"BufRead fugitive://* xnoremap <buffer> dp :diffput<CR>|xnoremap <buffer> do :diffget<CR>"
})

-- -- TODO: Rewrite this to go to each hunk in a diff (+/-). Fugitive
-- -- already offers [c / ]c
--
--
-- function! s:fug_hunk(bang)
--	   call search('^\(-\|+\)\s\+', a:bang ? 'sW' : 'sWb');
-- endfunction
-- -- Create [c / ]c mappings for patch diffs (GV) by jumping to the
-- -- next match of /^@@
-- -- :call search('^@@', 'sW')
-- autocmd User Fugitive
--			   \ if exists('b:fugitive_type') && b:fugitive_type == 'commit' |
--			   \   nnoremap <silent> <buffer> [C :call search('^@@', 'sWb')<CR>|
--			   \   nnoremap <silent> <buffer> ]C :call search('^@@', 'sW')<CR>|
--			   " TODO: Figure out why these work when called by the
--			   " command line and not when called via a mapping
--			   \   nnoremap <silent> <buffer> [c :call <SID>fug_hunk(0)<CR>|
--			   \   nnoremap <silent> <buffer> ]c :call <SID>fug_hunk(1)<CR>|
--			   \ endif


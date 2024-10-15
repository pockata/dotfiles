vim.g.dirvish_mode = ":sort ,^.*[\\/],"
-- Move these to after/dirvish.vim
create_augroup("DirvishConfig", {
	[[FileType dirvish call FugitiveDetect(expand("%")) |noremap <silent> <buffer> <C-v> :call dirvish#open('vsplit', 0)<CR> |xnoremap <silent> <buffer> <C-v> :call dirvish#open('vsplit', 0)<CR> |noremap <silent> <buffer> <C-s> :call dirvish#open('split', 0)<CR> |xnoremap <silent> <buffer> <C-s> :call dirvish#open('split', 0)<CR>]],
	[[FileType dirvish nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>]],
})

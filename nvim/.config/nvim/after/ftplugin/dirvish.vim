" Remove default mappings
silent! unmap <buffer> <c-p>
silent! unmap <buffer> p

" Go to project root
nnoremap <silent><buffer> gr :execute 'edit ' . projectroot#guess()<CR>
noremap <silent> <buffer> <C-v> :call dirvish#open('vsplit', 0)<CR>
xnoremap <silent> <buffer> <C-v> :call dirvish#open('vsplit', 0)<CR>
noremap <silent> <buffer> <C-s> :call dirvish#open('split', 0)<CR>
xnoremap <silent> <buffer> <C-s> :call dirvish#open('split', 0)<CR>
" nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<CR>:setl cole=3<CR>
setl nospell

hi link DirvishGitModified GitSignsChange
hi link DirvishGitStaged GitSignsStageAdd
hi link DirvishGitRenamed DiffChange
hi link DirvishGitUntracked GitSignsUntracked
hi link DirvishGitUntrackedDir GitSignsUntracked
hi link DirvishGitUnmerged DiffChange
hi link DirvishGitIgnored GitSignsIgnore

call FugitiveDetect(expand("%"))

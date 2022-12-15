" Remove default mappings
silent! unmap <buffer> <c-p>
silent! unmap <buffer> p

" Go to project root
nnoremap <silent><buffer> gr :execute 'edit ' . projectroot#guess()<CR>
setl nospell


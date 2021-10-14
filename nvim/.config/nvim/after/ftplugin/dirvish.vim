" Remove the default <c-p> mapping
silent! unmap <buffer> <c-p>

" Go to project root
nnoremap <silent><buffer> gr :execute 'edit ' . projectroot#guess()<CR>


" https://www.reddit.com/r/vim/comments/dj37wt/plugin_for_conventional_commits/
" this goes in ~/.vim/after/ftplugin/gitcommit.vim

inoreabbrev <buffer> BB BREAKING CHANGE:
nnoremap <silent><buffer> i  i<C-r>=<sid>commit_type()<CR>

" don't highlight special characteers (trailing whitespace in particular)
setl nolist

fun! s:commit_type()
	call complete(1, ['build: ', 'ci: ', 'chore: ', 'docs: ', 'feat: ', 'fix: ', 'perf: ', 'refactor: ', 'revert: ', 'style: ', 'test: '])

	nunmap <buffer> i
	return ''
endfun


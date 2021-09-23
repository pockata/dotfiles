" https://www.reddit.com/r/vim/comments/dj37wt/plugin_for_conventional_commits/
" this goes in ~/.vim/after/ftplugin/gitcommit.vim

inoreabbrev <buffer> BB BREAKING CHANGE:
nnoremap <silent><buffer> i  i<C-r>=<sid>commit_type()<CR>

" don't highlight special characteers (trailing whitespace in particular)
setl nolist

fun! s:commit_type()
	call complete(1, [
		\{
			\'word': 'build: ',
			\'menu': 'Changes that affect the build system or external dependencies'
		\},
		\{
			\'word': 'ci: ',
			\'menu': 'Changes to our CI configuration files and scripts'
		\},
		\{
			\'word': 'chore: ',
			\'menu': "Other changes that don't modify source or test files"
		\},
		\{
			\'word': 'docs: ',
			\'menu': 'Documentation only changes'
		\},
		\{
			\'word': 'feat: ',
			\'menu': 'A new feature'
		\},
		\{
			\'word': 'fix: ',
			\'menu': 'A bug fix'
		\},
		\{
			\'word': 'perf: ',
			\'menu': 'A code change that improves performance'
		\},
		\{
			\'word': 'refactor: ',
			\'menu': 'A code change that neither fixes a bug nor adds a feature'
		\},
		\{
			\'word': 'revert: ',
			\'menu': 'If the commit reverts a previous commit'
		\},
		\{
			\'word': 'style: ',
			\'menu': 'Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)'
		\},
		\{
			\'word': 'test: ',
			\'menu': 'Adding missing tests or correcting existing tests'
		\}
	\])

	nunmap <buffer> i
	return ''
endfun


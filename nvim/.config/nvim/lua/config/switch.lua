create_augroup("SwitchConfig", {
	"FileType gitrebase let b:switch_custom_definitions = [[ 'pick', 'reword', 'edit', 'squash', 'fixup', 'exec' ], [ 'TODO', 'DONE', 'XXX', 'FIXME' ],[ '[ ]', '[✔]', '[✘]', '[✔✘]', '[?]' ],['let ', 'const '],]",
	-- [[FileType javascript let b:switch_custom_definitions =
	-- 					\ [
	-- 					\   {
	-- 					\     'function(\([^)]\{-}\))': '(\1) =>',
	-- 					\     '(\([^)]\{-}\)) =>': 'function(\1)'
	-- 					\   },
	-- 					\   ['var', 'let', 'const'],
	-- 					\   {
	-- 					\     '\(\k\+\)\[''\(\k\+\)''\]': '\1.\2',
	-- 					\     '\(\k\+\)\.\(\k\+\)\>': '\1[''\2'']'
	-- 					\   },
	-- 					\ 	{
	-- 					\ 	 	'const\s\(\k\+\)\s=\s(\(\k\+\))\s=>': 'function \1(\2)',
	-- 					\ 		'(\(\k\+\))': '(!\1)',
	-- 					\ 		'(!\(\k\+\))': '(\1)',
	-- 					\ 		'{\(\k\+\)}': '{ \1 }',
	-- 					\ 	}
	-- 					\ ]
	-- 	]],

	-- " - [ ] → - [x] → - [-] → loops back to - [ ]
	-- " + [ ] → + [x] → + [-] → loops back to + [ ]
	-- " * [ ] → * [x] → * [-] → loops back to * [ ]
	-- " 1. [ ] → 1. [x] → 1. [-] → loops back to 1. [ ]
	[[FileType markdown let b:switch_custom_definitions =
			\ [
			\   { '\v^(\s*[*+-] )?\[ \]': '\1[x]',
			\     '\v^(\s*[*+-] )?\[x\]': '\1[-]',
			\     '\v^(\s*[*+-] )?\[-\]': '\1[ ]',
			\   },
			\   { '\v^(\s*\d+\. )?\[ \]': '\1[x]',
			\     '\v^(\s*\d+\. )?\[x\]': '\1[-]',
			\     '\v^(\s*\d+\. )?\[-\]': '\1[ ]',
			\   },
			\ ]
		]],

	"FileType typescript,typescriptreact let b:switch_custom_definitions = [['public ', 'private ', 'protected '],]",
	[[FileType css,scss let b:switch_custom_definitions =
			\ [
			\   ['border-top', 'border-bottom'],
			\   ['border-left', 'border-right'],
			\   ['border-left-width', 'border-right-width'],
			\   ['border-top-width', 'border-bottom-width'],
			\   ['border-left-style', 'border-right-style'],
			\   ['border-top-style', 'border-bottom-style'],
			\   ['margin-left', 'margin-right'],
			\   ['margin-top', 'margin-bottom'],
			\   ['padding-left', 'padding-right'],
			\   ['padding-top', 'padding-bottom'],
			\   ['margin', 'padding'],
			\   ['height', 'width'],
			\   ['min-width', 'max-width'],
			\   ['min-height', 'max-height'],
			\   ['transition', 'animation'],
			\   ['absolute', 'relative', 'fixed'],
			\   ['inline', 'inline-block', 'block', 'flex', 'grid'],
			\   ['overflow', 'overflow-x', 'overflow-y'],
			\   ['before', 'after'],
			\   ['none', 'block'],
			\   ['left', 'right'],
			\   ['top', 'bottom'],
			\   ['em', 'px', '%'],
			\   ['bold', 'normal'],
			\   ['hover', 'active']
			\ ]
		]],
})

vim.cmd([[
let g:switch_camelcase = [{
  \ '\<\(\l\)\(\l\+\(\u\l\+\)\+\)\>': '\=toupper(submatch(1)) . submatch(2)',
  \ '\<\(\u\l\+\)\(\u\l\+\)\+\>':     "\\=tolower(substitute(submatch(0), '\\(\\l\\)\\(\\u\\)', '\\1_\\2', 'g'))",
  \ '\<\(\l\+\)\(_\l\+\)\+\>':        '\U\0',
  \ '\<\(\u\+\)\(_\u\+\)\+\>':        "\\=tolower(substitute(submatch(0), '_', '-', 'g'))",
  \ '\<\(\l\+\)\(-\l\+\)\+\>':        "\\=substitute(submatch(0), '-\\(\\l\\)', '\\u\\1', 'g')"
  \ }]
]])

nnoremap("!", "<silent>", ":<C-u>call switch#Switch({'definitions': g:switch_camelcase, 'reverse': 1})<CR>")

-- xnoremap("<S-Tab>", "<silent>", ":silent call switch#Switch({'reverse': 1})<CR>")

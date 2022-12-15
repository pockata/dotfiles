" These are a few custom functions and keybindings that are in purgatory. They
" might end up getting promoted to Lua heaven, but they might not. We shall
" see.

augroup vimrc
    autocmd!
augroup END

cabbrev rg lgrep

if executable("rg")
	set grepprg=rg\ --hidden\ --glob\ '!.git'\ --vimgrep\ --with-filename
	set grepformat=%f:%l:%c:%m
endif

augroup QuickfixConfig
	autocmd!

	autocmd QuickFixCmdPost [^l]* nested cwindow
	autocmd QuickFixCmdPost    l* nested lwindow
augroup END

augroup Colors
	autocmd!

	" make the precedes & extends characters red
	autocmd ColorScheme * highlight NonText guifg=red

	" " update the matched search background to not obscure the cursor
	" autocmd ColorScheme * highlight Search guibg=purple guifg=white

	" Highlight spelling errors
	autocmd ColorScheme * highlight SpellBad guifg=red gui=underline

	" " highlight long lines (but only one column)
	" autocmd ColorScheme * highlight ColorColumn guibg=#cc241d guifg=#fbf1c7 ctermbg=red ctermfg=white

	let colorcolumn_blacklist = ['Startify', 'htm', 'html', 'git', 'markdown', 'GV', 'fugitiveblame', 'dirvish', 'qf', '']
	autocmd BufWinEnter * if index(colorcolumn_blacklist, &ft) < 0 && &diff == 0 |
				\ call clearmatches() |
				\ call matchadd('ErrorMsg', '\s\+$', 100) |
				\ call matchadd('ErrorMsg', '\%81v', 100)

	" clear matches in fugitive buffers
	autocmd User FugitiveObject call clearmatches()

augroup END

augroup Filetypes
	autocmd!
	" make K look up the docs, not man
	autocmd FileType vim setlocal keywordprg=:help

	" TODO: Add blacklist (GV/fugitive, etc.)
	" follow symlink and set working directory
	autocmd! BufReadPost * call FollowSymlink()

	autocmd FileType apache setlocal commentstring=#%s

	autocmd FileType markdown,gitcommit setlocal spell

	" Jump to first file
	autocmd User FugitiveIndex :call feedkeys("gU")
	autocmd BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

	"https://www.reddit.com/r/vim/comments/3er2az/how_to_suppress_vims_warning_editing_a_read_only/
	autocmd BufEnter /etc/hosts set noro

	autocmd Filetype *
				\    if &omnifunc == "" |
				\        setlocal omnifunc=syntaxcomplete#Complete |
				\    endif

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid, when inside an event handler
	" (happens when dropping a file on gvim) and for a commit message (it's
	" likely a different one than last time).
	autocmd BufReadPost *
				\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
				\ |   exe "normal! g`\""
				\ | endif

	" TODO: Create a blacklist and trim everything else
	autocmd BufWrite * :call DeleteTrailingWS()

	autocmd BufNewFile,BufRead *.jsx set filetype=javascriptreact

	" Enhance `gf`, to use these file extensions
	" https://www.reddit.com/r/vim/comments/4kjgmz/weekly_vim_tips_and_tricks_thread_11/d3g6l8y
	" NOTE: Superseded by vim-apathy & LSP?
	autocmd FileType javascriptreact,javascript,jsx,javascript.jsx setlocal suffixesadd=.js,.jsx,.json,.html
	autocmd FileType javascriptreact,javascript,jsx,javascript.jsx setlocal path=.,src,node_nodules

	" " Make help files open up in a new tab
	" autocmd BufWinEnter *.txt silent! if &buftype == 'help' | wincmd T | nnoremap <buffer> q :q<cr> | endif
augroup END

augroup EarthsongConfig
	autocmd!

	autocmd ColorScheme earthsong-light highlight Normal guibg=#FFF2EB

	" Dirvish
	autocmd ColorScheme earthsong highlight link DirvishPathTail Question
augroup END

" " CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" " so that you can undo CTRL-U after inserting a line break.
" " Revert with ":iunmap <C-U>".
" inoremap <C-U> <C-G>u<C-U>

" nnoremap <silent> ]z :call NextClosedFold('j')<cr>
" nnoremap <silent> [z :call NextClosedFold('k')<cr>
" function! NextClosedFold(dir)
" 	let cmd = 'norm!z' . a:dir
" 	let view = winsaveview()
" 	let [l0, l, open] = [0, view.lnum, 1]
" 	while l != l0 && open
" 		exe cmd
" 		let [l0, l] = [l, line('.')]
" 		let open = foldclosed(l) < 0
" 	endwhile
" 	if open
" 		call winrestview(view)
" 	endif
" endfunction

" Source
nnoremap <leader>S ^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>
vnoremap <leader>S y:@"<CR>:echo 'Sourced lines.'<CR>

" paste register content and escape it
cnoremap <c-x> <c-r>=<SID>PasteEscaped()<cr>
function! s:PasteEscaped()
	echo "\\".getcmdline()."\""
	let char = getchar()
	if char == "\<esc>"
		return ''
	else
		let register_content = getreg(nr2char(char))
		let escaped_register = escape(register_content, '\'.getcmdtype())
		return substitute(escaped_register, '\n', '\\n', 'g')
	endif
endfunction

" Expand dirname for current file.
cnoreabbrev <expr> %% expand('%:h')

" Enable replacement in visual mode
cnoreabbrev vis s/\%V

" Execute the last macro
nnoremap Q @@

" Merge a tab into a split in the previous window
function! MergeTabs()
	if tabpagenr() == 1
		return
	endif

	let bufferName = bufname("%")

	if tabpagenr("$") == tabpagenr()
		close!
	else
		close!
		tabprev
	endif

	vsplit

	execute "buffer " . bufferName
endfunction

" Move current window into tab on the left
nmap <C-W>m :call MergeTabs()<CR>

" Execute macro over visual lines
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
	echo "@".getcmdline()
	execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Switch between tabs with `alt+{num}` in the terminal
if !has('nvim')
	for nr in range(1, 9)
		execute "set <M-".nr.">=\e".nr
	endfor
endif

" Delete all hidden buffers
nnoremap <silent> <Leader><BS> :call DeleteHiddenBuffers()<CR>
function! DeleteHiddenBuffers()
	let tpbl=[]

	call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')

	for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
		silent execute 'bwipeout' buf
	endfor

	echom "Removed hidden buffers!"
endfunction

" Diff this window with the previous one.
command! DiffThese diffthis | call clearmatches() | call MyWincmdPrevious() | diffthis | call clearmatches() | wincmd p

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
				\ | wincmd p | diffthis
endif

func! s:get_visual_selection_list() abort
	let [lnum1, col1] = getpos("'<")[1:2]
	let [lnum2, col2] = getpos("'>")[1:2]
	let lines = getline(lnum1, lnum2)
	let lines[-1] = lines[-1][: col2 - (&selection ==? 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][col1 - 1:]
	return lines
endf

"read the current line into command line
cnoremap <c-r><c-l> <c-r>=getline('.')<cr>

"read last visual-selection into command line
cnoremap <c-r><c-v> <c-r>=join(<sid>get_visual_selection_list(), " ")<cr>
inoremap <c-r><c-v> <c-r>=join(<sid>get_visual_selection_list(), " ")<cr>

" Go to first character of line on first press
" Go to start of line on second press
" http://ddrscott.github.io/blog/2016/vim-toggle-movement/
function! ToggleHomeZero()
	let pos = getpos('.')
	execute "normal! ^"
	if pos == getpos('.')
		execute "normal! 0"
	endif
endfunction

nnoremap <silent> 0 :call ToggleHomeZero()<CR>
onoremap <silent> 0 ^

" move horizontally
nnoremap z; 30zl
nnoremap zj 30zh

function! s:startup()
	if exists('g:loaded_startify')
		return
	endif

	let cnt = argc()
	" For NERDTree
	" if (cnt == 0)
	"     call FugitiveDetect(expand('%'))
	"     NERDTreeToggle
	"     wincmd w
	" elseif (cnt == 1 && isdirectory(argv(0)))
	"     exe "cd " . argv(0)
	"     call FugitiveDetect(expand('%'))
	"     NERDTreeToggle
	"     wincmd w
	" endif

	" if (cnt == 1 && isdirectory(argv(0)))
	"     exe "cd " . argv(0)
	" endif
	" Dirvish
	" call FugitiveDetect(expand("%"))
	" CmdSplit Gstatus

	if (cnt == 0)
		" " open the last edited file in a prev session
		" exe "normal! `0"
		Dirvish
	elseif (cnt == 1 && isdirectory(argv(0)))
		exe "cd " . argv(0)
		Dirvish
	endif
endfunction

augroup Startup
	autocmd VimEnter * silent! autocmd! FileExplorer *
	" au BufEnter * if s:isdir(expand('%')) | bd | exe 'Dirvish' | endif

	autocmd vimrc VimEnter * call s:startup()
augroup END

" Open hosts file
nmap <silent> <leader>eh :vsplit /etc/hosts<CR>
" nmap <silent> <leader>ed :tabe ~/dotfiles<CR>
" nmap <silent> <leader>ep :tabe ~/Projects<CR>

" " Change shape of cursor in different modes
" if !has("gui_running") && !has("nvim")
" 	" if &term == 'screen-256color'
" 	if exists('$TMUX')
" 		let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
" 		let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
" 		let &t_SR = "\<Esc>Ptmux;\<Esc>\e[3 q\<Esc>\\"
" 	else
" 		" solid underscore
" 		let &t_SI = "\e[5 q"
" 		let &t_SR = "\e[3 q"
" 		" solid block
" 		let &t_EI = "\e[2 q"
" 		" 1 or 0 -> blinking block
" 		" 3 -> blinking underscore
" 		" Recent versions of xterm (282 or above) also support
" 		" 5 -> blinking vertical bar
" 		" 6 -> solid vertical bar
" 	endif
" endif

" if has('nvim') || has('gui_running')
" 	set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
" endif

" I only use gvim for vim-everywhere, so we set some specific options
if has('gui_running')
	set textwidth=72
	set wrap
	set spell

	" set window size
	set lines=40
	set columns=90

	" Remove Gvim toolbar and menus
	set guioptions=
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
	exe "normal mz"
	%s/\s\+$//ge
	exe "normal `z"
endfunc

" ----------------------------------------------------------------------------
" Get Visual Selection helper function
" ----------------------------------------------------------------------------
function! s:getVisualSelection() range
	let old_reg = getreg('"')
	let old_regtype = getregtype('"')
	let old_clipboard = &clipboard
	set clipboard&
	normal! ""gvy
	let selection = getreg('"')
	call setreg('"', old_reg, old_regtype)
	let &clipboard = old_clipboard
	return selection
endfunction

" ----------------------------------------------------------------------------
" Clean empty buffers
" http://stackoverflow.com/a/10102604
" ----------------------------------------------------------------------------
function! s:CleanEmptyBuffers()
	let buffers = filter(range(0, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0 && !getbufvar(v:val, "&mod")')
	if !empty(buffers)
		silent! exe 'bw '.join(buffers, ' ')
	endif
endfunction

autocmd vimrc BufHidden * silent! call <SID>CleanEmptyBuffers()

" if has('langmap') && exists('+langremap')
" 	" Prevent that the langmap option applies to characters that result from a
" 	" mapping.  If set (default), this may break plugins (but it's backward
" 	" compatible).
" 	set nolangremap
" endif

" ----------------------------------------------------------------------------
" Switch to us layout
" https://zenbro.github.io/2015/07/24/auto-change-keyboard-layout-in-vim.html
" ----------------------------------------------------------------------------
function! RestoreKeyboardLayout(key)
	call system('xkb-switch -s us')
	if (a:key == 'a' || a:key == 'i')
		startinsert
	else
		execute 'normal! ' . a:key
	endif
endfunction
nnoremap <silent> в :call RestoreKeyboardLayout('w')<CR>
nnoremap <silent> с :call RestoreKeyboardLayout('s')<CR>
nnoremap <silent> д :call RestoreKeyboardLayout('d')<CR>

nnoremap <silent> а :call RestoreKeyboardLayout('a')<CR>
nnoremap <silent> и :call RestoreKeyboardLayout('i')<CR>
nnoremap <silent> о :call RestoreKeyboardLayout('o')<CR>

nnoremap <silent> й :call RestoreKeyboardLayout('h')<CR>
nnoremap <silent> к :call RestoreKeyboardLayout('j')<CR>
nnoremap <silent> л :call RestoreKeyboardLayout('k')<CR>

" follow symlinked file
function! FollowSymlink()
	let current_file = expand('%:p')
	" check if file type is a symlink
	if getftype(current_file) == 'link'
		" if it is a symlink resolve to the actual file path
		"   and open the actual file
		let actual_file = resolve(current_file)
		execute 'file ' . actual_file

		redraw
	end
endfunction

" un-join (split) the current line at the cursor position
" TODO: Fix collision with splitjoin
nnoremap g<CR> i<c-j><esc>k$

" Edit the contents of a register.
function! ChangeReg() abort
	let r = nr2char(getchar())
	if r =~# '[a-zA-Z0-9"@\-:.%#=*"~_/]'
		call feedkeys("q:ilet @" . r . " = \<C-r>\<C-r>=string(@" . r . ")\<CR>\<ESC>", 'n')
	endif
endfunction
nnoremap <silent> c" :call ChangeReg()<CR>

function! RenameFile() abort
	let old_name = expand('%')
	let new_name = input('[Renaming File] New file: ', expand('%'), 'file')
	if new_name != '' && new_name != old_name
		exec ':saveas ' . new_name
		exec ':silent !rm ' . old_name
		redraw!
	endif
endfunction

command! Rename call RenameFile()

" ----------------------------------------------------------------------------
" :Count
" ----------------------------------------------------------------------------
command! Count execute printf('%%s/%s//gn', escape(<q-args>, '/')) | normal! ``

" redirect the output of a Vim command into a scratch buffe
" https://www.reddit.com/r/vim/comments/4kjgmz/weekly_vim_tips_and_tricks_thread_11/d3g3bda/
function! Redir(cmd)
	redir => output
	execute a:cmd
	redir END
	vnew
	setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
	call setline(1, split(output, "\n"))
endfunction

command! -nargs=1 Redir silent call Redir(<f-args>)

function! CommitList()
	if get(b:, 'fugitive_type', '') == 'commit'
		let buffer = FugitiveParse()[0]
		call fzf#run(fzf#wrap({
					\'source': 'git diff --name-status '. shellescape(buffer) .' '. shellescape(buffer) .'^',
					\'sink': s:Fasd('e')
					\}))
	endif
endfunction

function! s:Fasd(cmd)
	let cmd = a:cmd
	function! Sink(line) closure
		execute(cmd . ' ' . split(a:line)[-1])
	endfunction
	return funcref('Sink')
endfunction

" https://superuser.com/questions/558743/vim-execute-bash-commands-make-in-the-same-window
command! -nargs=+ Run call setqflist(map(systemlist('<args>'), '{"filename": v:val}')) | copen

" TODO: Create a command Tableify
":%s/\t/</kb\/td>,tkbkb<td>/ggg0viVI<td>viV$A</td>gg0viVI<tr>viV$A</tr>

" set diffexpr=AutoDiff()
" function! AutoDiff()
"     let opt = '-1 -d -B'
"
"     if &diffopt =~ "iwhite"
"         let opt .= ' -b '
"     endif
"
"     let cmd = join(['!autobahn', opt, v:fname_in, v:fname_new, '>', v:fname_out])
"     silent exe cmd | redraw!
" endfunction

" Pastebin
" https://gist.github.com/romainl/1cad2606f7b00088dda3bb511af50d53
command! -range=% Pastebin  silent execute <line1> . "," . <line2> . "w !curl -F 'sprunge=<-' http://sprunge.us | tr -d '\\n' | xsel --clipboard --input"

" Load a list of changed fiels in the quickfix list
" https://vi.stackexchange.com/questions/13433/how-to-load-list-of-files-in-commit-into-quickfix
command! -nargs=? -bar Gshow call setqflist(map(systemlist("git show --pretty='' --name-only <args>"), '{"filename": v:val}')) | copen

" Create dir on file save
"
" http://travisjeffery.com/b/2011/11/saving-files-in-nonexistent-directories-with-vim/
augroup vimrc-auto-mkdir
	autocmd!
	autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
	" autocmd BufWritePre * if !exists('b:fugitive_type') || b:fugitive_type =~# '^\%(tree\|blob\)$' | call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
	function! s:auto_mkdir(dir, force)
		" Is it a remote protocol (scp, ftp, etc)?
		let isProtocol = stridx(expand('%:p:h'), "://") >= 0
		if !isProtocol && !isdirectory(a:dir)
					\   && (a:force
					\       || input("'" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$')
			call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
		endif
	endfunction
augroup END

command! -nargs=1 OpenBrowser :silent !xdg-open <args> > /dev/null 2>&1

" https://github.com/mkitt/tabline.vim/blob/master/plugin/tabline.vim
function! Tabline()
	let s = ''
	for i in range(tabpagenr('$'))
		let tab = i + 1
		let winnr = tabpagewinnr(tab)
		let buflist = tabpagebuflist(tab)
		let bufnr = buflist[winnr - 1]
		let bufname = bufname(bufnr)
		let bufmodified = getbufvar(bufnr, "&mod")

		let s .= '%' . tab . 'T'
		let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
		let s .= ' ' . tab .':'
		let s .= (bufname != '' ? ' ' . fnamemodify(bufname, ':t') . ' ' : '[No Name] ')

		if bufmodified
			let s .= '[+] '
		endif
	endfor

	let s .= '%#TabLineFill#'
	if (exists("g:tablineclosebutton"))
		let s .= '%=%999XX'
	endif
	return s
endfunction
set tabline=%!Tabline()

if exists("g:neovide")
	" Put anything you want to happen only in Neovide here
	let g:neovide_cursor_animation_length = 0
	set guifont=Fira\ Mono\ Medium\ for\ Powerline:h10
endif

" Diff the current file against n revision (instead of n commit)
function! Diffrev(...)
	let target = shellescape(@%)

	"check argument count
	if a:0 == 0
		"no revision number specified
		let revnum=0
	else
		"revision number specified
		let revnum=a:1
	endif

	let hash = system('git log -1 --skip='.revnum.' --pretty=format:"%h" ' . target)
	execute 'Gdiff ' . hash
endfunc

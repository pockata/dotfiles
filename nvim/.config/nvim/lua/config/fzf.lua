nnoremap("<Leader>h", "<silent>", ":History<CR>");
nnoremap("<Leader>j", "<silent>", ":Lines<CR>");
nnoremap("<Leader>r", "<silent>", ":BLines<CR>");
nnoremap("<Leader>w", "<silent>", ":Windows<CR>");
nnoremap("<Leader>b", "<silent>", ":Buffers<CR>");
nnoremap("<Leader>c", "<silent>", ":Commands<CR>");
nnoremap("<Leader>gf", "<silent>", ":GitFiles?<CR>");

-- TODO: fallback to :Files when not in a git dir? (like in smart_dirvish)
nnoremap("<c-p>", "<silent>", ":GitFiles<CR>");
nnoremap("<c-t>", "<silent>", ":Files<CR>");

vim.g.fzf_action = {
	['ctrl-t'] = 'tab split',
	['ctrl-s'] = 'split',
	['ctrl-v'] = 'vsplit'
}
-- Empty value to disable preview window altogether
vim.g.fzf_preview_window = {}

-- [Buffers] Jump to the existing window if possible
vim.g.fzf_buffers_jump = 1
vim.g.fzf_prefer_tmux = 0

vim.g["$FZF_DEFAULT_OPTS"] = '--layout=reverse --preview-window noborder'
vim.g.fzf_layout = { ['window'] = { ['width']= 0.5, ['height']= 0.6 } }

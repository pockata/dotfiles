require('Comment').setup({
	mappings = {
		extra = true,
	},
	pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

-- Extended keymaps were removed from the plugin
-- https://github.com/numToStr/Comment.nvim/wiki/Extended-Keybindings
local api = require('Comment.api')
local map = vim.keymap.set

-- map('n', 'g>', api.call('comment.linewise', 'g@'), { expr = true, desc = 'Comment region linewise' })
map('n', 'gc>', api.call('comment.linewise.current', 'g@$'), { expr = true, desc = 'Comment current line' })
map('n', 'gb>', api.call('comment.blockwise.current', 'g@$'), { expr = true, desc = 'Comment current block' })

-- map('n', 'g<', api.call('uncomment.linewise', 'g@'), { expr = true, desc = 'Uncomment region linewise' })
map('n', 'gc<', api.call('uncomment.linewise.current', 'g@$'), { expr = true, desc = 'Uncomment current line' })
map('n', 'gb<', api.call('uncomment.blockwise.current', 'g@$'), { expr = true, desc = 'Uncomment current block' })

local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)

map('x', 'g>', function()
    vim.api.nvim_feedkeys(esc, 'nx', false)
    api.locked('comment.linewise')(vim.fn.visualmode())
end, { desc = 'Comment region linewise (visual)' })

map('x', 'g<', function()
    vim.api.nvim_feedkeys(esc, 'nx', false)
    api.locked('uncomment.linewise')(vim.fn.visualmode())
end, { desc = 'Uncomment region linewise (visual)' })

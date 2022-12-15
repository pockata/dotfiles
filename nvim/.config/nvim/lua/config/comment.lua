require('Comment').setup({
	mappings = {
		extra = true,
	},
	pre_hook = function(ctx)
		-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring#commentnvim
		-- Only calculate commentstring for jsx and tsx filetypes
		local ft = vim.bo.filetype;
		-- TODO: Run on all filetypes by default?
		if ft == 'javascriptreact' or ft == 'typescriptreact' then
			local U = require('Comment.utils')

			-- Detemine whether to use linewise or blockwise commentstring
			local type = ctx.ctype == U.ctype.line and '__default' or '__multiline'

			-- Determine the location where to calculate commentstring from
			local location = nil
			if ctx.ctype == U.ctype.block then
				location = require('ts_context_commentstring.utils').get_cursor_location()
			elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
				location = require('ts_context_commentstring.utils').get_visual_start_location()
			end

			return require('ts_context_commentstring.internal').calculate_commentstring({
				key = type,
				location = location,
			})
		end
	end,
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

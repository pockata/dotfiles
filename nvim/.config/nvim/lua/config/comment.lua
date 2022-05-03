require('Comment').setup({
	mappings = {
		extra = false,
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


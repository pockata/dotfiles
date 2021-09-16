local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')
local providers = require('feline.providers')

-- re-highlight on colorscheme change
create_augroup('FelineConfig', {
	'ColorScheme * lua require("feline").reset_highlights()'
})

local force_inactive = {
	filetypes = {
		'NvimTree',
		'dbui',
		'packer',
		'startify',
		'fugitive',
		'fugitiveblame',
	},
	buftypes = {
		'terminal',
		'dirvish'
	},
	bufnames = {}
}

local colors = {
	bg = '#584945',
	black = '#282828',
	yellow = '#d8a657',
	cyan = '#89b482',
	oceanblue = '#45707a',
	green = '#a9b665',
	orange = '#e78a4e',
	violet = '#d3869b',
	magenta = '#c14a4a',
	white = '#a89984',
	fg = '#a89984',
	skyblue = '#7daea3',
	red = '#ea6962',
}

local vi_mode_colors = {
	NORMAL = 'green',
	OP = 'green',
	INSERT = 'red',
	VISUAL = 'skyblue',
	BLOCK = 'skyblue',
	REPLACE = 'violet',
	['V-REPLACE'] = 'violet',
	ENTER = 'cyan',
	MORE = 'cyan',
	SELECT = 'orange',
	COMMAND = 'green',
	SHELL = 'green',
	TERM = 'green',
	NONE = 'yellow'
}

local vi_mode_text = {
	NORMAL = 'N',
	OP = 'OP',
	INSERT = 'I',
	VISUAL = 'V',
	BLOCK = 'V-B',
	REPLACE = 'R',
	['V-REPLACE'] = 'V-R',
	ENTER = '<>',
	MORE = '<>',
	SELECT = 'S',
	COMMAND = 'C',
	SHELL = 'S-L',
	TERM = 'T',
	NONE = '<>'
}

local buffer_not_empty = function()
	if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
		return true
	end
	return false
end

local checkwidth = function()
	local squeeze_width  = vim.fn.winwidth(0) / 2
	if squeeze_width > 40 then
		return true
	end
	return false
end

-- show filetype/encoding only if it's not utf-8 & unix encoded
local checkEncoding = function()
	local enc = providers.file_encoding():lower()
	local format = vim.bo.fileformat:lower()
	return enc ~= "utf-8" or format ~= 'unix'
end

local filenameFunc = function(_, winid)
	local file = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(winid))
	file = vim.fn.fnamemodify(file, ":~:.")
	local function file_readonly()
		if vim.bo.filetype == 'help' then return '' end
		if vim.bo.readonly == true then return '  ' end
		return ''
	end
	local ro = file_readonly()

	if vim.fn.empty(file) == 1 then return '' end

	if string.len(ro) ~= 0 then return file .. ro end
	if vim.bo.modifiable then
		if vim.bo.modified then return file .. ' [+]' end
	end

	return file
end

-- Initialize the components table
local components = {
	active = {},
	inactive = {}
}

-- Insert three sections (left, mid and right) for the active statusline
table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.active, {})

-- Insert two sections (left and right) for the inactive statusline
table.insert(components.inactive, {})
table.insert(components.inactive, {})

-- LEFT
-- vi-mode
table.insert(components.active[1], {
	provider = function()
		local mode = vi_mode_text[vi_mode_utils.get_vim_mode()] or '?'
		return ' ' .. mode .. ' '
	end,
	hl = function()
		local val = {}

		val.bg = vi_mode_utils.get_mode_color()
		val.fg = 'black'
		val.style = 'bold'

		return val
	end,
	right_sep = ''
})

-- -- vi-symbol
-- {
-- 	provider = function()
-- 		return vi_mode_text[vi_mode_utils.get_vim_mode()]
-- 	end,
-- 	hl = function()
-- 		local val = {}
-- 		val.fg = vi_mode_utils.get_mode_color()
-- 		val.bg = 'bg'
-- 		val.style = 'bold'
-- 		return val
-- 	end,
-- 	right_sep = ' '
-- },

-- filename
table.insert(components.active[1], {
	provider = filenameFunc,
	hl = {
		fg = 'white',
		bg = 'bg',
		style = 'bold'
	},
	right_sep = ' ',
	left_sep = ' ',
})

-- gitBranch
table.insert(components.active[1], {
	provider = function ()
		local branch, icon = providers.git_branch({});
		local subs = {
			["feature/"] = "f/",
			["hotfix/"] = "hf/",
		}

		for k, v in pairs(subs) do
			branch = branch:gsub(k, v)
		end

		return branch, icon
	end,
	hl = {
		fg = 'yellow',
		bg = 'bg',
		style = 'bold'
	}
})

-- diffAdd
table.insert(components.active[1], {
	provider = 'git_diff_added',
	hl = {
		fg = 'green',
		bg = 'bg',
		style = 'bold'
	}
})

-- diffModfified
table.insert(components.active[1], {
	provider = 'git_diff_changed',
	hl = {
		fg = 'orange',
		bg = 'bg',
		style = 'bold'
	}
})

-- diffRemove
table.insert(components.active[1], {
	provider = 'git_diff_removed',
	hl = {
		fg = 'red',
		bg = 'bg',
		style = 'bold'
	}
})
-- })

-- MID
-- LspName
table.insert(components.active[2], {
	-- provider = 'lsp_client_names',
	provider = function ()
		local lsp_name, icon = providers.lsp_client_names({});
		local new_icon = string.len(lsp_name) > 0 and icon or ''
		return lsp_name:gsub("typescript", "ts"), new_icon
	end,
	hl = {
		fg = 'yellow',
		bg = 'bg',
		style = 'bold'
	},
	right_sep = ' '
})

-- diagnosticErrors
table.insert(components.active[2], {
	provider = 'diagnostic_errors',
	enabled = function() return lsp.diagnostics_exist('Error') end,
	hl = {
		fg = 'red',
		style = 'bold'
	}
})

-- diagnosticWarn
table.insert(components.active[2], {
	provider = 'diagnostic_warnings',
	enabled = function() return lsp.diagnostics_exist('Warning') end,
	hl = {
		fg = 'yellow',
		style = 'bold'
	}
})

-- diagnosticHint
table.insert(components.active[2], {
	provider = 'diagnostic_hints',
	enabled = function() return lsp.diagnostics_exist('Hint') end,
	hl = {
		fg = 'cyan',
		style = 'bold'
	}
})

-- diagnosticInfo
table.insert(components.active[2], {
	provider = 'diagnostic_info',
	enabled = function() return lsp.diagnostics_exist('Information') end,
	hl = {
		fg = 'skyblue',
		style = 'bold'
	}
})

-- RIGHT
-- fileType
table.insert(components.active[3], {
	provider = function()
		local ft = providers.file_type():lower()
		local overrides = {
			javascript = "js"
		}

		return overrides[ft] ~= nil and overrides[ft] or ft
	end,
	hl = function()
		local val = {}
		local filename = vim.fn.expand('%:t')
		local extension = vim.fn.expand('%:e')
		local icon, name  = require'nvim-web-devicons'.get_icon(filename, extension)
		if icon ~= nil then
			val.fg = vim.fn.synIDattr(vim.fn.hlID(name), 'fg')
		else
			val.fg = 'white'
		end
		val.bg = 'bg'
		val.style = 'bold'
		return val
	end,
	right_sep = ' '
})

-- fileEncode
table.insert(components.active[3], {
	provider = function() return ' ' .. providers.file_encoding():lower() .. '' end,
	enabled = checkEncoding,
	hl = {
		fg = '#1d2021',
		bg = colors.magenta,
		style = 'bold'
	},
	-- right_sep = ' '
})

-- fileFormat
table.insert(components.active[3], {
	provider = function() return ' [' .. vim.bo.fileformat:lower() .. '] ' end,
	enabled = checkEncoding,
	hl = {
		fg = '#1d2021',
		bg = colors.magenta,
		style = 'bold'
	},
	-- right_sep = ' '
})

-- lineInfo
table.insert(components.active[3], {
	provider = function()
		local curLine = vim.fn.line('.')
		local curColumn = vim.fn.col('.')
		local totalLines = vim.fn.line('$')

		return string.format(
			" %d/%d:%d ",
			-- percent,
			curLine,
			totalLines,
			curColumn
		)
	end,
	hl = {
		fg = colors.bg,
		bg = 'skyblue',
		style = 'bold'
	},
	right_sep = ''
})

-- INACTIVE
table.insert(components.inactive[1], {
	provider = filenameFunc,
	hl = {
		fg = 'white',
		bg = 'bg',
		style = 'bold'
	},
	right_sep = ' ',
	left_sep = {
		str = ' ',
	}
})

table.insert(components.inactive[2], {
	-- fileType
	provider = function() return providers.file_type():lower() end,
	hl = {
		fg = 'black',
		bg = 'cyan',
		style = 'bold'
	},
	left_sep = {
		str = ' ',
		hl = {
			fg = 'NONE',
			bg = 'cyan'
		}
	},
	right_sep = {
		{
			str = ' ',
			hl = {
				fg = 'NONE',
				bg = 'cyan'
			}
		},
		' '
	}
	,
})

require('feline').setup({
	colors = colors,
	default_bg = bg,
	default_fg = fg,
	vi_mode_colors = vi_mode_colors,
	components = components,
	force_inactive = force_inactive,
})


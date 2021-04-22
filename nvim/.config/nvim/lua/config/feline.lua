local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')
local providers = require('feline.providers')

local properties = {
	force_inactive = {
		filetypes = {},
		buftypes = {},
		bufnames = {}
	}
}

local components = {
	left = {active = {}, inactive = {}},
	mid = {active = {}, inactive = {}},
	right = {active = {}, inactive = {}}
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

properties.force_inactive.filetypes = {
	'NvimTree',
	'dbui',
	'packer',
	'startify',
	'fugitive',
	'fugitiveblame',
}

properties.force_inactive.buftypes = {
	'terminal',
	'dirvish'
}

-- LEFT

-- vi-mode
components.left.active[1] = {
	provider = function()
		local mode = vi_mode_text[vi_mode_utils.get_vim_mode()]
		return ' ' .. mode .. ' '
	end,
	hl = function()
		local val = {}

		val.bg = vi_mode_utils.get_mode_color()
		val.fg = 'black'
		val.style = 'bold'

		return val
	end,
	right_sep = ' '
}

-- -- vi-symbol
-- components.left.active[2] = {
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
-- }

-- filename
components.left.active[2] = {
	provider = function()
		local file = vim.fn.expand("%:F")
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
	end,
	hl = {
		fg = 'white',
		bg = 'bg',
		style = 'bold'
	},
	right_sep = ''
}

-- gitBranch
components.left.active[3] = {
	provider = 'git_branch',
	hl = {
		fg = 'yellow',
		bg = 'bg',
		style = 'bold'
	}
}

-- diffAdd
components.left.active[4] = {
	provider = 'git_diff_added',
	hl = {
		fg = 'green',
		bg = 'bg',
		style = 'bold'
	}
}

-- diffModfified
components.left.active[5] = {
	provider = 'git_diff_changed',
	hl = {
		fg = 'orange',
		bg = 'bg',
		style = 'bold'
	}
}

-- diffRemove
components.left.active[6] = {
	provider = 'git_diff_removed',
	hl = {
		fg = 'red',
		bg = 'bg',
		style = 'bold'
	}
}

-- MID

-- LspName
components.mid.active[1] = {
	provider = 'lsp_client_names',
	hl = {
		fg = 'yellow',
		bg = 'bg',
		style = 'bold'
	},
	right_sep = ' '
}
-- diagnosticErrors
components.mid.active[2] = {
	provider = 'diagnostic_errors',
	enabled = function() return lsp.diagnostics_exist('Error') end,
	hl = {
		fg = 'red',
		style = 'bold'
	}
}
-- diagnosticWarn
components.mid.active[3] = {
	provider = 'diagnostic_warnings',
	enabled = function() return lsp.diagnostics_exist('Warning') end,
	hl = {
		fg = 'yellow',
		style = 'bold'
	}
}
-- diagnosticHint
components.mid.active[4] = {
	provider = 'diagnostic_hints',
	enabled = function() return lsp.diagnostics_exist('Hint') end,
	hl = {
		fg = 'cyan',
		style = 'bold'
	}
}
-- diagnosticInfo
components.mid.active[5] = {
	provider = 'diagnostic_info',
	enabled = function() return lsp.diagnostics_exist('Information') end,
	hl = {
		fg = 'skyblue',
		style = 'bold'
	}
}

-- RIGHT

-- fileType
components.right.active[1] = {
	provider = function() return providers.file_type():lower() end,
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
}

-- fileEncode
components.right.active[2] = {
	provider = function() return ' ' .. providers.file_encoding():lower() .. '' end,
	hl = {
		fg = '#1d2021',
		bg = colors.magenta,
		style = 'bold'
	},
	-- right_sep = ' '
}

-- fileFormat
components.right.active[3] = {
	provider = function() return ' [' .. vim.bo.fileformat:lower() .. '] ' end,
	hl = {
		fg = '#1d2021',
		bg = colors.magenta,
		style = 'bold'
	},
	-- right_sep = ' '
}

-- lineInfo
components.right.active[4] = {
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
}

-- INACTIVE

-- components.left.inactive = components.left.active
-- -- components.middle.inactive = components.middle.active
-- components.right.inactive = components.right.active

-- file name
components.left.inactive[1] = components.left.active[2]

-- fileType
components.right.inactive[1] = {
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
}

require('feline').setup({
	colors = colors,
	default_bg = bg,
	default_fg = fg,
	vi_mode_colors = vi_mode_colors,
	components = components,
	properties = properties,
})


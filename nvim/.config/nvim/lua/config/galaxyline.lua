local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local lspclient = require('galaxyline.provider_lsp')
local fileinfo = require('galaxyline.provider_fileinfo')

local gls = gl.section
gl.short_line_list = {'defx', 'packager', 'vista', 'NvimTree'}

local colors = {
	bg = '#282c34',
	fg = '#aab2bf',
	section_bg = '#38393f',
	blue = '#61afef',
	green = '#98c379',
	purple = '#c678dd',
	orange = '#e5c07b',
	red1 = '#e06c75',
	red2 = '#be5046',
	yellow = '#e5c07b',
	gray1 = '#5c6370',
	gray2 = '#2c323d',
	gray3 = '#3e4452',
	darkgrey = '#5c6370',
	grey = '#848586',
	middlegrey = '#8791A5'
}

-- Local helper functions
local has_width_gt = function(cols)
	-- Check if the windows width is greater than a given number of columns
	return vim.fn.winwidth(0) / 2 > cols
end

local is_buffer_empty = function()
	-- Check whether the current buffer is empty
	return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

local buffer_not_empty = function()
	return not is_buffer_empty()
end

local checkwidth = function()
	return has_width_gt(45)
end

local function has_value(tab, val)
	for index, value in ipairs(tab) do
		if value[1] == val then return true end
	end
	return false
end

local strSplit = function (inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

local mode_color = function()
	local mode_colors = {
		[110] = colors.green,
		[105] = colors.blue,
		[99] = colors.green,
		[116] = colors.blue,
		[118] = colors.purple,
		[22] = colors.purple,
		[86] = colors.purple,
		[82] = colors.red1,
		[115] = colors.red1,
		[83] = colors.red1
	}

	mode_color = mode_colors[vim.fn.mode():byte()]
	if mode_color ~= nil then
		return mode_color
	else
		return colors.purple
	end
end

local function file_readonly()
	if vim.bo.filetype == 'help' then return '' end
	if vim.bo.readonly == true then return '  ' end
	return ''
end

local function get_current_file_name()
	local file = vim.fn.expand('%:t')
	local folder = vim.fn.expand('%:h')

	if folder ~= '.' then
		if string.find(folder, '/') ~= nil and not has_width_gt(55) then
			local parts = strSplit(folder, '/')
			local isAbsolute = string.sub(folder, 1, 1) == '/'

			folder = ''
			for _, v in pairs(parts) do
				local firstLeter = string.sub(v, 1, 1)
				if firstLeter == '.' then firstLeter = '.' .. string.sub(v, 2, 2) end
				folder = folder .. firstLeter .. '/'
			end

			folder = string.sub(folder, 0, string.len(folder) - 1)
			if isAbsolute then folder = '/' .. folder end
		end

		folder = folder .. '/'

	else
		folder = ''
	end

	local ret = folder .. file

	if vim.fn.empty(file) == 1 then return '' end

	if string.len(file_readonly()) ~= 0 then return ret .. file_readonly() end
	if vim.bo.modifiable then
		if vim.bo.modified then return ret .. '[+]' end
	end

	return ret
end

-- local function trailing_whitespace()
--     local trail = vim.fn.search('\\s$', 'nw')
--     if trail ~= 0 then
--         return '  '
--     else
--         return nil
--     end
-- end

-- local function tab_indent()
--     local tab = vim.fn.search('^\\t', 'nw')
--     if tab ~= 0 then
--         return ' → '
--     else
--         return nil
--     end
-- end

-- local function buffers_count()
--     local buffers = {}
--     for _, val in ipairs(vim.fn.range(1, vim.fn.bufnr('$'))) do
--         if vim.fn.bufexists(val) == 1 and vim.fn.buflisted(val) == 1 then
--             table.insert(buffers, val)
--         end
--     end
--     return #buffers
-- end

local function get_basename(file) return file:match("^.+/(.+)$") end

local GetGitRoot = function()
	local git_dir = require('galaxyline.provider_vcs').get_git_dir()
	if not git_dir then return '' end

	local git_root = git_dir:gsub('/.git/?$', '')
	return get_basename(git_root)
end

-- Left side
gls.left[1] = {
	ViMode = {
		provider = function()
			local aliases = {
				[110] = 'N',
				[105] = 'I',
				[99] = 'C',
				[116] = 'T',
				[118] = 'V',
				[22] = 'V-B',
				[86] = 'V-L',
				[82] = 'R',
				[115] = 'S',
				[83] = 'S-L'
			}
			vim.api.nvim_command('hi GalaxyViMode guibg=' .. mode_color())
			alias = aliases[vim.fn.mode():byte()]
			if alias ~= nil then
				if true then
					mode = alias
				else
					mode = alias:sub(1, 1)
				end
			else
				mode = vim.fn.mode():byte()
			end
			return '  ' .. mode .. ' '
		end,
		highlight = {colors.bg, colors.bg, 'bold'}
	}
}

gls.left[2] = {
	GitIcon = {
		provider = function() return '   ' end,
		condition = condition.check_git_workspace,
		highlight = {colors.middlegrey, colors.bg}
	}
}
gls.left[3] = {
	GitBranch = {
		provider = 'GitBranch', -- better icon? - 
		condition = condition.check_git_workspace,
		separator = ' ',
		highlight = {colors.middlegrey, colors.bg}
	}
}
-- gls.left[4] = {
--     GitRoot = {
--         provider = {GetGitRoot},
--         condition = condition.check_git_workspace,
--         separator = ' ',
--         separator_highlight = {colors.bg, colors.bg},
--         highlight = {colors.middlegrey, colors.bg}
--     }
-- }
gls.left[4] = {
	FileName = {
		provider = function() return '  ' .. get_current_file_name() end,
		condition = buffer_not_empty,
		highlight = {colors.fg, colors.section_bg},
		-- separator = '',
		separator_highlight = {colors.section_bg, colors.bg}
	}
}
-- gls.left[4] = {
--     WhiteSpace = {
--         provider = trailing_whitespace,
--         condition = buffer_not_empty,
--         highlight = {colors.fg, colors.bg}
--     }
-- }

gls.left[9] = {
	DiagnosticError = {
		provider = 'DiagnosticError',
		icon = '  ',
		highlight = {colors.red1, colors.bg}
	}
}
gls.left[10] = {
	Space = {
		provider = function() return ' ' end,
		highlight = {colors.section_bg, colors.bg}
	}
}
gls.left[11] = {
	DiagnosticWarn = {
		provider = 'DiagnosticWarn',
		icon = '  ',
		highlight = {colors.orange, colors.bg}
	}
}
gls.left[12] = {
	Space = {
		provider = function() return ' ' end,
		highlight = {colors.section_bg, colors.bg}
	}
}
gls.left[13] = {
	DiagnosticInfo = {
		provider = 'DiagnosticInfo',
		icon = '  ',
		highlight = {colors.blue, colors.section_bg},
		separator = ' ',
		separator_highlight = {colors.section_bg, colors.bg}
	}
}

-- Right side
gls.right[1] = {
	DiffAdd = {
		provider = 'DiffAdd',
		condition = checkwidth,
		icon = '+',
		highlight = {colors.green, colors.bg}
	}
}
gls.right[2] = {
	DiffModified = {
		provider = 'DiffModified',
		condition = checkwidth,
		icon = '~',
		highlight = {colors.orange, colors.bg}
	}
}
gls.right[3] = {
	DiffRemove = {
		provider = 'DiffRemove',
		condition = checkwidth,
		icon = '-',
		highlight = {colors.red1, colors.bg}
	}
}
gls.right[4] = {
	Space = {
		provider = function() return '  ' end,
		highlight = {colors.section_bg, colors.bg}
	}
}

gls.right[5] = {
	Filetype = {
		provider = function()
			local ft = vim.bo.filetype
			if not has_width_gt(40) then
				ft = string.gsub(ft, 'javascript', 'js')
			end
			return '  ' .. ft .. ' '
		end,
		highlight = {colors.gray2, colors.purple}
	}
}

gls.right[6] = {
	LSPClient = {
		condition = function () return has_width_gt(60) end,
		provider = function()
			local lspServer = lspclient.get_lsp_client()
			return ' (' .. lspServer .. ') '
		end,
		highlight = {colors.gray2, colors.purple}
	}
}

gls.right[7] = {
	FileFormat = {
		condition = function () return has_width_gt(50) end,
		provider = function() return '  [' .. string.lower(fileinfo.get_file_format()) .. '] ' end,
		highlight = {colors.gray2, colors.orange}
	}
}

gls.right[8] = {
	PerCent = {
		provider = function()
			local trim = function (s)
				return (s:gsub("^%s*(.-)%s*$", "%1"))
			end
			local percent = trim(fileinfo.current_line_percent())
			local pos = vim.fn.getcurpos()
			local curLine = pos[2]
			local curColumn = pos[3]
			local totalLines = vim.fn.line('$')

			-- this is just silly
			if percent == 'Top' then
				percent = '0%'
			elseif percent == 'Bot' then
				percent = '100%'
			end

			return string.format(
				"  %s %d/%d:%d ",
				percent,
				curLine,
				totalLines,
				curColumn
			)
		end,
		-- separator = ' ',
		-- separator_highlight = {colors.blue, colors.bg},
		highlight = {colors.gray2, colors.blue}
	}
}
-- gls.right[9] = {
--     ScrollBar = {
--         provider = 'ScrollBar',
--         highlight = {colors.purple, colors.section_bg}
--     }
-- }

-- Short status line
-- gls.short_line_left[1] = {
--     Test = {
--         provider = function() return "lek" end,
--         highlight = {
--             colors.section_bg
--         }
--     }
-- }
gls.short_line_left[2] = {
	FileName = {
		provider = function() return ' ' .. get_current_file_name() .. ' ' end,
		condition = buffer_not_empty,
		highlight = {colors.fg, colors.section_bg},
		-- separator = '',
		separator_highlight = {colors.section_bg, colors.bg}
	}
}

gls.short_line_right[1] = {
	BufferIcon = {
		provider = 'BufferIcon',
		highlight = {colors.yellow, colors.section_bg},
		separator = '',
		separator_highlight = {colors.section_bg, colors.bg}
	}
}

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()


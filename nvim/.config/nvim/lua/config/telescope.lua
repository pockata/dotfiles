local actions = require('telescope.actions')
local layout = require('telescope.actions.layout')
local action_set = require "telescope.actions.set"
local tele = require('telescope.builtin')

require('telescope').setup{
	defaults = {
		vimgrep_arguments = {
			'rg',
			'--color=never',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case',
			'--hidden', -- include hidden files, but respect .gitignore
			--hidden includes .git folders. providing --ignore-vcs does nothing
			'--glob',
			'!{node_modules/*,.git/*}',
		},
		layout_strategy = 'flex',
		prompt_prefix = "❯ ",
		layout_config = {
			flex = {
				flip_columns = 150
			},
			vertical = {
				prompt_position = "bottom",
				-- TODO: Send PR to support this.
				-- sorting_strategy = "descending",
				mirror = true,
			},
			horizontal = {
				prompt_position = "top",
			}
		},
		selection_caret = "❯ ",
		sorting_strategy = "ascending",
		path_display = {"absolute"},
		winblend = 15,
		-- scroll_strategy = "limit",
		-- better than the default one, but not as good as fzf
		-- generic_sorter = require('telescope.sorters').get_fzy_sorter,
		-- file_sorter = require('telescope.sorters').get_fzy_sorter,

		mappings = {
			i = {
				-- use c-s for horizontal splitting
				["<c-x>"] = false,
				["<c-s>"] = actions.select_horizontal,
				-- exit with Esc from insert mode (I don't need normal mode here)
				["<esc>"] = actions.close,
				["<c-a>"] = actions.select_all,

				["<c-k>"] = actions.move_selection_next,
				["<c-l>"] = actions.move_selection_previous,

				["<s-up>"] = actions.preview_scrolling_up,
				["<s-down>"] = actions.preview_scrolling_down,

				["<a-p>"] = layout.toggle_preview,
				-- use native <c-u> mapping
				["<C-u>"] = false,
			}
		}
	},
	extensions = {
		-- use a port of fzf's file sorter
		fzf = {
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	}
}

require('telescope').load_extension('fzf')
require("telescope").load_extension("recent_files")

create_augroup('TelescopeConfig',
	'User TelescopePreviewerLoaded setlocal shiftwidth=2 tabstop=2 expandtab'
)

function _G.EditNvim()
	tele.find_files {
		prompt_title = "~ nvim config ~",
		cwd = '~/dotfiles/nvim/.config/nvim',
	}
end

function _G.EditDotfiles()
	tele.find_files {
		prompt_title = "~ dotfiles ~",
		cwd = '~/dotfiles/',
		find_command = {
			'rg',
			'--files',
			'--hidden',
			--hidden includes .git folders. providing --ignore-vcs does nothing
			'--glob',
			'!{node_modules/*,.git/*}',
		}
	}
end

function _G.OpenProjects()
	tele.find_files(require('telescope.themes').get_dropdown({
		prompt_title = "~ Projects ~",
		cwd = '~/Projects',
		find_command = {
			'find',
			'-maxdepth', '2',
			'-mindepth', '2',
			'-type', 'd',
			'-printf', '%P\n',
		},
		previewer = false,
		layout_config = {
			height = 30,
		},
		attach_mappings = function()
			action_set.select:enhance {
				post = function()
					-- lcd to the project folder
					vim.cmd [[ ProjectRootLCD ]]
				end,
			}

			return true
		end
	}))
end

-- Show git_files if in a git repo, find_files otherwise
function _G.SmartProjectFiles()
	-- the recipe from https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes
	-- doesn't work in recent versions of Telescope. use lspconfig's util to
	-- simplify checking if we're in a git repo
	local dir = require("lspconfig.util").root_pattern(".git")(vim.fn.getcwd())

	if dir ~= nil then
		tele.git_files()
	else
		tele.find_files({ hidden = true })
	end
end

function _G.EditInstalledPlugins()
	tele.find_files {
		prompt_title = "~ nvim plugins ~",
		cwd = vim.fn.stdpath('data') .. '/site/pack/packer/'
	}
end

function _G.TelescopeCurrentBuffer()
	local opts = require('telescope.themes').get_dropdown {
		winblend = 10,
		border = true,
		previewer = false,
		shorten_path = false,
		layout_config = {
			height = 25,
		}
	}
	tele.current_buffer_fuzzy_find(opts)
end

local FZFDropdown = require('telescope.themes').get_dropdown {
	winblend = 10,
	border = true,
	previewer = false,
	shorten_path = false,
	layout_config = {
		height = 25,
	}
}

-- General keybindings
nnoremap("<Leader>fo", "<silent>", "<cmd>lua require('telescope').extensions.recent_files.pick()<CR>");
nnoremap("<Leader>j", "<silent>", "<cmd>Telescope live_grep<CR>");
nnoremap("<Leader>r", "<silent>", ":lua TelescopeCurrentBuffer()<CR>");
nnoremap("<Leader>w", "<silent>", "<cmd>Telescope builtin<CR>");
nnoremap("<Leader>b", "<silent>", "<cmd>Telescope buffers<CR>");
-- nnoremap("<Leader>c", "<silent>", "<cmd>Telescope commands<CR>");
nnoremap("<Leader>gf", "<silent>", "<cmd>Telescope git_status<CR>");

-- Special files
nmap('<leader>fi', '<silent>', "<cmd>lua EditInstalledPlugins()<CR>")
nmap('<leader>ev', '<silent>', "<cmd>lua EditNvim()<CR>")
nmap('<leader>ed', '<silent>', "<cmd>lua EditDotfiles()<CR>")
nmap('<leader>ep', '<silent>', "<cmd>lua OpenProjects()<CR>")

-- Project navigation
noremap("<c-p>", "<silent>", "<cmd>lua SmartProjectFiles()<CR>");
noremap("<c-t>", "<silent>", "<cmd>Telescope find_files<CR>");

-- search project-wide for the word under the cursor
-- TODO: Send a PR for using a visual selection
noremap("H", "<silent>", "<cmd>Telescope grep_string<CR>");

-- Emulate FZF's commands which I use rarely and don't have them bound to a key
function _G.SelectColorScheme() tele.colorscheme(FZFDropdown) end
function _G.SelectFiletype() tele.filetypes(FZFDropdown) end

vim.cmd [[ command! -bar Filetypes :lua SelectFiletype() ]]
vim.cmd [[ command! -bar Colors :lua SelectColorScheme() ]]


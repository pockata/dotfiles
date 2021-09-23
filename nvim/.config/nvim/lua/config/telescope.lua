local actions = require('telescope.actions')
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
		},
		prompt_prefix = "❯ ",
		layout_config = {
			prompt_position = "top"
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
				["<c-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				-- exit with Esc from insert mode (I don't need normal mode here)
				["<esc>"] = actions.close,

				["<c-k>"] = actions.move_selection_next,
				["<c-l>"] = actions.move_selection_previous,
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

create_augroup('TelescopeConfig',
	'User TelescopePreviewerLoaded setlocal shiftwidth=4'
)

function _G.EditNvim()
	tele.find_files {
		prompt_title = "~ nvim config ~",
		layout_strategy = 'flex',
		cwd = '~/dotfiles/nvim/.config/nvim',
	}
end

function _G.EditDotfiles()
	tele.find_files {
		prompt_title = "~ dotfiles ~",
		layout_strategy = 'flex',
		cwd = '~/dotfiles/',
		hidden = true,
	}
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
		cwd = vim.fn.stdpath('data') .. '/site/pack/packer/start/'
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
nnoremap("<Leader>fo", "<silent>", "<cmd>Telescope oldfiles<CR>");
nnoremap("<Leader>j", "<silent>", "<cmd>Telescope live_grep<CR>");
nnoremap("<Leader>r", "<silent>", ":lua TelescopeCurrentBuffer()<CR>");
nnoremap("<Leader>w", "<silent>", "<cmd>Telescope builtin<CR>");
nnoremap("<Leader>b", "<silent>", "<cmd>Telescope buffers<CR>");
nnoremap("<Leader>c", "<silent>", "<cmd>Telescope commands<CR>");
nnoremap("<Leader>gf", "<silent>", "<cmd>Telescope git_status<CR>");

-- Special files
nmap('<leader>fi', '<silent>', "<cmd>lua EditInstalledPlugins()<CR>")
nmap('<leader>ev', '<silent>', "<cmd>lua EditNvim()<CR>")
nmap('<leader>ed', '<silent>', "<cmd>lua EditDotfiles()<CR>")

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


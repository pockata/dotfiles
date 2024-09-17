local actions = require("telescope.actions")
local layout = require("telescope.actions.layout")
local action_state = require("telescope.actions.state")
local tele = require("telescope.builtin")

require("telescope").setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--trim",
			"--hidden", -- include hidden files, but respect .gitignore
			--hidden includes .git folders. providing --ignore-vcs does nothing
			"--glob",
			"!{node_modules/*,.git/*}",
		},
		layout_strategy = "flex",
		prompt_prefix = "❯ ",
		layout_config = {
			flex = {
				flip_columns = 150,
			},
			vertical = {
				prompt_position = "bottom",
				-- TODO: Send PR to support this.
				-- sorting_strategy = "descending",
				mirror = true,
			},
			horizontal = {
				prompt_position = "top",
			},
		},
		selection_caret = "❯ ",
		sorting_strategy = "ascending",
		-- truncate paths based on your cwd
		path_display = function(_, path)
			-- transform /home/user/Projects/Name/sub-folder/... to ./sub-folder/...
			path = path:gsub("^" .. vim.fn.getcwd() .. "/", "./")
			-- transform /home/user/... to ~/...
			path = path:gsub("^" .. vim.fn.getenv("HOME") .. "/", "~/")
			return path
		end,
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

				["<c-k>"] = actions.move_selection_next,
				["<c-l>"] = actions.move_selection_previous,

				["<s-up>"] = actions.preview_scrolling_up,
				["<s-down>"] = actions.preview_scrolling_down,

				["<a-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<a-p>"] = layout.toggle_preview,

				-- use native <c-u> mapping
				["<C-u>"] = false,
			},
		},
	},
	extensions = {
		-- use a port of fzf's file sorter
		fzf = {
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},

		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
	},
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("recent_files")
require("telescope").load_extension("ui-select")

create_augroup("TelescopeConfig", "User TelescopePreviewerLoaded setlocal shiftwidth=2 tabstop=2 expandtab")

function _G.EditNvim()
	tele.find_files({
		prompt_title = "~ nvim config ~",
		cwd = "~/dotfiles/nvim/.config/nvim",
	})
end

local function is_image(filepath)
	local image_extensions = { "png", "jpg", "jpeg", "gif" } -- Supported image formats
	local split_path = vim.split(filepath:lower(), ".", { plain = true })
	local extension = split_path[#split_path]
	return vim.tbl_contains(image_extensions, extension)
end

local function custom_default(
	prompt_bufnr --[[ , map ]]
)
	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()

		if is_image(selection[1]) then
			local dir = vim.fn.fnamemodify(selection.path, ":p:h")
			-- open dirvish and move the cursor to the selected file
			vim.cmd(string.format("Dirvish %s", vim.fn.fnameescape(dir)))
			vim.fn.search(selection[1])
		else
			actions.select_default()
		end
	end)
	return true
end

function _G.EditDotfiles()
	tele.find_files({
		prompt_title = "~ dotfiles ~",
		cwd = "~/dotfiles/",
		find_command = {
			"rg",
			"--files",
			"--hidden",
			--hidden includes .git folders. providing --ignore-vcs does nothing
			"--glob",
			"!{node_modules/*,.git/*}",
		},
	})
end

-- Show git_files if in a git repo, find_files otherwise
function _G.SmartProjectFiles()
	-- the recipe from https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes
	-- doesn't work in recent versions of Telescope. use lspconfig's util to
	-- simplify checking if we're in a git repo
	local dir = require("lspconfig.util").root_pattern(".git")(vim.fn.getcwd())

	if dir ~= nil then
		tele.git_files({
			-- attach_mappings = custom_default,
		})
	else
		tele.find_files({
			hidden = true,
			-- attach_mappings = custom_default,
		})
	end
end

function _G.EditInstalledPlugins()
	tele.find_files({
		prompt_title = "~ nvim plugins ~",
		cwd = vim.fn.stdpath("data") .. "/lazy",
	})
end

function _G.TelescopeCurrentBuffer()
	local opts = require("telescope.themes").get_dropdown({
		winblend = 10,
		border = true,
		previewer = false,
		shorten_path = false,
		layout_config = {
			height = 25,
		},
	})
	tele.current_buffer_fuzzy_find(opts)
end

local FZFDropdown = require("telescope.themes").get_dropdown({
	winblend = 10,
	border = true,
	previewer = false,
	shorten_path = false,
	layout_config = {
		height = 25,
	},
})

-- https://www.petergundel.de/git/neovim/telescope/2023/03/22/git-jump-in-neovim-with-telescope.html
local git_hunks = function()
	require("telescope.pickers")
		.new({
			finder = require("telescope.finders").new_oneshot_job({ "git", "jump", "--stdout", "diff" }, {
				entry_maker = function(line)
					local filename, lnum_string = line:match("([^:]+):(%d+).*")

					-- I couldn't find a way to use grep in new_oneshot_job so we have to filter here.
					-- return nil if filename is /dev/null because this means the file was deleted.
					if filename:match("^/dev/null") then
						return nil
					end

					return {
						value = filename,
						display = line,
						ordinal = line,
						filename = filename,
						lnum = tonumber(lnum_string),
					}
				end,
			}),
			sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
			previewer = require("telescope.config").values.grep_previewer({}),
			attach_mappings = function(_, map)
				map("i", "<c-space>", actions.to_fuzzy_refine)
				return true
			end,
			push_cursor_on_edit = true,
			results_title = "Git hunks",
			prompt_title = "Git hunks",
			layout_strategy = "flex",
		}, {})
		:find()
end

vim.keymap.set("n", "<Leader>gh", git_hunks, {})

-- General keybindings
nnoremap("<Leader>fo", "<silent>", "<cmd>lua require('telescope').extensions.recent_files.pick()<CR>")
nnoremap("<Leader>j", "<silent>", "<cmd>Telescope live_grep<CR>")
nnoremap("<Leader>r", "<silent>", ":lua TelescopeCurrentBuffer()<CR>")
nnoremap("<Leader>w", "<silent>", "<cmd>Telescope builtin<CR>")
nnoremap("<Leader>b", "<silent>", "<cmd>Telescope buffers<CR>")
nnoremap("gR", "<silent>", "<cmd>lua require('telescope.builtin').lsp_references({ jump_type = 'never' })<CR>")
nnoremap("gr", "<silent>", "<cmd>Telescope lsp_incoming_calls<CR>")
nnoremap("<Leader>e", "<silent>", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>")
-- nnoremap("<Leader>c", "<silent>", "<cmd>Telescope commands<CR>");
nnoremap("<Leader>gf", "<silent>", "<cmd>Telescope git_status<CR>")
noremap("<leader>fh", "<silent>", "<cmd>Telescope help_tags<CR>")

-- Special files
nmap("<leader>fi", "<silent>", "<cmd>lua EditInstalledPlugins()<CR>")
nmap("<leader>ev", "<silent>", "<cmd>lua EditNvim()<CR>")
nmap("<leader>ed", "<silent>", "<cmd>lua EditDotfiles()<CR>")

-- Project navigation
noremap("<c-p>", "<silent>", "<cmd>lua SmartProjectFiles()<CR>")
noremap("<c-t>", "<silent>", "<cmd>lua require('telescope.builtin').find_files({ hidden = true })<CR>")

-- remap the default <c-t> mapping because it's useful with LSP
nnoremap("<c-b>", "<silent>", "<c-t>")

-- search project-wide for the word under the cursor
-- TODO: Send a PR for using a visual selection
noremap("H", "<silent>", "<cmd>Telescope grep_string<CR>")

-- Emulate FZF's commands which I use rarely and don't have them bound to a key
function _G.SelectColorScheme()
	tele.colorscheme(FZFDropdown)
end

function _G.SelectFiletype()
	tele.filetypes(FZFDropdown)
end

vim.cmd([[ command! -bar Filetypes :lua SelectFiletype() ]])
vim.cmd([[ command! -bar Colors :lua SelectColorScheme() ]])

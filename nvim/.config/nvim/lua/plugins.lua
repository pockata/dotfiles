local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

vim.cmd [[cabbrev ps Lazy]]
vim.cmd [[cabbrev pi Lazy]]

local opts = {
	dev = {
		path = "~/Projects/personal",
	}
}

require('lazy').setup({
	-- -- filedetect drop-in-placement
	-- "nathom/filetype.nvim",

	-- TODO: Test lua rewrite - numToStr/Navigator.nvim
	-- TODO: Test lua rewrite - nathom/tmux.nvim
	{
		"christoomey/vim-tmux-navigator",
		config = function()
			require("config.tmux-navigator")
		end
	},

	-- -- Alternative: https://github.com/jpalardy/vim-slime
	-- use {
	-- 	"christoomey/vim-tmux-runner", config = function()
	-- 		nnoremap("<leader>v-", ":VtrOpenRunner { "orientation": "v", "percentage": 30 }<cr>");
	-- 	end
	-- }

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("config.treesitter")
		end,
		dependencies = {
			-- for debugging treesitter queries (for textobjects)
			"nvim-treesitter/playground",
			--
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				dev = true,
			}
			-- Check it out
			-- "mfussenegger/nvim-ts-hint-textobject"
		},
	},

	"nvim-treesitter/nvim-treesitter-context",

	-- Autocomplete & Linters
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("config.lspconfig")
		end,
	},

	-- TODO: Check this one out if it"s not superceded by FriendlySnippets
	-- use { "xianghongai/vscode-javascript-comment",
	-- 	config = function()
	-- 		-- os.execute(
	-- 		-- 	string.format(
	-- 		-- 		"cd %s/site/pack/packer/start/vscode-javascript-comment/ && npm install && node ./merge.js",
	-- 		-- 		vim.fn.stdpath("data")
	-- 		-- 	)
	-- 		-- )
	-- 	end
	-- }

	{
		"hrsh7th/nvim-cmp",
		-- event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			require("config.cmp")
		end,
		dependencies = {
			-- for icons/types in inscompletion
			"onsails/lspkind-nvim",

			-- cmp completion sources
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"andersevenrud/cmp-tmux",

			-- automatch quotes and brackets
			{
				"windwp/nvim-autopairs",
				config = function()
					require("config.autopairs")
				end,
				dependencies = "hrsh7th/nvim-cmp",
			},

			-- snippets
			{
				"L3MON4D3/LuaSnip",
				config = function()
					require("config.snippets")
				end,
				dependencies = {
					"saadparwaiz1/cmp_luasnip",
					"rafamadriz/friendly-snippets",
				}
			},
		}
	},

	{
		"tjdevries/complextras.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		config = function()
			vim.api.nvim_set_keymap(
				"i",
				"<C-x><C-m>",
				[[<c-r>=luaeval("require('complextras').complete_matching_line()")<CR>]],
				{ noremap = true }
			)

			vim.api.nvim_set_keymap(
				"i",
				"<C-x><C-d>",
				[[<c-r>=luaeval("require('complextras').complete_line_from_cwd()")<CR>]],
				{ noremap = true }
			)
		end
	},

	{
		"folke/todo-comments.nvim",
		config = function()
			require("config.todo")
		end,
	},

	-- use "famiu/bufdelete.nvim"

	{
		"williamboman/mason.nvim",
		config = function()
			require("config.lsp")
		end,
		dependencies = {
			"nvim-lspconfig",
			{
				"williamboman/mason-lspconfig.nvim",
				config = function()
				end,
			},
		},
	},

	-- TODO: replace with https://github.com/olimorris/dotfiles/commit/bac18fb2338d8a97418787acfeac346246f515be
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					-- null_ls.builtins.formatting.stylua,
					null_ls.builtins.diagnostics.eslint_d,
					-- null_ls.builtins.completion.spell,
				},
			})
		end
	},

	{
		"andymass/vim-matchup",
		config = function()
			vim.g.matchup_matchparen_offscreen = {}
			vim.g.matchup_matchparen_enabled = 0
			vim.g.matchup_surround_enabled = 0
		end,
	},

	{
		"justinmk/vim-dirvish",
		config = function()
			require("config.dirvish")
		end,
		dependencies = {
			{
				"kristijanhusak/vim-dirvish-git",
				config = function()
					vim.g.dirvish_git_indicators = {
						Modified = '!',
						Staged = '+',
						Untracked = 'u',
						Renamed = '>',
						Unmerged = '=',
						Ignored = 'i',
						Unknown = '?'
					}
				end
			},
			"roginfarrer/vim-dirvish-dovish",
		}
	},

	-- -- Respect .editorconfig files
	-- use { "editorconfig/editorconfig-vim",
	-- 	config = function()
	-- 		vim.g.EditorConfig_exclude_patterns = {"fugitive://.*"}
	-- 		create_augroup(
	-- 			"DisableEditorConfig",
	-- 			"FileType gitcommit let b:EditorConfig_disable = 1"
	-- 		)
	-- 	end
	-- }

	-- Theming
	{
		"theJian/nvim-moonwalk",
	},
	{
		"morhetz/gruvbox",
		config = function()
			require("config.gruvbox")
		end,
	},
	{
		"xiantang/darcula-dark.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{ "ajmwagar/vim-deus" },
	{ "rebelot/kanagawa.nvim" },
	{ "savq/melange" },
	-- { "haystackandroid/wonka" },
	{ "briones-gabriel/darcula-solid.nvim", dependencies = "rktjmp/lush.nvim" },
	-- { "doums/darcula" },
	{
		"phha/zenburn.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd [[colorscheme zenburn]]
		end
	},
	{ "mellow-theme/mellow.nvim" },
	{
		"EdenEast/nightfox.nvim",
	},
	{
		"famiu/feline.nvim",
		config = function()
			require("config.feline")
		end,
	},
	"folke/lsp-colors.nvim",

	{
		"theprimeagen/refactoring.nvim",
		config = function()
			require("config.refactoring")
		end,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" }
		}
	},

	-- https://github.com/mkitt/tabline.vim/blob/master/plugin/tabline.vim

	-- Make |v_b_I| and |v_b_A| available in all kinds of Visual mode
	{
		"kana/vim-niceblock",
		config = function()
			xmap("I", "<Plug>(niceblock-I)")
			xmap("gI", "<Plug>(niceblock-gI)")
			xmap("A", "<Plug>(niceblock-A)")
		end,
	},

	-- Textobjects
	{
		"kana/vim-textobj-user",
		dependencies = {
			"kana/vim-textobj-indent",
			"kana/vim-textobj-line",
			{
				"kana/vim-textobj-entire",
				init = function()
					vim.g.textobj_entire_no_default_key_mappings = 1
				end,
				config = function()
					vim.cmd [[
					call textobj#user#map("entire", {
						\   "-": {
							\     "select-a": "aE",
							\     "select-i": "iE",
							\   }
							\ })
							]]
				end
			},
			-- or thinca/vim-textobj-comment
			"glts/vim-textobj-comment",
			{
				"tkhren/vim-textobj-numeral",
				init = function()
					vim.g.textobj_numeral_no_default_key_mappings = 1
				end,
				config = function()
					vmap("an", "<Plug>(textobj-numeral-float-a)")
					omap("an", "<Plug>(textobj-numeral-float-a)")
					vmap("in", "<Plug>(textobj-numeral-float-i)")
					omap("in", "<Plug>(textobj-numeral-float-i)")
				end
			},
		},
	},

	{
		"wellle/targets.vim",
		config = function()
			vim.g.targets_jumpRanges =
			"cc cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb al rB Al bb aa bB Aa BB AA"
		end,
	},

	{
		"phaazon/hop.nvim",
		branch = "v2",
		config = function()
			require("config.hop")
		end
	},

	-- Make WORD motions support camelCase & friends
	{
		"chaoren/vim-wordmotion",
		init = function()
			vim.g.wordmotion_prefix = ","
		end
	},

	"tpope/vim-repeat",

	-- replace with treesitter-textobjects once I start playing with TS queries
	{
		"PeterRincker/vim-argumentative",
		config = function()
			require("config.argumentative")
		end,
		init = function()
			vim.g.argumentative_no_mappings = 1
		end
	},

	{
		"FooSoft/vim-argwrap", --cmd = "ArgWrap",
		init = function()
			vim.g.argwrap_tail_comma = 1
			vim.g.argwrap_padded_braces = 1
		end,
		config = function()
			nnoremap("<leader>aw", "<silent>", "<cmd>ArgWrap<CR>")
		end
	},

	{
		"AndrewRadev/switch.vim",
		config = function()
			require("config.switch")
		end,
	},

	-- {
	-- 	'ckolkey/ts-node-action',
	-- 	dependencies = { 'nvim-treesitter' },
	-- 	-- opts = {},
	-- 	config = function()
	-- 		require("ts-node-action")
	-- 		nnoremap("gs", "<cmd>NodeAction<CR>")
	-- 	end
	-- },

	{
		"numToStr/Comment.nvim",
		config = function()
			require("config.comment")
		end,
		dependencies = {
			-- syntax-aware commentstring (via treesitter)
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				config = function()
					vim.g.skip_ts_context_commentstring_module = true
					require("ts_context_commentstring").setup({
						enable_autocmd = false,
					})
				end,
			}
		},
	},

	-- set up path variable for different filetypes
	"tpope/vim-apathy",

	{
		"nvim-telescope/telescope.nvim",
		config = function()
			require("config.telescope")
		end,
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"smartpde/telescope-recent-files",
		}
	},

	-- TODO: open issue for adjusting visual selection (gv) after surrounding
	{
		"machakann/vim-sandwich",
		init = function()
			vim.g.sandwich_no_default_key_mappings = 1
			vim.g.operator_sandwich_no_default_key_mappings = 1
			vim.g.textobj_sandwich_no_default_key_mappings = 1
			vim.g.sandwich_no_tex_ftplugin = 1
		end,
		config = function()
			require("config.sandwich")
		end,
	},
	-- use "tpope/vim-surround"

	{
		"Wansmer/treesj",
		keys = { "gS" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
				max_join_length = 200,
			})

			nmap("gS", "<cmd>TSJToggle<CR>")
		end,
	},

	-- Better Git conflicts resolution
	"whiteinge/diffconflicts",

	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim"
		},
		config = function()
			require("config.gitsigns")
		end,
	},

	-- cd to file/project
	{
		"dbakker/vim-projectroot",
		config = function()
			nnoremap("<Leader>cd", "<silent>", "<cmd>lcd %:h<CR>")
			nnoremap("<Leader>cp", "<silent>", "<cmd>ProjectRootLCD<CR>")
		end,
	},

	{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
		branch = "harpoon2",
		config = function()
			require("config.harpoon2")
		end,
	},

	{
		"pockata/harpoon-highlight-current-file",
		dependencies = { "ThePrimeagen/harpoon" },
		config = function()
			require("harpoon-highlight-current-file").setup()
		end,
	},

	{
		"pockata/harpoon-mark-git-branch",
		dependencies = { "ThePrimeagen/harpoon" },
		config = function()
			require("harpoon-mark-git-branch").setup()
		end,
	},

	-- Quickfix
	{
		"yssl/QFEnter",
		config = function()
			-- http://vi.stackexchange.com/questions/8534/make-cnext-and-cprevious-loop-back-to-the-begining
			vim.g.qfenter_keymap = {
				open = { '<CR>', '<2-LeftMouse>' },
				vopen = { '<C-v>' },
				hopen = { '<C-s>' },
				topen = { '<C-t>' }
			}
		end,
	},

	-- Git
	{
		"tpope/vim-fugitive",
		config = function()
			require("config.fugitive")
		end,
		dependencies = {
			-- Make Gbrowse open Github & Gitlab urls
			"tpope/vim-rhubarb",
		},
	},

	{
		"junegunn/gv.vim",
		cmd = "GV",
		init = function()
			nnoremap("<leader>gv", "<cmd>GV<CR>")
		end,
		config = function()
			require("config.gv")
		end,
	},

	"rhysd/conflict-marker.vim",

	"junegunn/vim-slash",

	-- -- use "itchyny/vim-cursorword"
	-- use { "RRethy/vim-illuminate", config = function()
	-- require("config.illuminate")
	-- end}

	-- use "kana/vim-smartword"

	{
		"talek/obvious-resize",
		config = function()
			require("config.obvious-resize")
		end,
	},

	-- improve the "{" and "}" motion in normal / visual mode
	"justinmk/vim-ipmotion",

	-- extra language support
	-- Check out https://github.com/ray-x/go.nvim
	{
		"fatih/vim-go",
		ft = "go",
		config = function()
			-- disable vim-go :GoDef short cut (gd)
			-- this is handled by LanguageClient [LC]
			vim.g.go_def_mapping_enabled = 0
			vim.g.go_doc_keywordprg_enabled = 0
		end,
	},
	{
		"tbastos/vim-lua",
		ft = "lua",
	},
	{
		"pantharshit00/vim-prisma",
		ft = "prisma",
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	-- TODO: Replace with https://github.com/pmizio/typescript-tools.nvim
	{
		"jose-elias-alvarez/typescript.nvim",
	},

	-- better TS errors
	{
		"davidosomething/format-ts-errors.nvim",
	},
	{
		"dmmulroy/tsc.nvim",
		cmd = { "TSC" },
		config = function()
			require("tsc").setup({
				flags = {
					maxNodeModuleJsDepth = "0",
					project = function()
						local files = { "jsconfig.json", "tsconfig.json" }
						local paths = { ".", "packages/ui" }
						for i = 0, #paths do
							local path = paths[i]
							for k = 0, #files do
								local file = files[k]
								local conf = vim.fn.findfile(file, path)

								if conf ~= "" then
									return conf
								end
							end
						end

						return nil
					end
				}
			})
		end,
	},

	{ "evanleck/vim-svelte" },
	{
		"wuelnerdotexe/vim-astro",
		config = function()
			vim.g.astro_typescript = "enable"
		end
	},

	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		init = function()
			nnoremap("<Leader>u", "<silent>", "<cmd>UndotreeToggle<CR>")
		end,
		config = function()
			-- If undotree is opened, it is likely one wants to interact with it.
			vim.g.undotree_SetFocusWhenToggle = 1
			vim.g.undotree_WindowLayout = 2
		end
	},

	{
		"wesQ3/vim-windowswap",
		init = function()
			vim.g.windowswap_map_keys = 0
		end,
		config = function()
			nnoremap('<C-W><C-W>', '<silent>', "<cmd>call WindowSwap#EasyWindowSwap()<CR>")
		end,
	},

	-- -- Post-install/update hook with call of vimscript function with argument
	-- use { "glacambre/firenvim", build = function() vim.fn["firenvim#install"](0) end }

	{
		"NMAC427/guess-indent.nvim",
		config = function() require("guess-indent").setup({}) end,
	},

	{
		"danymat/neogen",
		config = function() require("config.neogen") end,
		dependencies = "L3MON4D3/LuaSnip",
	},

	-- use "pechorin/any-jump.vim" -- Document outline
}, opts)

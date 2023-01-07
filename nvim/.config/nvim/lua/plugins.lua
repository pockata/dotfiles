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
			"nvim-treesitter/nvim-treesitter-textobjects"
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
		event = { "InsertEnter", --[[ "CmdlineEnter" ]] },
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
			"andersevenrud/compe-tmux",

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

	-- vim.api.nvim_set_keymap(
	-- 	"i",
	-- 	"<C-x><C-d>",
	-- 	[[<c-r>=luaeval("require("complextras").complete_line_from_cwd()")<CR>]],
	-- 	{ noremap = true }
	-- )
	-- vim.api.nvim_set_keymap(
	-- 	"i",
	-- 	"<C-x><C-m>",
	-- 	[[<c-r>=luaeval("require("complextras").complete_matching_line()")<CR>]],
	-- 	{ noremap = true }
	-- )
	-- use {
	-- 	"tjdevries/complextras.nvim",
	-- 	dependencies ={
	-- 		{ "nvim-lua/plenary.nvim" },
	-- 	}
	-- }

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
			{
				"williamboman/mason-lspconfig.nvim",
				config = function()
					require("mason-lspconfig").setup({
						ensure_installed = {
							"gopls",
							"tsserver",
							"sumneko_lua",
							-- "cssls",
							"cssmodules_ls",
							"jsonls",
							"yamlls",
						}
					})
				end,
			},
			"nvim-lspconfig",
		},
	},

	{
		"andymass/vim-matchup",
		setup = function()
			vim.g.matchup_matchparen_offscreen = {}
		end,
	},

	{
		"justinmk/vim-dirvish",
		config = function()
			require("config.dirvish")
		end,
		dependencies = {
			"kristijanhusak/vim-dirvish-git",
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
		"challenger-deep-theme/vim",
		name = "challenger-deep",
		config = function()
			require("config.challenger-deep")
		end,
	},
	{
		"morhetz/gruvbox",
		config = function()
			require("config.gruvbox")
		end,
	},
	{
		"ajmwagar/vim-deus",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd [[colorscheme deus]]
		end
	},
	{ "folke/tokyonight.nvim" }, -- remove colors/tokyonight
	{ "matsuuu/pinkmare" },
	{ "rebelot/kanagawa.nvim" },
	{ "savq/melange" },
	-- { "haystackandroid/wonka" },
	{ "rose-pine/neovim", name = "rose-pine" },
	{ "briones-gabriel/darcula-solid.nvim", dependencies = "rktjmp/lush.nvim" },
	{ "doums/darcula" },
	{ "EdenEast/nightfox.nvim" },
	{
		"famiu/feline.nvim",
		config = function()
			require("config.feline")
		end,
	},
	"folke/lsp-colors.nvim",

	-- use {
	-- 	"theprimeagen/refactoring.nvim",
	-- 	config = function()
	-- 	require("config.refactoring")
	-- 	end,
	-- 	dependencies ={
	-- 		{ "nvim-lua/plenary.nvim" },
	-- 		{ "nvim-treesitter/nvim-treesitter" }
	-- 	}
	-- }

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

	"wellle/targets.vim",

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

	{
		"numToStr/Comment.nvim",
		config = function()
			require("config.comment")
		end,
		dependencies = {
			-- syntax-aware commentstring (via treesitter)
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},

	-- set up path variable for different filetypes
	"tpope/vim-apathy",

	{
		"nvim-telescope/telescope.nvim", config = function()
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
		config = function()
			require("config.sandwich")
		end,
	},
	-- use "tpope/vim-surround"

	-- TODO: Configure
	"AndrewRadev/splitjoin.vim",

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
		config = function()
			require("config.harpoon")
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
		build = "cd app && yarn install",
		cmd = "MarkdownPreview",
	},

	{
		"jose-elias-alvarez/typescript.nvim",
	},
	-- use "evanleck/vim-svelte"

	{
		"mbbill/undotree", cmd = "UndotreeToggle",
		config = function()
			-- If undotree is opened, it is likely one wants to interact with it.
			vim.g.undotree_SetFocusWhenToggle = 1
			vim.g.undotree_WindowLayout = 2

			nnoremap("<Leader>u", "<silent>", "<cmd>UndotreeToggle<CR>")
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
		config = function() require("neogen").setup({
				-- use luasnip for expansion
				snippet_engine = "luasnip",
			})
		end,
		dependencies = "L3MON4D3/LuaSnip",
	},

	-- use "pechorin/any-jump.vim" -- Document outline
})

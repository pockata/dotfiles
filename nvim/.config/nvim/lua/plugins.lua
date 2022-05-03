-- Only required if you have packer in your `opt` pack
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

vim.cmd [[cabbrev ps PackerSync]]
vim.cmd [[cabbrev pc PackerCompile]]
vim.cmd [[cabbrev pi PackerInstall]]

if not packer_exists then
	-- TODO: Maybe handle windows better?
	if vim.fn.input("Download Packer? (y for yes): ") ~= "y" then
		return
	end

	local directory = string.format(
		'%s/site/pack/packer/opt/',
		vim.fn.stdpath('data')
	)

	vim.fn.mkdir(directory, 'p')

	local out = vim.fn.system(string.format(
		'git clone --depth 1 %s %s',
		'https://github.com/wbthomason/packer.nvim',
		directory .. '/packer.nvim'
	))

	print(out)
	print("Downloading packer.nvim...")

	-- Compile the updates
	-- vim.cmd(":PackerSync")
	require('packer').sync()

	return
end

return require('packer').startup({function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- filedetect drop-in-placement
	use 'nathom/filetype.nvim'

	-- TODO: Test lua rewrite - numToStr/Navigator.nvim
	-- TODO: Test lua rewrite - nathom/tmux.nvim
	use {
		'christoomey/vim-tmux-navigator',
		config = [[require('config.tmux-navigator')]]
	}

	-- Alternative: https://github.com/jpalardy/vim-slime
	use {
		'christoomey/vim-tmux-runner', config = function ()
			nnoremap("<leader>v-", ':VtrOpenRunner { "orientation": "v", "percentage": 30 }<cr>');
		end
	}

	use {
		'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
		requires = {
			-- for debugging treesitter queries (for textobjects)
			'nvim-treesitter/playground',
			--
			-- TODO: Define a key/value textobject
			'nvim-treesitter/nvim-treesitter-textobjects'
			-- Check it out
			-- 'mfussenegger/nvim-ts-hint-textobject'
		},
		config = [[require('config.treesitter')]]
	}

	-- preview hex colors
	use {
		'rrethy/vim-hexokinase',
		run = 'make hexokinase',
		cmd = 'HexokinaseToggle',
		config = [[vim.g.Hexokinase_highlighters = {'virtual'}]],
	}

	-- Autocomplete & Linters
	use { 'neovim/nvim-lspconfig',
		config = [[require('config.lspconfig')]],
	}

	-- -- Better LSP diagnostics display
	-- use {
	-- 	"folke/lsp-trouble.nvim",
	-- 	requires = "kyazdani42/nvim-web-devicons",
	-- 	config = [[require('config.lsp-trouble')]]
	-- }

	-- use { 'kosayoda/nvim-lightbulb', config = [[require('config.lightbulb')]] }

	-- snippets
	use "rafamadriz/friendly-snippets"
	use 'hrsh7th/cmp-vsnip'
	use { 'hrsh7th/vim-vsnip', config = [[require('config.vsnip')]] }
	use 'xabikos/vscode-javascript'
	-- TODO: Check this one out if it's not superceded by LSP
	-- use { 'xianghongai/vscode-javascript-comment',
	-- 	config = function()
	-- 		-- os.execute(
	-- 		-- 	string.format(
	-- 		-- 		'cd %s/site/pack/packer/start/vscode-javascript-comment/ && npm install && node ./merge.js',
	-- 		-- 		vim.fn.stdpath('data')
	-- 		-- 	)
	-- 		-- )
	-- 	end
	-- }

	-- automatch quotes and brackets
	use {
		'windwp/nvim-autopairs',
		config = [[require('config.autopairs')]]
	}

	use { 'hrsh7th/nvim-cmp', config = [[require('config.cmp')]] }
	use 'onsails/lspkind-nvim' -- for icons/types in inscompletion
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use { 'andersevenrud/compe-tmux' }
	-- use 'petertriho/cmp-git'

	-- Plenary.nvim doesn't seem to work ¯\_(ツ)_/¯
	vim.api.nvim_set_keymap(
		"i",
		"<C-x><C-d>",
		[[<c-r>=luaeval("require('complextras').complete_line_from_cwd()")<CR>]],
		{ noremap = true }
	)
	vim.api.nvim_set_keymap(
		"i",
		"<C-x><C-m>",
		[[<c-r>=luaeval("require('complextras').complete_matching_line()")<CR>]],
		{ noremap = true }
	)
	use { 'tjdevries/complextras.nvim' }

	use { 'ray-x/lsp_signature.nvim' }
	-- use 'hrsh7th/cmp-nvim-lsp-signature-help'

	use { "folke/todo-comments.nvim", config = [[require('config.todo')]] }
	use { "folke/zen-mode.nvim", config = [[require('config.zen-mode')]] }

	-- use 'famiu/bufdelete.nvim'

	use {
		'williamboman/nvim-lsp-installer',
		after = 'nvim-lspconfig',
		config = [[require('config.lsp')]],
	}

	vim.cmd[[  nmap <silent> <F7> <plug>(matchup-hi-surround) ]]
	use { "andymass/vim-matchup" }

	-- use {
	-- 	'kyazdani42/nvim-tree.lua',
	-- 	config = [[require('config.tree')]]
	-- }

	use { 'justinmk/vim-dirvish', config = [[require('config.dirvish')]] }
	use 'kristijanhusak/vim-dirvish-git'

	use 'roginfarrer/vim-dirvish-dovish'
	use 'bounceme/remote-viewer'

	-- Respect .editorconfig files
	use { 'editorconfig/editorconfig-vim',
		config = function()
			vim.g.EditorConfig_exclude_patterns = {'fugitive://.*'}
			create_augroup(
				'DisableEditorConfig',
				'FileType gitcommit let b:EditorConfig_disable = 1'
			)
		end
	}

	-- Theming
	use { 'challenger-deep-theme/vim', as = 'challenger-deep',
		config = [[require('config.challenger-deep')]]
	}
	use { 'morhetz/gruvbox', config = [[require('config.gruvbox')]] }
	use { 'ajmwagar/vim-deus' }
	use { 'folke/tokyonight.nvim' } -- remove colors/tokyonight
	use { 'matsuuu/pinkmare' }
	use {
		'marko-cerovac/material.nvim',
		config = [[require('config.theme-material')]]
	}
	use { 'rktjmp/lush.nvim' }
	use { 'CodeGradox/onehalf-lush' }
	use { 'rakr/vim-one' }
	use { "rebelot/kanagawa.nvim" }
	use { 'mhartington/oceanic-next' }
	use { 'savq/melange' }
	use { 'haystackandroid/wonka' }
	use {
		'famiu/feline.nvim',
		requires = {'kyazdani42/nvim-web-devicons'},
		config = [[require('config.feline')]],
	}
	use 'folke/lsp-colors.nvim'

	use {
		"~/Projects/refactoring.nvim",
		config = [[require('config.refactoring')]],
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" }
		}
	}
	-- https://github.com/mkitt/tabline.vim/blob/master/plugin/tabline.vim

	use 'antoinemadec/FixCursorHold.nvim' -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open

	-- Make |v_b_I| and |v_b_A| available in all kinds of Visual mode
	use { 'kana/vim-niceblock', config = [[require('config.niceblock')]] }

	-- Textobjects
	use 'kana/vim-textobj-user'
	use 'kana/vim-textobj-indent'
	use 'kana/vim-textobj-line'

	vim.g.textobj_entire_no_default_key_mappings = 1
	use {
		'kana/vim-textobj-entire',
		config = function()
			vim.cmd [[
				call textobj#user#map('entire', {
				\   '-': {
				\     'select-a': 'aE',
				\     'select-i': 'iE',
				\   }
				\ })
			]]
		end
	}

	use 'inside/vim-textobj-jsxattr'
	-- use 'whatyouhide/vim-textobj-xmlattr'
	use 'wellle/targets.vim'

	-- or thinca/vim-textobj-comment
	use 'glts/vim-textobj-comment'

	vim.g.textobj_numeral_no_default_key_mappings = 1
	use {
		'tkhren/vim-textobj-numeral',
		config = function ()
			vmap("an", "<Plug>(textobj-numeral-float-a)")
			omap("an", "<Plug>(textobj-numeral-float-a)")
			vmap("in", "<Plug>(textobj-numeral-float-i)")
			omap("in", "<Plug>(textobj-numeral-float-i)")
		end
	}

	use { 'phaazon/hop.nvim', config = [[require('config.hop')]] }

	-- Make WORD motions support camelCase & friends
	vim.g.wordmotion_prefix = ','
	use { 'chaoren/vim-wordmotion' }

	use 'tpope/vim-repeat'

	-- replace with treesitter-textobjects once I start playing with TS queries
	vim.g.argumentative_no_mappings = 1
	use {
		'PeterRincker/vim-argumentative',
		config = [[require('config.argumentative')]]
	}

	use { 'FooSoft/vim-argwrap',  --cmd = 'ArgWrap',
		config = function()
			nnoremap("<leader>aw", "<silent>", "<cmd>ArgWrap<CR>")
		end
	}

	use { 'AndrewRadev/switch.vim', config = [[require('config.switch')]] }

	use { 'numToStr/Comment.nvim', config = [[require('config.comment')]] }
	-- syntax-aware commentstring (via treesitter)
	use 'JoosepAlviste/nvim-ts-context-commentstring'

	-- set up path variable for different filetypes
	use 'tpope/vim-apathy'

	use {
		'nvim-telescope/telescope.nvim', config = [[require('config.telescope')]],
		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
	}
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

	use {
		'romainl/vim-devdocs',
		config = function ()
			nmap("<localleader>k", "<cmd>DD<CR>")
		end
	}

	-- TODO: open issue for adjusting visual selection (gv) after surrounding
	use { 'machakann/vim-sandwich', config = [[require('config.sandwich')]] }
	-- use 'tpope/vim-surround'

	-- TODO: Configure
	use 'AndrewRadev/splitjoin.vim'

	-- Better Git conflicts resolution
	use 'whiteinge/diffconflicts'

	use {
		'lewis6991/gitsigns.nvim',
		requires = {
			'nvim-lua/plenary.nvim'
		},
		config = [[require('config.gitsigns')]],
		after = 'gruvbox'
	}

	-- cd to file/project
	use { 'dbakker/vim-projectroot', config = [[require('config.projectroot')]] }

	use {
		'ThePrimeagen/harpoon',
		requires = {'nvim-lua/plenary.nvim'},
		config = [[require('config.harpoon')]],
	}

	-- Quickfix
	use { 'yssl/QFEnter', config = [[require('config.qfenter')]] }

	-- -- Make Gbrowse open Github & Gitlab urls
	use 'tpope/vim-rhubarb'
	use 'shumphrey/fugitive-gitlab.vim'
	-- Git
	use { 'tpope/vim-fugitive', config = [[require('config.fugitive')]] }

	use { 'junegunn/gv.vim', cmd = 'GV', config = [[require('config.gv')]] }
	nnoremap('<leader>gv', '<cmd>GV<CR>')

	use 'rhysd/conflict-marker.vim'

	use 'junegunn/vim-slash'

	-- use 'itchyny/vim-cursorword'
	use { 'RRethy/vim-illuminate', config = [[require('config.illuminate')]]}

	-- use 'kana/vim-smartword'

	use { 'talek/obvious-resize', config = [[require('config.obvious-resize')]] }

	-- improve the "{" and "}" motion in normal / visual mode
	use 'justinmk/vim-ipmotion'

	-- extra language support
	-- Check out https://github.com/ray-x/go.nvim
	use { 'fatih/vim-go', config = [[require('config.go')]] }
	use 'tbastos/vim-lua'
	use 'pantharshit00/vim-prisma'
	use {
		'iamcco/markdown-preview.nvim', run = 'cd app && yarn install',
		cmd = 'MarkdownPreview'
	}
	-- use 'evanleck/vim-svelte'

	use {
		'mbbill/undotree', cmd = 'UndotreeToggle',
		config = [[require('config.undotree')]]
	}
	nnoremap("<Leader>u", '<silent>', "<cmd>UndotreeToggle<CR>")


	use { 'wesQ3/vim-windowswap', config = [[require('config.windowswap')]] }

	-- -- Post-install/update hook with call of vimscript function with argument
	-- use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

	use 'ciaranm/detectindent'
	-- use 'pechorin/any-jump.vim' -- Document outline
end, config = {
	display = {
		keybindings = {
			diff = 'o',
		}
	}
}})


-- Only required if you have packer in your `opt` pack
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

vim.cmd [[cabbrev ps PackerSync]]

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
		'git clone %s %s',
		'https://github.com/wbthomason/packer.nvim',
		directory .. '/packer.nvim'
	))

	print(out)
	print("Downloading packer.nvim...")

	-- Compile the updates
	-- vim.cmd(":PackerSync")

	return
end

return require('packer').startup({function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- TODO: Test lua rewrite - numToStr/Navigator.nvim
	use {
		'christoomey/vim-tmux-navigator',
		config = [[require('config.tmux-navigator')]]
	}

	-- -- Plugins can have dependencies on other plugins
	-- use {
	--     'haorenW1025/completion-nvim',
	--     opt = true,
	--     requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
	-- }

	use {
		'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
		requires = {
			-- for debugging treesitter queries (for textobjects)
			'nvim-treesitter/playground',
			--
			-- TODO: Define a key/value textobject
			'nvim-treesitter/nvim-treesitter-textobjects'
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

	-- Better LSP diagnostics display
	use {
		"folke/lsp-trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = [[require('config.lsp-trouble')]]
	}

	use { 'kosayoda/nvim-lightbulb', config = [[require('config.lightbulb')]] }

	-- snippets
	use "rafamadriz/friendly-snippets"
	use { 'hrsh7th/vim-vsnip', config = [[require('config.vsnip')]] }
	use 'hrsh7th/vim-vsnip-integ'

	-- automatch quotes and brackets
	use 'Raimondi/delimitMate'
	use {
		'hrsh7th/nvim-compe', config = [[require('config.compe')]]
	}
	use { 'wellle/tmux-complete.vim' }
	-- use { 'andersevenrud/compe-tmux' }
	-- use 'jiangmiao/auto-pairs'
	-- use 'windwp/nvim-autopairs'

	use { "folke/todo-comments.nvim", config = [[require('config.todo')]] }

	use { 'kabouzeid/nvim-lspinstall',
		config = [[require('config.lspinstall')]],
		after = 'nvim-lspconfig'
	}

	use { "andymass/vim-matchup" }

	-- use {
	-- 	'kyazdani42/nvim-tree.lua',
	-- 	config = [[require('config.tree')]]
	-- }

	use { 'justinmk/vim-dirvish', config = [[require('config.dirvish')]] }

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
	use { 'challenger-deep-theme/vim', as = 'challenger-deep' }
	use { 'morhetz/gruvbox', config = [[require('config.gruvbox')]] }
	use { 'ajmwagar/vim-deus' }
	use { 'folke/tokyonight.nvim' }
	use {
		'famiu/feline.nvim',
		requires = {'kyazdani42/nvim-web-devicons'},
		config = [[require('config.feline')]],
	}

	use 'antoinemadec/FixCursorHold.nvim' -- Fix CursorHold Performance

	-- Make |v_b_I| and |v_b_A| available in all kinds of Visual mode
	use { 'kana/vim-niceblock', config = [[require('config.niceblock')]] }

	-- Textobjects
	use 'kana/vim-textobj-user'
	use 'kana/vim-textobj-indent'
	use 'kana/vim-textobj-line'
	use 'kana/vim-textobj-entire'
	use 'inside/vim-textobj-jsxattr'
	-- use 'whatyouhide/vim-textobj-xmlattr'
	use 'wellle/targets.vim'

	use { 'phaazon/hop.nvim', config = [[require('config.hop')]] }

	-- Make WORD motions support camelCase & friends
	vim.g.wordmotion_prefix = ','
	use { 'chaoren/vim-wordmotion' }

	use 'tpope/vim-repeat'

	use { 'FooSoft/vim-argwrap',  --cmd = 'ArgWrap',
		config = function()
			nnoremap("<leader>aw", "<silent>", "<cmd>ArgWrap<CR>")
		end
	}

	use { 'AndrewRadev/switch.vim',
		config = function()
			create_augroup(
				'gitrebase',
				"FileType gitrebase let b:switch_custom_definitions = [[ 'pick', 'reword', 'edit', 'squash', 'fixup', 'exec' ]]"
			)
		end
	}

	use { 'b3nj5m1n/kommentary', config = [[require('config.kommentary')]] }
	-- set up path variable for different filetypes
	use 'tpope/vim-apathy'

	use {
		'nvim-telescope/telescope.nvim', config = [[require('config.telescope')]],
		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
	}
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }


	-- TODO: open issue for adjusting visual selection (gv) after surrounding
	use { 'machakann/vim-sandwich', config = [[require('config.sandwich')]] }
	-- use 'tpope/vim-surround'

	-- TODO: Configure
	-- use 'AndrewRadev/splitjoin.vim'

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

	-- Quickfix
	use { 'yssl/QFEnter', config = [[require('config.qfenter')]] }

	-- -- Make Gbrowse open Github & Gitlab urls
	use 'tpope/vim-rhubarb'
	use 'shumphrey/fugitive-gitlab.vim'
	-- Git
	use { 'tpope/vim-fugitive', config = [[require('config.fugitive')]] }

	use { 'junegunn/gv.vim', cmd = 'GV', config = [[require('config.gv')]] }
	nnoremap('<leader>gv', '<cmd>GV<CR>')
	-- use 'rhysd/conflict-marker.vim'

	use 'junegunn/vim-slash'

	-- use 'itchyny/vim-cursorword'
	use { 'RRethy/vim-illuminate', config = [[require('config.illuminate')]]}

	-- use 'kana/vim-smartword'

	use { 'talek/obvious-resize', config = [[require('config.obvious-resize')]] }

	-- improve the "{" and "}" motion in normal / visual mode
	use 'justinmk/vim-ipmotion'

	use {
		'kkoomen/vim-doge', config = [[require('config.doge')]],
		run = function() vim.fn['doge#install']() end,
		cmd = { 'DogeGenerate', 'DogeCreateDocStandard' }
	}

	-- extra language support
	use { 'fatih/vim-go', config = [[require('config.go')]] }
	use 'tbastos/vim-lua'
	-- use 'evanleck/vim-svelte'

	use {
		'mbbill/undotree', cmd = 'UndotreeToggle',
		config = [[require('config.undotree')]]
	}
	nnoremap("<Leader>u", '<silent>', "<cmd>UndotreeToggle<CR>")


	use { 'wesQ3/vim-windowswap', config = [[require('config.windowswap')]] }

	-- -- Post-install/update hook with call of vimscript function with argument
	-- use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

	-- use 'pechorin/any-jump.vim' -- Document outline
end, config = {
	display = {
		keybindings = {
			diff = 'o',
		}
	}
}})


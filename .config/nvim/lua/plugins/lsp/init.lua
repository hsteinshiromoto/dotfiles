-- lsp/init.lua

return {
	{
		"williamboman/mason.nvim",
		priority = 100, -- Ensure Mason loads first
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		ensure_installed = {
			"bash-debug-adapter",
			"bash-language-server",
			"bibtex-tidy",
			"black",
			"blackd-client",
			"debugpy",
			"docformatter",
			"dockerfile-language-server",
			"isort",
			"json-lsp",
			"luacheck",
			"luaformatter",
			"mypy",
			"pydocstyle",
			"pyright",
			-- "ruff",
			"stylua",
			-- "texlab",
			"yaml-language-server",
		},
		config = function(plugin)
			require("mason").setup()
			local mr = require("mason-registry")
			for _, tool in ipairs(plugin.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		priority = 90, -- Load right after Mason
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			-- Initialize mason-lspconfig with a basic setup
			require("mason-lspconfig").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			"williamboman/mason.nvim", -- Make sure this loads first
			"williamboman/mason-lspconfig.nvim", -- Then this
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			{ "folke/neodev.nvim", config = true },
			{ "j-hui/fidget.nvim", config = true },
			{ "smjonas/inc-rename.nvim", config = true },
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		opts = {
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = { callSnippet = "Replace" },
							telemetry = { enable = false },
							hint = {
								enable = false,
							},
						},
					},
				},
				dockerls = {},
			},
			setup = {},
		},
		config = function(plugin, opts)
			require("plugins.lsp.servers").setup(plugin, opts)
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		event = "BufReadPre",
		dependencies = { "mason.nvim" },
		config = function()
			local nls = require("null-ls")
			nls.setup({
				sources = {
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.black,
					nls.builtins.diagnostics.mypy,
					-- nls.builtins.diagnostics.ruff,
				},
			})
		end,
	},
	{
		"utilyre/barbecue.nvim",
		event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		config = true,
	},
}

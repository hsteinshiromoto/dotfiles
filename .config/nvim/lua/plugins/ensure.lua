return {
	"noirbizarre/ensure.nvim",
	dependencies = {
		"mason-org/mason.nvim", -- Required for tool installation
		-- Optional integrations:
		"nvim-treesitter/nvim-treesitter",
		"stevearc/conform.nvim",
		"mfussenegger/nvim-lint",
	},
	lazy = false,
	opts = {
		lsp = { enable = { "lua_ls", "pyright" } },
		formatters = { lua = "stylua", python = { "ruff_format", "ruff_organize_imports" } },
		-- bandit only. The ruff *language server* (lua/core/lsp.lua) already
		-- publishes ruff's findings, so listing ruff here too would report
		-- every violation twice.
		linters = { python = { "bandit" } },
		-- Tree-sitter parsers (array format for specific parsers)
		parsers = { "lua", "make", "nix", "python", "typescript" },
	},
}

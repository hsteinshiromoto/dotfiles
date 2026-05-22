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
		linters = { python = "ruff", },
		-- Tree-sitter parsers (array format for specific parsers)
		parsers = { "lua", "make", "nix", "python", "typescript" },
	},
}

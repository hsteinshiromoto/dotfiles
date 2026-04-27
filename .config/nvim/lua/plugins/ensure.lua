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
		lsp = { auto = true },
		formatters = { auto = true },
		linters = { auto = true },
		-- Tree-sitter parsers (array format for specific parsers)
		parsers = { "lua", "make", "nix", "python", "typescript" },
	},
}

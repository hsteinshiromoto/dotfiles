return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"folke/neodev.nvim",
		},
	},
	{
		"folke/neodev.nvim",
		opts = {},
	},
}

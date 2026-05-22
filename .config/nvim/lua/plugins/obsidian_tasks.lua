return {
	"snapwich/obsidian-tasks.nvim",
	dependencies = {
		"obsidian-nvim/obsidian.nvim",
		"saghen/blink.cmp",
		"saghen/blink.lib",
	},
	lazy = true,
	ft = "markdown",
	cond = vim.fn.isdirectory(".obsidian") == 1,
	config = function()
		require("obsidian-tasks").setup({})
	end,
}

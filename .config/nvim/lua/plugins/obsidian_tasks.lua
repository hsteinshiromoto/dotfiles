return {
	"snapwich/obsidian-tasks.nvim",
	dependencies = {
		"obsidian-nvim/obsidian.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		require("obsidian-tasks").setup({})
	end,
}

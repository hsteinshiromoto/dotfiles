return {
	"harrisoncramer/gitlab.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
		"nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
	},
	lazy = false,
	-- build = function()
	-- 	require("gitlab.server").build(true)
	-- end, -- Builds the Go binary - disabled due to missing Go dependency
	config = function()
		-- Only setup if Go is available, otherwise the plugin will try to build
		if vim.fn.executable("go") == 1 then
			require("gitlab").setup({})
		else
			vim.notify("gitlab.nvim: Go not found, plugin disabled", vim.log.levels.WARN)
		end
	end,
}

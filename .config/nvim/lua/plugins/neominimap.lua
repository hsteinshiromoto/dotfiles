return {
	"Isrothy/neominimap.nvim",
	version = "v3.x.x",
	lazy = false,
	init = function()
		-- Off by default: the minimap assumes one buffer line per screen line,
		-- and wrap stays on in this config.
		vim.g.neominimap = { auto_enable = false }
		vim.keymap.set("n", "<leader>um", "<cmd>Neominimap Toggle<cr>", { desc = "Toggle minimap" })
	end,
}

return {
	"Isrothy/neominimap.nvim",
	version = "v3.x.x",
	lazy = false,
	init = function()
		-- wrap stays on in this config, so cursor sync drifts in wrapped buffers.
		vim.g.neominimap = { auto_enable = true }
		vim.keymap.set("n", "<leader>um", "<cmd>Neominimap Toggle<cr>", { desc = "Toggle minimap" })
	end,
}

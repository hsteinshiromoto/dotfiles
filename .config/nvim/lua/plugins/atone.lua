return {
	"XXiaoA/atone.nvim",
	lazy = false,
	cmd = "Atone",
	vim.keymap.set({ "n", "v" }, "<F9>", ":Atone toggle<CR>", { desc = "Toggle Atone" }),
	opts = {
		direction = "right",
		width = "adaptive"
	}, -- your configuration here
}

return {
	"tjgao/quickbuf.nvim",
	lazy = false,
	config = function()
		require("quickbuf").setup()
	end,
	vim.keymap.set("n", "<leader>bb", "<cmd>QuickBuf<CR>", { desc = "QuickBuf" }),
	vim.keymap.set("n", "<leader>qt", "<cmd>QuickBufPinToggle<CR>", { desc = "Pin toggle" }),
	vim.keymap.set("n", "<S-h>", "<cmd>QuickBufPrevPinned<CR>", { desc = "Prev pinned buffer" }),
	vim.keymap.set("n", "<S-l>", "<cmd>QuickBufNextPinned<CR>", { desc = "Next pinned buffer" })
}

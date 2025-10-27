return {
	'arnamak/stay-centered.nvim',
	lazy = false,
	config = function()
		require("outline").setup({
			vim.keymap.set({ 'n', 'v' }, '<leader>cc', require('stay-centered').toggle, { desc = 'Toggle stay-centered.nvim' })
		})
	end
}

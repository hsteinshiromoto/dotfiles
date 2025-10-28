return {
	'arnamak/stay-centered.nvim',
	lazy = false,
	config = function()
		require("stay-centered").setup({
			skip_filetypes = { 'TelescopePrompt', 'snacks_input', 'snacks_picker', 'snacks_picker_list' },
		})
		vim.keymap.set({ 'n', 'v' }, '<leader>cc', require('stay-centered').toggle, { desc = 'Toggle stay-centered.nvim' })
	end
}

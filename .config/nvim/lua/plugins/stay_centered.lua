return {
	'arnamak/stay-centered.nvim',
	lazy = false,
	config = function()
		require("stay-centered").setup({
			enabled = false,
			skip_filetypes = { 'TelescopePrompt', 'snacks_input', 'snacks_picker', 'snacks_picker_list' },
		})
		vim.keymap.set({ 'n', 'v' }, '<leader>uz', require('stay-centered').toggle,
			{ desc = 'Toggle stay centered.nvim vertical alignment' })
		vim.keymap.set({ 'n', 'v' }, '<leader>{', require('stay-centered').disable,
			{ desc = 'Disable stay-centered.nvim vertical alignment' })
		vim.keymap.set({ 'n', 'v' }, '<leader>}', require('stay-centered').disable,
			{ desc = 'Disable stay-centered.nvim vertical alignment' })
	end
}

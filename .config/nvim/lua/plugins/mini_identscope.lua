return {
	'echasnovski/mini.indentscope',
	version = '*',
	lazy = false,
	config = function()
		require('mini.indentscope').setup({ symbol = '│' })
		vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#2b2f4b' })
		vim.api.nvim_create_autocmd('ColorScheme', {
			callback = function()
				vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#2b2f4b' })
			end,
		})
	end,
}

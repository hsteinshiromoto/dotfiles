return {
	'echasnovski/mini.indentscope',
	version = '*',
	lazy = false,
	config = function()
		require('mini.indentscope').setup({ symbol = '│' })
		vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#678df5' })
		vim.api.nvim_create_autocmd('ColorScheme', {
			callback = function()
				vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#678df5' })
			end,
		})
	end,
}

return {
	'chrscchrn/dictionary.nvim',
	ft = { 'markdown', 'text', 'plaintext' },
	config = function()
		require('dictionary').setup()
	end,
}

return {
	'wsdjeg/rooter.nvim',
	config = function()
		require('rooter').setup({
			root_pattern = { '.git/' },
		})
	end,
}

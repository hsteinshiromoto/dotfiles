return {
	'xemptuous/sqlua.nvim',
	lazy = false,
	cmd = 'SQLua',
	config = function() require('sqlua').setup() end
}

return {
	'tomiis4/Hypersonic.nvim',
	event = "CmdlineEnter",
	cmd = "Hypersonic",
	config = function()
		require('hypersonic').setup({
			-- config
		})
		vim.keymap.set('v', '<leader>h', function()
			local start_pos = vim.fn.getpos("'<")
			local end_pos = vim.fn.getpos("'>")
			local lines = vim.fn.getregion(start_pos, end_pos)
			vim.cmd('Hypersonic ' .. table.concat(lines, ''))
		end, { desc = 'Explain selected regex with Hypersonic' })
	end
}

return {
	"iofq/dart.nvim",
	lazy = false,
	dependencies = {
		"echasnovski/mini.nvim", -- optional, icons provider
		"nvim-tree/nvim-web-devicons", -- optional, icons provider
	},
	require("mini.sessions").setup({
		hooks = {
			pre = {
				read = function(session)
					Dart.read_session(session["name"])
				end,
				write = function(session)
					Dart.write_session(session["name"])
				end,
			},
		},
	}),
	opts = {
		-- List of characters to use to mark 'pinned' buffers
		-- The characters will be chosen for new pins in order
		marklist = { "1", "2", "3", "4", "5" },

		-- List of characters to use to mark recent buffers, which are displayed first (left) in the tabline
		-- Buffers that are 'marked' are not included in this list
		-- The length of this list determines how many recent buffers are tracked
		-- Set to {} to disable recent buffers in the tabline
		buflist = { "6", "7", "8", "9" },
		mappings = {
			mark = "<leader>a", -- Mark current buffer
			jump = "<leader>", -- Jump to buffer marked by next character i.e `;a`
			pick = "<leader>bl", -- Open Dart.pick
			next = "<leader><Right>", -- Cycle right through the tabline
			prev = "<leader><Left>", -- Cycle left through the tabline
			unmark_all = "<leader>bu", -- Close all marked and recent buffers
		},
	}, -- see Configuration section
}

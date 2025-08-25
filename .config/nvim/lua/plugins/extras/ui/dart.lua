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
	opts = {}, -- see Configuration section
}

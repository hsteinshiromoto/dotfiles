return {
	"franco-ruggeri/pdf-preview.nvim",
	opts = {
		-- Override defaults here
	},
	config = function(_, opts)
		require("pdf-preview").setup(opts)
	end,
}

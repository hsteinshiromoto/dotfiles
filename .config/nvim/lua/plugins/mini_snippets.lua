return {
	"echasnovski/mini.snippets",
	version = "*",
	dependencies = { "rafamadriz/friendly-snippets" },
	event = { "InsertEnter" },
	config = function()
		local snippets = require("mini.snippets")
		local gen_loader = snippets.gen_loader

		snippets.setup({
			snippets = {
				gen_loader.from_lang(),
			},
		})

		snippets.start_lsp_server()
	end,
}

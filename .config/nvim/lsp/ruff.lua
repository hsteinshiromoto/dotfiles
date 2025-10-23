return {
	cmd = {
		"ruff",
		"server",
	},
	filetypes = {
		"python",
	},
	root_markers = {
		".git",
		"pyproject.toml",
		".lock",
	},
	-- settings = {
	--     Lua = {
	--         diagnostics = {
	--             --     disable = { "missing-parameters", "missing-fields" },
	--         },
	--     },
	-- },

	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
}

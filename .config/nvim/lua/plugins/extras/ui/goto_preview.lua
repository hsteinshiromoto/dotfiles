return {
	"rmagatti/goto-preview",
	lazy = false,
	dependencies = { "rmagatti/logger.nvim" },
	event = "BufEnter",
	config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
	vim.keymap.set(
		"n",
		"gpd",
		"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
		{ noremap = true, desc = "Preview Definition" }
	),
	vim.keymap.set(
		"n",
		"gpt",
		"<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
		{ noremap = true, desc = "Preview Definition Type" }
	),
	vim.keymap.set(
		"n",
		"gpi",
		"<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
		{ noremap = true, desc = "Preview Definition Implementation" }
	),
	vim.keymap.set(
		"n",
		"gpr",
		"<cmd>lua require('goto-preview').goto_preview_references()<CR>",
		{ noremap = true, desc = "Preview References" }
	),
}

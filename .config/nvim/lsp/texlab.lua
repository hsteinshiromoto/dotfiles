return {

	cmd = { "texlab" },
	filetypes = { "tex" },
	root_markers = {
		".git",
		"Makefile",
	},
	settings = {
		texlab = {
			build = {
				onSave = true,
			},
		},
	},
}

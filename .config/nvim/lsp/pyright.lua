return {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	before_init = function(_, config)
		local venv = vim.fn.getcwd() .. "/.venv/bin/python"
		if vim.fn.executable(venv) == 1 then
			config.settings.python.pythonPath = venv
		end
	end,
	root_markers = {
		".git",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
	},
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
}

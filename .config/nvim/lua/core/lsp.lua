-- List of LSP servers to configure
local servers = {
	"ruff",
	"pyright", -- Full Python LSP for go-to-definition, hover, etc.
	"dockerls",
	"lua_ls",
	"marksman",
	"nixd",
	"texlab",
}

-- Use vim.lsp.config API (Neovim 0.11+)
for _, server_name in ipairs(servers) do
	-- Try to load the config file from ~/.config/nvim/lsp/{server_name}.lua
	local config_path = vim.fn.stdpath("config") .. "/lsp/" .. server_name .. ".lua"
	local config = {}

	if vim.fn.filereadable(config_path) == 1 then
		local ok, loaded_config = pcall(dofile, config_path)
		if ok and type(loaded_config) == "table" then
			config = loaded_config
		end
	end

	-- Set the configuration
	vim.lsp.config[server_name] = config
end

-- Enable all configured LSP servers
vim.lsp.enable(servers)

vim.diagnostic.config({
	-- virtual_lines = { severity = { min = vim.diagnostic.severity.ERROR } },
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

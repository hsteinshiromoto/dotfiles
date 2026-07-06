-- List of LSP servers to configure
local servers = {
	"ruff",
	"pyright", -- Full Python LSP for go-to-definition, hover, etc.
	"dockerls",
	"lua_ls",
	"markdown_oxide",
	"nixd",
	"texlab",
}

-- Get completion capabilities from nvim-cmp
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local default_capabilities = vim.lsp.protocol.make_client_capabilities()
if ok then
	default_capabilities = cmp_nvim_lsp.default_capabilities(default_capabilities)
end

-- Use vim.lsp.config API (Neovim 0.11+)
for _, server_name in ipairs(servers) do
	-- Try to load the config file from ~/.config/nvim/lsp/{server_name}.lua
	local config_path = vim.fn.stdpath("config") .. "/lsp/" .. server_name .. ".lua"
	local config = {}

	if vim.fn.filereadable(config_path) == 1 then
		local ok_config, loaded_config = pcall(dofile, config_path)
		if ok_config and type(loaded_config) == "table" then
			config = loaded_config
		end
	end

	-- Set capabilities with completion support
	config.capabilities = vim.tbl_deep_extend("force", default_capabilities, config.capabilities or {})

	-- Force UTF-16 encoding for ruff to match pyright
	if server_name == "ruff" then
		config.capabilities.general = config.capabilities.general or {}
		config.capabilities.general.positionEncodings = { "utf-16" }
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

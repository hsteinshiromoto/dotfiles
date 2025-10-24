return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "python" })
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					python = { "ruff_format" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.py",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
				group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = { "mfussenegger/nvim-dap-python" },
		config = function()
			require("dap-python").setup("python", {})
			table.insert(require("dap").configurations.python, {
				type = "python",
				request = "attach",
				connect = {
					port = 5678,
					host = "127.0.0.1",
				},
				mode = "remote",
				name = "container attach debug",
				cwd = vim.fn.getcwd(),
				pathmappings = {
					{
						localroot = function()
							return vim.fn.input("local code folder > ", vim.fn.getcwd(), "file")
						end,
						remoteroot = function()
							return vim.fn.input("container code folder > ", "/", "file")
						end,
					},
				},
			})
		end,
	},
	{
		"richardhapb/pytest.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {}, -- Define the options here
		config = function(_, opts)
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "python", "xml" },
			})

			require("pytest").setup(opts)
		end,
	},
}
-- References:
-- 	[1] https://alpha2phi.medium.com/modern-neovim-debugging-and-testing-8deda1da1411

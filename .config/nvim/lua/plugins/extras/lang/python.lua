return {
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
			require("pytest").setup(opts)
		end,
	},
	{
		-- nvim-lint arrives as an ensure.nvim dependency and ensure.nvim owns
		-- linters_by_ft (lua/plugins/ensure.lua). All this spec adds is the
		-- trigger, which nvim-lint leaves to the caller by design -- without
		-- it the configured linters never run.
		"mfussenegger/nvim-lint",
		config = function()
			-- bandit sets stdin = false and reads the file from disk, so a
			-- trigger on InsertLeave would report the previous write.
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
				pattern = "*.py",
				group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
-- References:
-- 	[1] https://alpha2phi.medium.com/modern-neovim-debugging-and-testing-8deda1da1411

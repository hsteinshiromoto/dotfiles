-- lsp/init.lua

return {
	{
		"williamboman/mason.nvim",
		priority = 100, -- Ensure Mason loads first
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		ensure_installed = {
			"bash-debug-adapter",
			"bash-language-server",
			"bibtex-tidy",
			"black",
			"blackd-client",
			"debugpy",
			"docformatter",
			"dockerfile-language-server",
			"isort",
			"json-lsp",
			"luacheck",
			"luaformatter",
			"marksman",
			"mypy",
			"pydocstyle",
			"pyright",
			-- "ruff",
			-- "stylua",
			-- "texlab",
			"yaml-language-server",
		},
		config = function(plugin)
			require("mason").setup()
			local mr = require("mason-registry")
			for _, tool in ipairs(plugin.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		priority = 90, -- Load right after Mason
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			-- Initialize mason-lspconfig with a basic setup
			require("mason-lspconfig").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			"williamboman/mason.nvim", -- Make sure this loads first
			"williamboman/mason-lspconfig.nvim", -- Then this
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			{ "folke/neodev.nvim", config = true },
			{ "j-hui/fidget.nvim", config = true },
			{ "smjonas/inc-rename.nvim", config = true },
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		opts = {
			servers = {},
			setup = {},
		},
		config = function(plugin, opts)
			require("plugins.lsp.servers").setup(plugin, opts)
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		event = "BufReadPre",
		dependencies = { "mason.nvim" },
		config = function()
			local nls = require("null-ls")
			nls.setup({
				sources = {
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.black,
					nls.builtins.diagnostics.mypy,
					-- nls.builtins.diagnostics.ruff,
				},
			})
		end,
	},
	{
		"utilyre/barbecue.nvim",
		event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("barbecue").setup({
				attach_navic = false, -- We'll manually attach navic to avoid conflicts
				create_autocmd = false, -- We'll manually create the autocmd
			})

			-- Manually attach navic to avoid conflicts with multiple LSP servers
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local bufnr = args.buf

					-- Skip if navic is already attached to this buffer
					if vim.b[bufnr].navic_attached then
						return
					end

					-- Only attach navic to specific LSP servers
					-- For markdown files, prefer marksman over obsidian-ls
					local allowed_servers = {
						lua_ls = true,
						ruff = true,
						pyright = true,
						marksman = true,
						-- Explicitly exclude obsidian-ls to avoid conflicts
					}

					if
						client
						and allowed_servers[client.name]
						and client.server_capabilities.documentSymbolProvider
					then
						require("nvim-navic").attach(client, bufnr)
						vim.b[bufnr].navic_attached = true
						require("barbecue.ui").update()
					end
				end,
			})

			-- Create autocmd to update barbecue
			vim.api.nvim_create_autocmd({
				"WinResized",
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",
			}, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
		end,
	},
	{
		"retran/meow.yarn.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("meow.yarn").setup({
				-- Using lua functions
				vim.keymap.set("n", "<leader>yt", function()
					require("meow.yarn").open_tree("type_hierarchy", "supertypes")
				end, { desc = "Yarn: Type Hierarchy (Super)" }),
				vim.keymap.set("n", "<leader>yT", function()
					require("meow.yarn").open_tree("type_hierarchy", "subtypes")
				end, { desc = "Yarn: Type Hierarchy (Sub)" }),
				vim.keymap.set("n", "<leader>yc", function()
					require("meow.yarn").open_tree("call_hierarchy", "callers")
				end, { desc = "Yarn: Call Hierarchy (Callers)" }),
				vim.keymap.set("n", "<leader>yC", function()
					require("meow.yarn").open_tree("call_hierarchy", "callees")
				end, { desc = "Yarn: Call Hierarchy (Callees)" }),

				-- Or using commands
				vim.keymap.set("n", "<leader>yS", "<Cmd>MeowYarn type super<CR>", { desc = "Yarn: Super Types" }),
				vim.keymap.set("n", "<leader>ys", "<Cmd>MeowYarn type sub<CR>", { desc = "Yarn: Sub Types" }),
				vim.keymap.set("n", "<leader>yC", "<Cmd>MeowYarn call callers<CR>", { desc = "Yarn: Callers" }),
				vim.keymap.set("n", "<leader>yc", "<Cmd>MeowYarn call callees<CR>", { desc = "Yarn: Callees" }),
			})
		end,
	},
}

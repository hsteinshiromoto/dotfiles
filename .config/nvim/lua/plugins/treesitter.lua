-- Tree-sitter: use nvim-treesitter `main` (Neovim 0.12+). The `master` branch is
-- frozen for Nvim 0.11 and breaks markdown injections on 0.12.
-- See https://github.com/nvim-treesitter/nvim-treesitter/issues/8618
--
-- nvim-treesitter `main` requires the **tree-sitter CLI** on your PATH (command
-- name: `tree-sitter`, v0.26.1+). It runs `tree-sitter build` / `generate`; without
-- it you get ENOENT on `tree-sitter`. Install e.g.:
--   macOS: brew install tree-sitter-cli   (`tree-sitter` is library-only; CLI is separate)
--   Nix:   nix profile install nixpkgs#tree-sitter  (or the package that provides `tree-sitter`)
--   Cargo: cargo install tree-sitter-cli   (ensure ~/.cargo/bin is on PATH)
--
-- The installer defaults to a very high max_jobs; compiling many parsers at
-- once can overload the machine. Keep parallelism low.
-- References:
-- 	[1] https://github.com/nvim-treesitter/nvim-treesitter/issues/1097#issuecomment-1368177624

local function tree_sitter_cli_ok()
	return vim.fn.executable("tree-sitter") == 1
end

local function warn_missing_tree_sitter_cli()
	vim.schedule(function()
		vim.notify(
			"nvim-treesitter (main): `tree-sitter` executable not on PATH. "
				.. "Install the CLI (e.g. `brew install tree-sitter-cli`), restart Neovim, then `:TSInstall all` or `:Lazy build nvim-treesitter`.",
			vim.log.levels.ERROR
		)
	end)
end

local ts_install_opts = { summary = true, max_jobs = 4 }

local install_languages = {
	"bash",
	"bibtex",
	"cmake",
	"comment",
	"csv",
	"diff",
	"dockerfile",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"gpg",
	"html",
	"http",
	"latex",
	"json",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"nix",
	"python",
	"query",
	"regex",
	"rst",
	"sql",
	"ssh_config",
	"tmux",
	"tsv",
	"toml",
	"vim",
	"vimdoc",
	"yaml",
	"xml",
}

local function setup_treesitter_features(args)
	local buf = args.buf
	if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
		return
	end
	if not pcall(vim.treesitter.start, buf) then
		return
	end
	pcall(vim.api.nvim_set_option_value, "indentexpr", "v:lua.require'nvim-treesitter'.indentexpr()", {
		buf = buf,
	})
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		-- :TSUpdate does not pass max_jobs; use the API so updates do not compile
		-- every parser in parallel (same failure mode as a fresh :TSInstall all).
		build = function()
			if not tree_sitter_cli_ok() then
				warn_missing_tree_sitter_cli()
				return
			end
			local ok, err = pcall(function()
				require("nvim-treesitter").update(nil, ts_install_opts):wait(600000)
			end)
			if not ok then
				vim.schedule(function()
					vim.notify("[nvim-treesitter] TSUpdate build failed: " .. tostring(err), vim.log.levels.WARN)
				end)
			end
		end,
		config = function()
			if not tree_sitter_cli_ok() then
				warn_missing_tree_sitter_cli()
			end
			require("nvim-treesitter").setup({
				ensure_installed = tree_sitter_cli_ok() and install_languages or {},
				max_install_jobs = ts_install_opts.max_jobs,
			})

			local aug = vim.api.nvim_create_augroup("dotfiles_treesitter", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = aug,
				pattern = "*",
				callback = setup_treesitter_features,
			})
			-- Buffers already open when this config runs (e.g. lazy reload).
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
					setup_treesitter_features({ buf = buf, match = vim.bo[buf].filetype })
				end
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					include_surrounding_whitespace = false,
				},
				move = {
					set_jumps = true,
				},
			})

			local sel = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			local swap = require("nvim-treesitter-textobjects.swap")

			local modes = { "x", "o" }
			vim.keymap.set(modes, "aa", function()
				sel.select_textobject("@parameter.outer", "textobjects")
			end)
			vim.keymap.set(modes, "ia", function()
				sel.select_textobject("@parameter.inner", "textobjects")
			end)
			vim.keymap.set(modes, "af", function()
				sel.select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set(modes, "if", function()
				sel.select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set(modes, "ac", function()
				sel.select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set(modes, "ic", function()
				sel.select_textobject("@class.inner", "textobjects")
			end)

			local move_modes = { "n", "x", "o" }
			vim.keymap.set(move_modes, "]m", function()
				move.goto_next_start("@function.outer", "textobjects")
			end)
			vim.keymap.set(move_modes, "]]", function()
				move.goto_next_start("@class.outer", "textobjects")
			end)
			vim.keymap.set(move_modes, "]M", function()
				move.goto_next_end("@function.outer", "textobjects")
			end)
			vim.keymap.set(move_modes, "][", function()
				move.goto_next_end("@class.outer", "textobjects")
			end)
			vim.keymap.set(move_modes, "[m", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end)
			vim.keymap.set(move_modes, "[[", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end)
			vim.keymap.set(move_modes, "[M", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end)
			vim.keymap.set(move_modes, "[]", function()
				move.goto_previous_end("@class.outer", "textobjects")
			end)

			vim.keymap.set("n", "<leader>cxp", function()
				swap.swap_next("@parameter.inner")
			end)
			vim.keymap.set("n", "<leader>cXp", function()
				swap.swap_previous("@parameter.inner")
			end)
			vim.keymap.set("n", "<leader>cxf", function()
				swap.swap_next("@function.outer")
			end)
			vim.keymap.set("n", "<leader>cXf", function()
				swap.swap_previous("@function.outer")
			end)
			vim.keymap.set("n", "<leader>cxc", function()
				swap.swap_next("@class.outer")
			end)
			vim.keymap.set("n", "<leader>cXc", function()
				swap.swap_previous("@class.outer")
			end)
		end,
	},
}

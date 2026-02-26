local M = {}

function M.quit()
	local bufnr = vim.api.nvim_get_current_buf()
	local buf_windows = vim.call("win_findbuf", bufnr)
	local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
	if modified and #buf_windows == 1 then
		vim.ui.input({
			prompt = "You have unsaved changes. Quit anyway? (y/n) ",
		}, function(input)
			if input == "y" then
				vim.cmd("qa!")
			end
		end)
	else
		vim.cmd("qa!")
	end
end

function M.find_files()
	local opts = {}
	local telescope = require("telescope.builtin")

	local ok = pcall(telescope.git_files, opts)
	if not ok then
		telescope.find_files(opts)
	end
end

function M.strip_obsidian_syntax(text)
	-- Remove YAML frontmatter
	text = text:gsub("^%-%-%-\n.-\n%-%-%-\n", "")
	-- Remove embedded files ![[anything]]
	text = text:gsub("!%[%[.-%]%]", "")
	-- Convert wiki links with display text [[target|display]] → display
	text = text:gsub("%[%[[^%]]-|([^%]]-)%]%]", "%1")
	-- Convert wiki links without display text [[target]] → target
	text = text:gsub("%[%[([^%]]-)%]%]", "%1")
	-- Convert callout markers > [!type] → Type:
	text = text:gsub("> %[!(%w+)%]", function(t)
		return t:sub(1, 1):upper() .. t:sub(2):lower() .. ":"
	end)
	-- Remove highlight syntax ==text== → text
	text = text:gsub("==(.-)==", "%1")
	return text
end

return M

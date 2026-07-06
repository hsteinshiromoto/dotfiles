-- Add at the top of your init.lua
local args = vim.v.argv
local is_remote = false
for _, arg in ipairs(args) do
	if arg == "--remote-ui" or arg:match("^--server") then
		is_remote = true
		break
	end
end

-- Later in your config, when loading plugins:
if not is_remote then
	local socket = '/tmp/nvim.' .. vim.fn.getpid()
	local symlink = '/tmp/nvim'
	local uv = vim.uv or vim.loop

	vim.fn.serverstart(socket)
	uv.fs_unlink(symlink)
	uv.fs_symlink(socket, symlink)

	vim.api.nvim_create_autocmd('VimLeavePre', {
		callback = function()
			local link = uv.fs_readlink(symlink)
			if link == socket then
				uv.fs_unlink(symlink)
			end
			uv.fs_unlink(socket)
		end,
	})
	require("config.options")
	require("config.lazy")
	require("config.icons")
	require("core.lsp")

	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			require("config.autocmds")
			require("config.keymaps")
		end,
	})
	-- Load your regular plugins here
else
	-- Load only minimal plugins needed for remote work
end

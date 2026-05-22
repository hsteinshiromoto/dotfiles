	return {
	"not-manu/filemention.nvim",
	dependencies = { "dmtrKovalenko/fff.nvim" },
	event = "InsertEnter",
	config = function()
		require("filemention").setup({
			trigger = "@",                                 -- the magic key
			root = "git",                                  -- "git" | "cwd" | function() return path end
			respect_gitignore = true,                      -- don't surface your node_modules sins
			include_hidden = false,
			format = "bare",                               -- "bare" | "markdown" | function(path, name)
			filetypes = { "markdown", "text", "gitcommit" }, -- or "*" if you live dangerously
			max_items = 500,
			finder = "fff",                                -- "auto" | "fd" | "rg" | "vim" | "fff"
		})
	end,
}

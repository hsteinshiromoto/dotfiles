return {
	"kevalin/mermaid.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	ft = "markdown",
	config = function()
		require("mermaid").setup({
			format = {
				shift_width = 4, -- Indentation size (spaces)
			},
			lint = {
				enabled = true, -- Enable diagnostics via mmdc
				command = "mmdc", -- Path to mermaid-cli executable
			},
			preview = {
				renderer = "mermaid.js", -- "mermaid.js" or "beautiful-mermaid"
				theme = "default",   -- Theme name (renderer-specific)
			},
		})
		-- Install the Tree-sitter parser:
		-- :TSInstall mermaid
	end,
}

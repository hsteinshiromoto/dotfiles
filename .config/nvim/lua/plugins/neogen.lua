return {
	"danymat/neogen",
	opts = {
		snippet_engine = "luasnip",
		enabled = true,
		languages = {
			lua = {
				template = {
					annotation_convention = "ldoc",
				},
			},
			python = {
				template = {
					annotation_convention = "google_docstrings",
				},
			},
		},
	},
	--stylua: ignore
	keys = {
		{ "<localleader>ga", function() require("neogen").generate() end,                  desc = "Generate Annotation", },
		{ "<localleader>gc", function() require("neogen").generate { type = "class" } end, desc = "Generate Class", },
		{ "<localleader>gf", function() require("neogen").generate { type = "func" } end,  desc = "Generate Function", },
		{ "<localleader>gt", function() require("neogen").generate { type = "type" } end,  desc = "Generate Type", },
	},
}

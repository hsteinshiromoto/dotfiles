-- TokyoNight theme for lualine customized to match tmux colors
-- This theme syncs the Neovim statusline colors with the tmux statusline
-- for a cohesive visual experience across multiplexer and editor.
--
-- Color reference (from tmux config):
-- Primary accent: #7aa2f7 (tokyonight blue)
-- Dark background: #24293b (tokyonight storm bg)
-- Statusline bg: #16161e (tokyonight dark bg)
-- Dark text: #15161e (nearly black)
-- Light text: #c0caf5 (tokyonight light fg)

local colors = {
	-- Primary statusline colors
	bg_dark = "#16161e",           -- Default statusline background
	bg_storm = "#24293b",          -- Dark blue-grey for sections
	bg_dark_text = "#15161e",      -- Near black for text on highlight

	-- Text colors
	fg_light = "#c0caf5",          -- Light foreground text
	fg_medium = "#a9b1d6",         -- Medium grey text
	fg_gutter = "#3b4261",         -- Gutter/secondary background

	-- Accent colors
	blue = "#7aa2f7",              -- Primary highlight (matches tmux)
	green = "#9ece6a",             -- Insert mode
	magenta = "#bb9af7",           -- Visual mode
	red = "#f7768e",               -- Replace mode
	yellow = "#e0af68",            -- Command mode
	cyan = "#7dcfff",              -- Terminal mode
}

return {
	normal = {
		a = { bg = colors.blue, fg = colors.bg_dark_text, gui = "bold" },
		b = { bg = colors.bg_storm, fg = colors.blue },
		c = { bg = colors.bg_dark, fg = colors.fg_medium },
	},
	insert = {
		a = { bg = colors.green, fg = colors.bg_dark_text, gui = "bold" },
		b = { bg = colors.bg_storm, fg = colors.green },
		c = { bg = colors.bg_dark, fg = colors.fg_medium },
	},
	visual = {
		a = { bg = colors.magenta, fg = colors.bg_dark_text, gui = "bold" },
		b = { bg = colors.bg_storm, fg = colors.magenta },
		c = { bg = colors.bg_dark, fg = colors.fg_medium },
	},
	replace = {
		a = { bg = colors.red, fg = colors.bg_dark_text, gui = "bold" },
		b = { bg = colors.bg_storm, fg = colors.red },
		c = { bg = colors.bg_dark, fg = colors.fg_medium },
	},
	command = {
		a = { bg = colors.yellow, fg = colors.bg_dark_text, gui = "bold" },
		b = { bg = colors.bg_storm, fg = colors.yellow },
		c = { bg = colors.bg_dark, fg = colors.fg_medium },
	},
	terminal = {
		a = { bg = colors.cyan, fg = colors.bg_dark_text, gui = "bold" },
		b = { bg = colors.bg_storm, fg = colors.cyan },
		c = { bg = colors.bg_dark, fg = colors.fg_medium },
	},
	inactive = {
		a = { bg = colors.bg_storm, fg = colors.fg_gutter },
		b = { bg = colors.bg_dark, fg = colors.fg_gutter },
		c = { bg = colors.bg_dark, fg = colors.fg_gutter },
	},
}

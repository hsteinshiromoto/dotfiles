local function getDayOffset(days, isBusinessDay)
	-- Default isBusinessDay to false if not provided
	isBusinessDay = isBusinessDay or false

	-- If not business day mode, use original logic
	if not isBusinessDay then
		-- Get current local time
		local current = os.date("*t")
		-- Create a new time table for the target date
		local target = {
			year = current.year,
			month = current.month,
			day = current.day + days,
			hour = 12, -- Set to noon to avoid DST issues
			min = 0,
			sec = 0,
		}
		-- Convert to timestamp and back to ensure proper date calculation
		local target_time = os.time(target)
		return os.date("%Y-%m-%d", target_time)
	end

	-- Business day logic
	local current = os.date("*t")
	local days_offset = 0
	local business_days_counted = 0
	local direction = days > 0 and 1 or -1
	local target_business_days = math.abs(days)

	-- Skip weekends when counting business days
	while business_days_counted < target_business_days do
		days_offset = days_offset + direction
		local target = {
			year = current.year,
			month = current.month,
			day = current.day + days_offset,
			hour = 12,
			min = 0,
			sec = 0,
		}
		local time = os.time(target)
		local t = os.date("*t", time)
		-- Check if it's a weekday (Monday=2 to Friday=6)
		if t.wday >= 2 and t.wday <= 6 then
			business_days_counted = business_days_counted + 1
		end
	end

	local final_target = {
		year = current.year,
		month = current.month,
		day = current.day + days_offset,
		hour = 12,
		min = 0,
		sec = 0,
	}
	return os.date("%Y-%m-%d", os.time(final_target))
end

-- Corrected ISO week calculation
function getISOWeek(time)
	time = time or os.time()
	local t = os.date("*t", time)

	-- Find Thursday of current week
	-- In Lua: Sunday=1, Monday=2, ..., Thursday=5, ..., Saturday=7
	local current_day = t.wday
	local days_to_thursday = 5 - current_day -- Thursday is day 5
	local thursday_time = time + (days_to_thursday * 86400)
	local thursday_date = os.date("*t", thursday_time)

	-- The year of the ISO week is the year of the Thursday
	local iso_year = thursday_date.year

	-- Find the first Thursday of the ISO year
	local jan1 = os.time({ year = iso_year, month = 1, day = 1 })
	local jan1_date = os.date("*t", jan1)
	local jan1_wday = jan1_date.wday

	-- Days from Jan 1 to first Thursday
	local days_to_first_thursday
	if jan1_wday <= 5 then
		-- Jan 1 is Mon-Thu (2-5), Thursday is in the same week
		days_to_first_thursday = 5 - jan1_wday
	else
		-- Jan 1 is Fri-Sun (6,7,1), Thursday is in the next week
		days_to_first_thursday = 12 - jan1_wday
	end

	local first_thursday = jan1 + (days_to_first_thursday * 86400)

	-- Calculate week number
	local days_diff = (thursday_time - first_thursday) / 86400
	local week_num = math.floor(days_diff / 7) + 1

	return string.format("%d-W%02d", iso_year, week_num)
end

-- Main function remains the same
function getDateOffset(offset, unit)
	unit = unit or "week"

	if unit == "week" then
		local current = os.date("*t")
		local target = {
			year = current.year,
			month = current.month,
			day = current.day + (offset * 7),
			hour = 12,
			min = 0,
			sec = 0,
		}
		local offset_time = os.time(target)
		return getISOWeek(offset_time)
	elseif unit == "month" then
		local t = os.date("*t")
		t.day = 15
		t.month = t.month + offset
		t.hour = 12
		t.min = 0
		t.sec = 0
		return os.date("%Y-%m", os.time(t))
	elseif unit == "quarter" then
		local t = os.date("*t")
		t.day = 15
		t.month = t.month + (offset * 3)
		t.hour = 12
		t.min = 0
		t.sec = 0
		local quarter = math.ceil(((t.month - 1) % 12 + 1) / 3)
		return os.date("%Y", os.time(t)) .. "-Q" .. quarter
	end
end

function getWeekDays(include_weekend)
	include_weekend = include_weekend ~= false
	local current = os.date("*t")
	local d = {}
	-- For Sunday start: wday=1 is Sunday, so days since Sunday = wday - 1
	local days_since_sunday = current.wday - 1
	for i = 0, (include_weekend and 6 or 4) do
		local target = {
			year = current.year,
			month = current.month,
			day = current.day - days_since_sunday + i,
			hour = 12,
			min = 0,
			sec = 0,
		}
		d[i + 1] = string.format(
			"[[%s|%s]]",
			os.date("%Y-%m-%d", os.time(target)),
			({ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" })[i + 1]
		)
	end
	return table.concat(d, ", ")
end

-- Generate a calendar table for a given month
function getMonthCalendar()
	local current = os.date("*t")
	local year = current.year
	local month = current.month

	-- Get first day of the month
	local first_day = os.time({ year = year, month = month, day = 1, hour = 12 })
	local first_day_t = os.date("*t", first_day)
	local first_wday = first_day_t.wday -- 1=Sunday, 2=Monday, ..., 7=Saturday

	-- Get last day of the month
	local next_month = month + 1
	local next_year = year
	if next_month > 12 then
		next_month = 1
		next_year = year + 1
	end
	local last_day = os.time({ year = next_year, month = next_month, day = 1, hour = 12 }) - 86400
	local last_day_t = os.date("*t", last_day)
	local days_in_month = last_day_t.day
	local last_wday = last_day_t.wday

	-- Get previous month info
	local prev_month = month - 1
	local prev_year = year
	if prev_month < 1 then
		prev_month = 12
		prev_year = year - 1
	end
	-- Get last day of previous month
	local prev_last_day = os.time({ year = year, month = month, day = 1, hour = 12 }) - 86400
	local prev_last_day_t = os.date("*t", prev_last_day)
	local prev_days_in_month = prev_last_day_t.day

	-- Helper function to center text in a fixed width
	local function centerText(text, width)
		local textLen = #text
		local padding = width - textLen
		local leftPad = math.floor(padding / 2)
		local rightPad = padding - leftPad
		return string.rep(" ", leftPad) .. text .. string.rep(" ", rightPad)
	end

	-- Build calendar table with consistent column widths
	local calendar = {}
	-- Header row with centered day names
	table.insert(calendar, "|   Week   |  Sunday  |  Monday  | Tuesday  | Wednesday | Thursday |  Friday  | Saturday |")
	table.insert(calendar, "|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|")

	-- Calculate starting position
	local day = 1
	local week_row = {}

	-- Handle the first week
	local first_week_time = first_day
	-- Adjust to get the Sunday of the first week
	first_week_time = first_week_time - ((first_wday - 1) * 86400)
	local week_num = getISOWeek(first_day)
	table.insert(week_row, string.format("[[%s]]", week_num))

	-- Fill in days from previous month before the first day of current month
	if first_wday > 1 then
		local prev_day = prev_days_in_month - (first_wday - 2)
		for i = 1, first_wday - 1 do
			local date_str = string.format("%04d-%02d-%02d", prev_year, prev_month, prev_day)
			table.insert(week_row, string.format("[[%s\\|%02d]]", date_str, prev_day))
			prev_day = prev_day + 1
		end
	end

	-- Fill in the days of the first week from current month
	for i = first_wday, 7 do
		if day <= days_in_month then
			local date_str = string.format("%04d-%02d-%02d", year, month, day)
			table.insert(week_row, string.format("[[%s\\|%02d]]", date_str, day))
			day = day + 1
		end
	end
	table.insert(calendar, "| " .. table.concat(week_row, " | ") .. " |")

	-- Handle remaining weeks
	while day <= days_in_month do
		week_row = {}
		-- Calculate week number for this week
		local current_day_time = os.time({ year = year, month = month, day = day, hour = 12 })
		week_num = getISOWeek(current_day_time)
		table.insert(week_row, string.format("[[%s]]", week_num))

		-- Fill in the days of the week
		for wday = 1, 7 do
			if day <= days_in_month then
				local date_str = string.format("%04d-%02d-%02d", year, month, day)
				table.insert(week_row, string.format("[[%s\\|%02d]]", date_str, day))
				day = day + 1
			else
				-- We've gone past the last day of the month, add next month's days
				local next_day = day - days_in_month
				local date_str = string.format("%04d-%02d-%02d", next_year, next_month, next_day)
				table.insert(week_row, string.format("[[%s\\|%02d]]", date_str, next_day))
				day = day + 1
			end
		end
		table.insert(calendar, "| " .. table.concat(week_row, " | ") .. " |")

		-- Check if we've filled the last week completely
		if
			day > days_in_month
			and ((day - days_in_month - 1) % 7 == 0 or (last_wday == 7 and day == days_in_month + 1))
		then
			break
		end
	end

	return table.concat(calendar, "\n")
end

local icons = require("config.icons")
local function tchelper(first, rest)
	return first:upper() .. rest:lower()
end
local function make_id()
	local suffix = ""
	for _ = 1, 4 do
		suffix = suffix .. string.char(math.random(65, 90))
	end
	return tostring(os.date("%Y-%m-%d")) .. "_" .. suffix
end
local function basename_func(title)
	-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
	-- In this case a note with the title 'My new note' will be given an ID that looks
	-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
	local suffix = ""
	if title ~= nil then
		-- If title is given, transform it into valid file name.
		suffix =
			title:gsub(" ", "_"):gsub("[^A-Za-z0-9-]", " "):gsub("(%a)([%w_']*)", tchelper):gsub("[^A-Za-z0-9-]", "_")
		suffix = tostring(os.date("%Y-%m-%d")) .. "_" .. suffix
	else
		-- If title is nil, just add 4 random uppercase letters to the suffix.
		suffix = make_id()
	end
	return suffix
end

return {
	"obsidian-nvim/obsidian.nvim",
	tag = "v3.12.0",
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- see below for full list of optional dependencies 👇
	},
	-- Add condition to only load plugin if directory .obsidian is present [1, 2]
	cond = vim.fn.isdirectory(".obsidian") == 1,
	keys = {

		{ "<localleader>ot", "<cmd>Obsidian template<cr>", desc = "Insert Template" },
		{ "<localleader>on", "<cmd>Obsidian new_from_template<cr>", desc = "New Note From Template" },
		{ "<localleader>od", "<cmd>Obsidian today<cr>", desc = "Obsidian Daily Note" },
		{ "<localleader>ol", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
	},
	new_notes_location = "notes_subdir",
	opts = {
		ui = {
			enable = true,
			checkboxes = {
				["<"] = { char = icons.ui.Calendar2, hl_group = "ObsidianDone" },
				["/"] = { char = icons.ui.MinusSquare, hl_group = "ObsidianImportant" },
				[" "] = { char = icons.ui.CheckBox, hl_group = "ObsidianTodo" },
				["-"] = { char = icons.ui.MinusSquare, hl_group = "ObsidianDone" },
				["x"] = { char = icons.ui.BoxChecked2, hl_group = "ObsidianDone" },
				[">"] = { char = "", hl_group = "ObsidianRightArrow" },
				["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
				["!"] = { char = icons.ui.AlertTriangle, hl_group = "ObsidianImportant" },
				["i"] = { char = icons.diagnostics.Information, hl_group = "ObsidianDone" },
			},
		},
		workspaces = {
			{
				name = "personal",
				path = "~/Personal/content/",
			},
			{
				name = "LOR",
				path = "~/Work/LOR/Notes",
			},
			{
				name = "recipes",
				path = "~/Projects/recipes/content/",
			},
		},
		templates = {
			folder = "_meta_/_templates_",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			-- A map for custom variables, the key should be the variable and the value a function
			substitutions = {
				YEAR = function()
					return os.date("%Y", os.time())
				end,
				YEAR_PREVIOUS_QUARTER = function()
					return getDateOffset(-1, "quarter")
				end,
				YEAR_QUARTER = string.format("%s-Q%d", os.date("%Y"), math.ceil(os.date("%m") / 3)),
				YEAR_NEXT_QUARTER = function()
					return getDateOffset(1, "quarter")
				end,
				YEAR_PREVIOUS_MONTH = function()
					return getDateOffset(-1, "month")
				end,
				YEAR_MONTH = function()
					return os.date("%Y-%m", os.time())
				end,
				YEAR_NEXT_MONTH = function()
					return getDateOffset(1, "month")
				end,
				YEAR_PREVIOUS_WEEK_NUMBER = function()
					return getDateOffset(-1, "week")
				end,
				YEAR_WEEK_NUMBER = function()
					return getDateOffset(0, "week")
				end,
				DAYS_OF_WEEK = function()
					return getWeekDays()
				end,
				YEAR_NEXT_WEEK_NUMBER = function()
					return getDateOffset(1, "week")
				end,
				-- YESTERDAY and TOMORROW were being evaluated once when the config was loaded (likely on 2025-08-15), rather than being evaluated each time a template is created
				YESTERDAY = function()
					return getDayOffset(-1)
				end,
				TODAY = function()
					return getDayOffset(0)
				end,
				TOMORROW = function()
					return getDayOffset(1)
				end,
				MONTH_CALENDAR = function()
					return getMonthCalendar()
				end,
			},
		},
		-- Optional, customize how note IDs are generated given an optional title.
		---@return string
		note_id_func = function()
			return make_id()
		end,
		-- Optional, customize how note file names are generated given the ID, target directory, and title.
		---@param spec { id: string, dir: obsidian.Path, title: string|? }
		---@return string|obsidian.Path The full path to the new note.
		note_path_func = function(spec)
			local basename = basename_func(spec.title)
			-- This is equivalent to the default behavior.
			local path = spec.dir / tostring(basename)
			return path:with_suffix(".md")
		end,
		-- Optional, alternatively you can customize the frontmatter data.
		---@return table
		note_frontmatter_func = function(note)
			local date_created = note.metadata and note.metadata.date_created or tostring(os.date("%Y-%m-%d"))
			-- Add the title of the note as an alias.
			if note.title then
				note:add_alias(note.title)
				if not string.find(note.title, tostring(date_created), 1, true) then
					note:add_alias(date_created .. " " .. note.title)
				end
			end
			-- Add the note id as an alias
			if note.id then
				note:add_alias(note.id)
			end

			local out = {
				aliases = note.aliases,
				date_created = date_created,
				id = note.id,
				tags = note.tags,
				title = note.title,
			}

			-- `note.metadata` contains any manually added fields in the frontmatter.
			-- So here we just make sure those fields are kept in the frontmatter.
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end

			return out
		end,
		-- Keep the following setting for wiki links for Obsidian app to find the linked files
		wiki_link_func = "prepend_note_id",
	},
}
-- References:
--   [1] https://stackoverflow.com/questions/67259998/neovim-lua-isdirectory-vim-function
--   [2] https://github.com/LazyVim/LazyVim/discussions/2600#discussioncomment-8572894

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

-- ISO 8601 week numbering. Switched from Sunday-start on 2026-10-04:
-- the Makefile's `date +%V` was already ISO, the two rules disagreed every
-- Sunday, and two weekly notes were named after the wrong week. The
-- Sunday-first calendar renderers below are deliberately left as they are.
function getISOWeek(time)
	time = time or os.time()
	local t = os.date("*t", time)

	-- Noon, so a DST transition cannot push a date across a day boundary.
	local noon = os.time({ year = t.year, month = t.month, day = t.day, hour = 12, min = 0, sec = 0 })

	-- ISO weeks run Monday to Sunday, and the week year is the year that holds
	-- the Thursday of that week. Lua gives Sunday=1..Saturday=7, so convert to
	-- Monday=1..Sunday=7 first.
	local iso_wday = (t.wday + 5) % 7 + 1
	local thursday_time = noon + (4 - iso_wday) * 86400
	local iso_year = os.date("*t", thursday_time).year

	-- 4 January always falls in ISO week 1, so its Thursday anchors the year.
	local jan4 = os.time({ year = iso_year, month = 1, day = 4, hour = 12, min = 0, sec = 0 })
	local jan4_iso_wday = (os.date("*t", jan4).wday + 5) % 7 + 1
	local week1_thursday = jan4 + (4 - jan4_iso_wday) * 86400

	-- Round rather than floor. Both ends are noon, but a DST change between
	-- them moves the difference by an hour, which floor would turn into a
	-- whole week.
	local week_num = math.floor((thursday_time - week1_thursday) / (7 * 86400) + 0.5) + 1

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
	elseif unit == "year" then
		-- Mid-June, mid-month, noon: neither month length nor a DST transition
		-- can then move the result into an adjacent year.
		local t = os.date("*t")
		t.year = t.year + offset
		t.month = 6
		t.day = 15
		t.hour = 12
		t.min = 0
		t.sec = 0
		return os.date("%Y", os.time(t))
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

	-- Helper function to create a properly padded day link for calendar
	local function formatDayCell(date_str, day_num)
		-- Create the link with day number - always use 4 spaces padding on each side
		local link = string.format("[[%s\\|%02d]]", date_str, day_num)
		return "   " .. link .. "   " -- 3 spaces on each side
	end

	-- Helper function to format week cell with proper centering
	local function formatWeekCell(week_str)
		local link = string.format("[[%s]]", week_str)
		-- Week links are typically 11 chars like [[2025-W01]], need to center in 10 char column
		return link -- 1 space padding for 11-char week string in 10-char column
	end

	-- Helper function for Wednesday column which has 11 characters
	local function formatWednesdayCell(date_str, day_num)
		local link = string.format("[[%s\\|%02d]]", date_str, day_num)
		return "   " .. link .. "    " -- 4 spaces left, 5 spaces right for 11-char column
	end

	-- Build calendar table with consistent column widths
	local calendar = {}
	-- Header row with properly spaced day names
	table.insert(calendar, "|   Week   |  Sunday  |  Monday  | Tuesday  | Wednesday | Thursday |  Friday  | Saturday |")
	table.insert(calendar, "|----------|----------|----------|----------|-----------|----------|----------|----------|")

	-- Calculate starting position
	local day = 1
	local week_row = {}

	-- Handle the first week
	local first_week_time = first_day
	-- Adjust to get the Sunday of the first week
	first_week_time = first_week_time - ((first_wday - 1) * 86400)
	local week_num = getISOWeek(first_day)
	table.insert(week_row, formatWeekCell(week_num))

	-- Fill in days from previous month before the first day of current month
	if first_wday > 1 then
		local prev_day = prev_days_in_month - (first_wday - 2)
		for i = 1, first_wday - 1 do
			local date_str = string.format("%04d-%02d-%02d", prev_year, prev_month, prev_day)
			if i == 4 then -- Wednesday column
				table.insert(week_row, formatWednesdayCell(date_str, prev_day))
			else
				table.insert(week_row, formatDayCell(date_str, prev_day))
			end
			prev_day = prev_day + 1
		end
	end

	-- Fill in the days of the first week from current month
	for i = first_wday, 7 do
		if day <= days_in_month then
			local date_str = string.format("%04d-%02d-%02d", year, month, day)
			if i == 4 then -- Wednesday column
				table.insert(week_row, formatWednesdayCell(date_str, day))
			else
				table.insert(week_row, formatDayCell(date_str, day))
			end
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
		table.insert(week_row, formatWeekCell(week_num))

		-- Fill in the days of the week
		for wday = 1, 7 do
			if day <= days_in_month then
				local date_str = string.format("%04d-%02d-%02d", year, month, day)
				if wday == 4 then -- Wednesday column
					table.insert(week_row, formatWednesdayCell(date_str, day))
				else
					table.insert(week_row, formatDayCell(date_str, day))
				end
				day = day + 1
			else
				-- We've gone past the last day of the month, add next month's days
				local next_day = day - days_in_month
				local date_str = string.format("%04d-%02d-%02d", next_year, next_month, next_day)
				if wday == 4 then -- Wednesday column
					table.insert(week_row, formatWednesdayCell(date_str, next_day))
				else
					table.insert(week_row, formatDayCell(date_str, next_day))
				end
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

-- Generate a calendar table for the current week
function getWeekCalendar()
	local current = os.date("*t")
	-- Get current week number
	local week_num = getISOWeek(os.time(current))

	-- Calculate days of the current week (Sunday to Saturday)
	-- Find Sunday of current week
	local days_since_sunday = current.wday - 1 -- wday: 1=Sunday, so days_since_sunday = 0 for Sunday
	local sunday_time = os.time(current) - (days_since_sunday * 86400)

	-- Build calendar table
	local calendar = {}
	-- Header row
	table.insert(calendar, "| Week Day | Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday |")
	table.insert(calendar, "|----------|--------|--------|---------|-----------|----------|--------|----------|")

	-- Build the week row
	local week_row = {}
	-- Add week number
	table.insert(week_row, string.format("[[%s]]", week_num))

	-- Add each day of the week
	for i = 0, 6 do
		local day_time = sunday_time + (i * 86400)
		local day_date = os.date("*t", day_time)
		local date_str = os.date("%Y-%m-%d", day_time)
		local day_num = day_date.day

		-- Format each day cell with proper centering (3 spaces on each side for 8-char columns, except Wednesday with 11)
		local link = string.format("[[%s\\|%02d]]", date_str, day_num)
		if i == 3 then -- Wednesday (index 3, since Sunday is 0)
			table.insert(week_row, "   " .. link .. "    ") -- 2 left, 3 right for 11-char column
		else
			table.insert(week_row, "  " .. link .. "  ") -- 1 space on each side for 8-char columns
		end
	end

	table.insert(calendar, "| " .. table.concat(week_row, " | ") .. " |")

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
	-- tag = "v3.12.0",
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

		{ "<localleader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
		{ "<localleader>on", "<cmd>ObsidianNoteFromTemplate<cr>", desc = "New Note From Template" },
		{ "<localleader>od", "<cmd>Obsidian today<cr>", desc = "Obsidian Daily Note" },
		{ "<localleader>ol", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
		{ "<localleader>oc", "<cmd>ObsidianCopyClean<cr>", mode = "n", desc = "Copy Clean" },
		{ "<localleader>oc", ":<C-u>'<,'>ObsidianCopyClean<cr>", mode = "v", desc = "Copy Clean" },
	},
	new_notes_location = "notes_subdir",
	config = function(_, opts)
		require("obsidian").setup(opts)
		-- Renders the vault's Templater templates, which obsidian.nvim cannot read.
		require("utils.obsidian_template").setup()
		vim.api.nvim_create_user_command("ObsidianCopyClean", function(opts)
			local lines
			if opts.range > 0 then
				lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
			else
				lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			end
			local text = table.concat(lines, "\n")
			local clean = require("utils").strip_obsidian_syntax(text)
			vim.fn.setreg("+", clean)
			local scope = opts.range > 0 and "selection" or "buffer"
			vim.notify("Copied cleaned " .. scope .. " to clipboard")
		end, { range = true })
	end,
	opts = {
		legacy_commands = false,
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
				YEAR_PREVIOUS_YEAR = function()
					return getDateOffset(-1, "year")
				end,
				YEAR_NEXT_YEAR = function()
					return getDateOffset(1, "year")
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
				WEEK_CALENDAR = function()
					return getWeekCalendar()
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
		-- Optional, customize the frontmatter data using the new format
		frontmatter = {
			func = function(note)
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
		},
		-- Keep the following setting for wiki links for Obsidian app to find the linked files
		wiki_link_func = "prepend_note_id",
	},
}
-- References:
--   [1] https://stackoverflow.com/questions/67259998/neovim-lua-isdirectory-vim-function
--   [2] https://github.com/LazyVim/LazyVim/discussions/2600#discussioncomment-8572894

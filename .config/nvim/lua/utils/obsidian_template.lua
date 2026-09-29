-- Bridge from Neovim to the vault's own template renderer.
--
-- The vault writes its templates in Templater syntax (`<% %>`). obsidian.nvim
-- reads only `{{key}}`, so its `:Obsidian template` inserts those tags
-- verbatim. Keeping a second dialect of every template would mean two files to
-- edit per note type, so Neovim calls the renderer the vault already uses for
-- its `make` targets and its daily-notes pipeline instead. Obsidian, the shell
-- and Neovim then render from one source.
--
-- The renderer cannot open a dialog, so a template that prompts takes two
-- calls: `--describe` reports the prompts, Neovim collects the answers, and
-- `--json` renders with those answers and reports the filename the template
-- renames to.

local M = {}

local TEMPLATE_DIR = "_meta_/_templates_"
local RENDERER = "bin/render_template.py"
local TEMPLATER_SETTINGS = ".obsidian/plugins/templater-obsidian/data.json"

--- Find the vault that owns a path.
---@param path string|nil Path to search from. Defaults to the current buffer.
---@return string|nil root Vault root, or nil when the path is outside a vault.
function M.vault_root(path)
	return vim.fs.root(path or 0, ".obsidian")
end

--- Choose the interpreter that runs the renderer.
---
--- The renderer imports only the standard library, so any Python from 3.9 up
--- runs it. The vault's own environment is preferred because that is the
--- interpreter the vault's `make test` covers.
---@param root string Vault root.
---@return string interpreter
function M.interpreter(root)
	local venv = root .. "/.venv/bin/python"
	if vim.uv.fs_stat(venv) then
		return venv
	end
	return "python3"
end

--- Run the renderer.
---@param root string Vault root.
---@param args string[] Arguments after the script path.
---@return string|nil stdout, string|nil error
local function run(root, args)
	local script = root .. "/" .. RENDERER
	if not vim.uv.fs_stat(script) then
		return nil, "no template renderer at " .. script
	end

	local command = { M.interpreter(root), script }
	vim.list_extend(command, args)

	local result = vim.system(command, { cwd = root, text = true }):wait()
	if result.code ~= 0 then
		local message = result.stderr ~= "" and result.stderr or result.stdout
		return nil, vim.trim(message)
	end
	return result.stdout
end

--- List the templates a vault offers.
---@param root string Vault root.
---@return string[] names Template filenames, sorted.
function M.templates(root)
	local names = {}
	for name, kind in vim.fs.dir(root .. "/" .. TEMPLATE_DIR) do
		if kind == "file" and name:match("%.md$") then
			table.insert(names, name)
		end
	end
	table.sort(names)
	return names
end

--- Report the prompts a template asks for.
---@param root string Vault root.
---@param template string Template filename.
---@return table|nil spec `{ prompts = { { var, label } }, renames = boolean }`
---@return string|nil error
function M.describe(root, template)
	local out, err = run(root, { TEMPLATE_DIR .. "/" .. template, "--describe" })
	if not out then
		return nil, err
	end
	return vim.json.decode(out)
end

--- Render a template.
---@param root string Vault root.
---@param template string Template filename.
---@param title string Value for `tp.file.title`.
---@param answers table<string, string>|nil Prompt answers, keyed by variable.
---@return table|nil note `{ name = string|nil, content = string }`
---@return string|nil error
function M.render(root, template, title, answers)
	local args = { TEMPLATE_DIR .. "/" .. template, "--title", title, "--json" }
	for name, value in pairs(answers or {}) do
		table.insert(args, "--var")
		table.insert(args, name .. "=" .. value)
	end

	local out, err = run(root, args)
	if not out then
		return nil, err
	end

	local note = vim.json.decode(out)
	-- A template with no `tp.file.rename` reports a JSON null, which decodes to
	-- vim.NIL rather than nil and would survive an `if note.name` test.
	if note.name == vim.NIL then
		note.name = nil
	end
	return note
end

--- Ask for each prompt a template declares.
---@param prompts table[] Entries of `{ var, label }`.
---@return table<string, string>|nil answers nil when the user cancels.
function M.ask(prompts)
	local answers = {}
	for _, prompt in ipairs(prompts) do
		local answer = vim.trim(vim.fn.input({ prompt = prompt.label .. ": " }))
		if answer == "" then
			return nil
		end
		answers[prompt.var] = answer
	end
	return answers
end

--- The folder Obsidian files a template's notes in.
---
--- Read out of Templater's own settings rather than hardcoded here, so the two
--- apps cannot drift apart.
---@param root string Vault root.
---@param template string Template filename.
---@return string|nil folder Vault-relative folder, or nil when unmapped.
function M.folder(root, template)
	local path = root .. "/" .. TEMPLATER_SETTINGS
	if vim.fn.filereadable(path) == 0 then
		return nil
	end

	local ok, settings = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
	if not ok then
		return nil
	end

	for _, entry in ipairs(settings.folder_templates or {}) do
		if entry.template == TEMPLATE_DIR .. "/" .. template then
			return entry.folder
		end
	end
	return nil
end

--- Save the current buffer under a new name, dropping the old file.
---@param target string Absolute path to save to.
local function relocate(target)
	local previous = vim.api.nvim_buf_get_name(0)
	vim.fn.mkdir(vim.fs.dirname(target), "p")
	vim.cmd.saveas({ args = { vim.fn.fnameescape(target) }, bang = true })
	-- `saveas` writes the new file and leaves the old one behind.
	if previous ~= "" and previous ~= target and vim.uv.fs_stat(previous) then
		vim.uv.fs_unlink(previous)
	end
end

--- Resolve the vault and template, reporting either failure loudly.
---@param template string Template filename.
---@return string|nil root, table|nil spec
local function prepare(template)
	local root = M.vault_root()
	if not root then
		vim.notify("Not inside an Obsidian vault", vim.log.levels.ERROR)
		return nil
	end

	local spec, err = M.describe(root, template)
	if not spec then
		vim.notify(err, vim.log.levels.ERROR)
		return nil
	end
	return root, spec
end

--- Render a template into the current buffer.
---
--- Mirrors what Templater does in Obsidian: the note you are in is replaced,
--- and renamed in place when the template asks for a name.
---@param template string Template filename.
function M.apply(template)
	local root, spec = prepare(template)
	if not root then
		return
	end

	local answers = M.ask(spec.prompts)
	if not answers then
		return
	end

	local title = vim.fn.expand("%:t:r")
	if title == "" then
		title = "Untitled"
	end

	local note, err = M.render(root, template, title, answers)
	if not note then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end

	vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(note.content, "\n"))

	if note.name then
		local folder = vim.fn.expand("%:p:h")
		if vim.fn.expand("%") == "" then
			folder = root .. "/" .. (M.folder(root, template) or "")
		end
		relocate(vim.fs.normalize(folder .. "/" .. note.name .. ".md"))
	end
end

--- Create a new note from a template.
---
--- A template that prompts names the note itself, so only its own prompts are
--- asked and the title stays "Untitled" -- that is the value its
--- `startsWith("Untitled")` guard tests for, and supplying a real title here
--- would skip the guard and throw the answer away. Templates that do not
--- prompt cannot name anything, so those ask for a title instead.
---@param template string Template filename.
function M.create(template)
	local root, spec = prepare(template)
	if not root then
		return
	end

	local title = "Untitled"
	local answers = M.ask(spec.prompts)
	if not answers then
		return
	end

	if vim.tbl_isempty(answers) then
		title = vim.trim(vim.fn.input({ prompt = "Title: " }))
		if title == "" then
			return
		end
	end

	local note, err = M.render(root, template, title, answers)
	if not note then
		vim.notify(err, vim.log.levels.ERROR)
		return
	end

	local folder = M.folder(root, template)
	folder = folder and (root .. "/" .. folder) or vim.fn.expand("%:p:h")
	local target = vim.fs.normalize(folder .. "/" .. (note.name or title) .. ".md")

	vim.fn.mkdir(vim.fs.dirname(target), "p")
	vim.cmd.edit(vim.fn.fnameescape(target))
	vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(note.content, "\n"))
end

--- Offer the vault's templates and run `action` on the chosen one.
---@param action fun(template: string)
local function pick(action)
	local root = M.vault_root()
	if not root then
		vim.notify("Not inside an Obsidian vault", vim.log.levels.ERROR)
		return
	end
	vim.ui.select(M.templates(root), { prompt = "Template" }, function(choice)
		if choice then
			action(choice)
		end
	end)
end

--- Register the user commands.
function M.setup()
	local function complete()
		local root = M.vault_root()
		return root and M.templates(root) or {}
	end

	vim.api.nvim_create_user_command("ObsidianTemplate", function(opts)
		if opts.args ~= "" then
			M.apply(opts.args)
		else
			pick(M.apply)
		end
	end, { nargs = "?", complete = complete, desc = "Render a vault template into this buffer" })

	vim.api.nvim_create_user_command("ObsidianNoteFromTemplate", function(opts)
		if opts.args ~= "" then
			M.create(opts.args)
		else
			pick(M.create)
		end
	end, { nargs = "?", complete = complete, desc = "Create a note from a vault template" })
end

return M

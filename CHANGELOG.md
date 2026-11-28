# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Atuin daemon and thread capture (`.config/atuin/config.toml`): `[daemon] enabled`/`autostart` and `[threads] capture`, so Claude Code sessions are recorded as synced threads and `atuin resume` can search, resume and fork them across machines
- README section for atuin, naming the Nix files that own the binary and the Claude Code link
- Claude skill `humanize` (`.claude/skills/humanize/`): removes the signs of AI writing in four passes. `unslop.py` does the deterministic half — Unicode normalisation, per-vendor paste residue (`contentReference[oaicite:1]`, `[cite: 1]`, `grok_card`, DeepSeek lenticular brackets), unfilled placeholder brackets, and `utm_source=chatgpt.com`/`referrer=grok.com` on cited URLs. `SKILL.md` holds the rhetoric, syntax, diction and formatting passes, then hands the result to `ste_writing`. Reports by default and edits only under `--write`; never rewrites em or en dashes, and keeps U+200C/U+200D on non-Latin lines where they are letters. `disable-model-invocation`, so it runs only on `/humanize`
- Tests for `unslop.py` (`utils/test_unslop.py`): 38 checks covering the character tables, residue false positives, code and front-matter protection, non-Latin joiners, the unclosed-fence warning, idempotence and every CLI exit code. In `utils/` because `.stow-local-ignore` keeps that directory out of the link set
- Journal entries for 2026-11-28

### Changed

- Claude skill `humanize`, after an `llm_council` review. `unslop.py`: stop mapping primes (`′ ″`) onto quotes, which corrupted coordinates and collapsed CSV rows; keep the pattern off Markdown link labels, the word `attached_file` and `INSERT_OR_REPLACE`; treat YAML front matter and double-backtick spans as code; gate `--write` behind a prose-suffix allowlist, so it no longer rewrites `.py`, `.csv` or `.json`; warn on an unclosed code fence instead of reporting the rest of the file clean; skip an unreadable file instead of aborting the batch; exit codes now mean `0` clean, `1` findings or files changed, `2` a file could not be read, with report-only characters never gating. `SKILL.md`: "restore" superlatives and hedges becomes "keep", because inserting one invents a claim; the `ste_writing` handoff is removed, since its 20-word cap and semicolon ban reverse Passes 3 and 4 — the two skills are alternatives, not a pipeline; the run now ends by re-running `unslop.py --write`, because Passes 2 to 4 generate fresh prose the first run could not see
- Claude skill `llm_council` (`.claude/skills/llm_council/SKILL.md`): the grilling is amongst the members, never at the user. Council members may not call `AskUserQuestion`, which a subagent cannot use to reach anyone; only the Chairman may, after the final step. Process goes from three steps to four, adding an answers round where each member replies to the questions put to them and states where another member changed their mind

## [3.1.0] - 2026-09-06

### Added

- Claude skill `graphify`: turns any input into a knowledge graph (`.claude/skills/graphify/`)
- Claude skill `ste_writing`: rewrites prose into ASD-STE100 Simplified Technical English (`.claude/skills/ste_writing/`)
- Claude workflow `debug-ticket` (`.claude/workflows/debug-ticket.js`): triage of a JIRA bug, AWS SSO login, CloudWatch log query, and a read-only GitLab investigation that writes `reports/<TICKET>-root-cause.md`
- `.claude/workflows/README.md`: how to run the workflows and how to stow the directory
- CLAUDE.md sections: Unix Philosophy, commit and journal conventions, secrets and sensitive files, and a rule to read official docs before you use a third-party API or config syntax
- Espanso matches `.config/espanso/match/dates.yml`: an offset such as `-18d` or `+2w` expands to a date, in the format of Obsidian, bash, PowerShell, Python, or JavaScript
- Neovim dashboard script `.config/nvim/scripts/tuxedo-dashboard.sh`: renders the tuxedo task list from `todo.txt` in the tuxedo TUI colors
- Tokyo Night themes for atuin (`.config/atuin/themes/tokyonight.toml`), bat, and kitty (`.config/kitty/tokyonight_night.conf`)
- Journal entries for 2026-08-12, 2026-08-13, and 2026-08-14

### Changed

- Neovim dashboard: the Tasks pane replaces the Projects and Git Status panes. The pane shows only when `todo.txt` exists.
- Tokyo Night theme applied to atuin, bat, btop, kitty, code-server, and VS Code
- Vim: Tokyo Night replaces gruvbox, with `termguicolors` and a matching lightline theme
- Tmux: `allow-passthrough on`, plus `COLORTERM` and `TERM_PROGRAM` set for terminal image rendering
- Lazygit: the `pagers` key becomes `diffRenderers` to match the current schema
- Neovim plugin versions updated in `lazy-lock.json`
- New AWS and git permissions in `.claude/settings.local.json`

## [3.0.1] - 2026-07-06

### Added

- AI configuration: OpenCode (`opencode.json`, agents, commands, skills)
- Serena AI project configuration (`.serena/project.yml`)
- Neovim plugins: csvview, hypersonic, tuxedo, quickbuf, filemention, obsidian_tasks, ensure.nvim, television, aws, sql, dictionary, rooter, atone, cloak, calendar, nvim-json, stay-centered, claudecode, mini.identscope, mini.snippets
- Television fuzzy finder configuration with 20+ channels (ssh, docker, aws, env, systemd, nix, etc.)
- Tmuxinator configs for hledger and website
- Hammerspoon config for universal mic-mute toggle
- Karabiner complex modifications (earpod controls, mic mute, control-key tap/hold)
- Espanso matches: git, obsidian, typo fixes, UUID generator, docker naming
- Python snippets (UUID validation, AnyPath, sorted_data, project_root, argparse)
- Eza theme (tokyonight)
- Amnesia config for terminal session persistence
- Stow configuration (`.stowrc`, `.stow-local-ignore`)
- Claude/OpenCode skills: code-reviewer, explain-code, journal, sanity-check, JIRA, MR, MR-review
- Claude/OpenCode commands: release, check-prompt, summarize-meeting, git
- Claude/OpenCode agents: product-manager, build-evaluator, e2e-evaluator, plan-evaluator
- Claude handover hook script
- GitHub Copilot inference profile
- Tree-sitter update Makefile target

### Changed

- Migrated Claude Code settings to OpenCode configuration
- Espanso config moved from `macos/Library/Application Support/espanso` to `.config/espanso`
- Removed home-manager nix configs
- Neovim theme switched to tokyonight (colorscheme, lualine, tmux integration)
- Tmux config: new keybindings (tv/sesh integration, lazygit popup), tokyonight theme, statusline sync
- Starship prompt: tokyonight theme, nixos symbol, cargo path integration
- Ghostty: tokyonight theme, JetBrains Mono font
- Lazygit: tokyonight theme, auto-refresh disabled
- Bat theme set to tokyonight
- Yazi: tokyonight flavor, updated theme.toml
- CLiG/OpenCode/Serena agent workflow improvements
- Neovim LSP: pyright auto-detect venv, markdown-oxide replaces marksman, lua_ls settings
- Zsh: nvim alias, terminfo, nix_template alias

### Fixed

- Tree-sitter startup issues and broken parsers (noice cmdline, snake parser)
- Tmux duplicated config and lazygit popup fetching
- SSH agent socket forwarding
- Neovim swap files, calendar loading, snacks explorer nerdfont glyphs
- Ghostty missing ligature setting
- Python LSP (ruff startup)
- MCP socket latest-instance preference

### Removed

- Smartmotions.nvim, flash.nvim, harpoon, indent-blankline, goto_preview
- Yazi tmux popups (crash workaround)
- teams-mute.applescript (replaced by Hammerspoon/Karabiner)
- Rocks.nvim dependency
- `home-manager/` nix configuration directory
- Settings.json from .claude (migrated to opencode.json)

## v2.6.0

- Move installation to nix flake in the nix/ repo.
- Remove few nvim plugins.
- Install tmux plugins

## v2.5.1

See link: https://github.com/hsteinshiromoto/dotfiles.linux/pull/4#issuecomment-2571546170

## v2.5.0

See link: https://github.com/hsteinshiromoto/dotfiles.linux/pull/3#issuecomment-2570734306


## v2.1.0

### Added

Plugin Integrations:
- Added nvim-ufo for enhanced folding capabilities with dependencies on `promise-async` and `nvim-lspconfig`.
- Integrated `statuscol.nvim` for customizable status columns.
- Added `gitsigns.nvim` for Git integration with custom signs and line number highlighting.
- Included `fold-preview.nvim` for fold preview functionality.
- Added `todo-comments.nvim` for managing and navigating TODO comments.
- Integrated `lazygit.nvim` for Git management within Neovim.
- Added `tabout.nvim` for enhanced tab navigation.
- Integrated `neogen` for code documentation generation.
- Added `knap` for previewing markdown and LaTeX documents.

### Changed

Configuration Enhancements:
- Updated `statuscol.nvim` configuration to include segments for fold functions, git signs, and absolute line numbers.
- Modified `gitsigns.nvima configuration to include custom icons and enable line number highlighting.
- Updated `nvim-ufo` settings for fold column and level management.
- Enhanced `lualine.nvim` setup with custom components and icons.

### Fixed

Bug Fixes:
- Addressed issues with `statuscol.nvim` related to diagnostic signs.
- Resolved flickering issue with `lualine.nvim` when using components.git_repo.

### Removed

Deprecated Plugins:
- Commented out the use of `line-number-change-mode.nvim` due to error messages and color unpredictability.

### Notes

Documentation:
- Added references and comments for better understanding and future improvements.
- Included TODOs for potential enhancements and investigations.

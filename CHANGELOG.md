# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

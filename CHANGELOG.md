# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Add sops.yml
- Add nixd.lua file
- Add dockerls
- Add settings for lua_ls
- Add nixd lsp
- Add nushell window to cv tmuxinator config
- Add shell indicator to starship
- Add nix.yml for txmuxinator
- Add pass wrapper to make sure to update gpg stub files
- Add yazi.lua
- Add .ssh/config
- Add JIRA aliases
- Add weekday to weekly note in obsidian
- Add function to create obsidian calendar
- Add references to completion plugin
- Add keymap to delete until end of line
- Add option to convert also in visual mode
- Add marksman.lua lsp config file
- Add marksman lsp
- Add new karabiner rules
- Add ignore commands to atuin
- Add goto_preview plugin
- Add buffer navigation keymaps
- Add todo.lua plugin
- Add karabiner elements files
- Add mini.sessions and integrate with dat
- Add dart.nvim
- Add claude and gemini-cli as popups
- Add substitution for periodic notes
- Add claude config

### Changed

- Have snacks to list code actions
- Fix issue with ruff not starting
- Merge branch 'feature/lsp' into dev
- Ignore .config/claude folder
- Update treesitter to enable Python indent
- Update root for tmuxinator dotfiles settings
- Update tmuxinator settings
- Merge branch 'dev' into feature/lsp
- Improve lazygit config
- Load home manager environment vars
- Add yazi/theme.toml
- Improve lazygit config
- Add yazi settings
- Update lazygit config
- Update lua.lock
- Improve tmuxinator settings
- Comment out marksman
- Move lua_ls settings to other file
- Update lua plugins
- Update lazy-lock as of 2025-10-16
- Enable texlab lsp
- Update frontmatter.func
- Solve legacy commands warnings
- Fix issue betweeen obsidian lsp and navic
- Readd meow yearn nvim
- Comment obsidian running condition
- Moreve meow.yarn.nvim plugin
- Update obsidian nvim plugin
- Update nvim plugins
- Remove alias for claude
- Command out EOL and BOL nvim keymaps
- Fix bug with lazygit not having the ssh-gpg agent defined
- Fix issue with SSH_AUTH_SOCK be null
- Fixbug with stdout of gpg-connect
- Change personal tmuxinator settings
- Change tmuxinator for cv
- Change the root of the dotfiles
- Add vim moves with meh key
- Add MEH keys to tmux.conf
- Add better window navigatin in tmux
- Comment out env variables
- Merge branch 'feature/yazi.nvim' into dev
- Update lazy-lock
- Enable nvim to record macros
- Fix bug with SSH_AUTH_SOCK
- Change location of anthropic API in pass
- Fix bug with SSH_AUTH_SOCK defintion in .zshrc
- Add gnupg-agent.conf
- Change the history timestamp
- Add JIRA_API_TOKEN
- Merge branch 'feature/meow.yarn.nvim' into dev
- Add jira list command
- Add comment
- Update lazy-lock
- Fix bug with dap-python
- Add meow.yarn
- Merge branch 'feature/ssh_gpg' into dev
- Fix issue with ssh authentication and gpg
- Change the SSH_AUTH_SOCK without any if condition
- Fix issue with duplicated installations of the gpg
- Use gpg agent for authentification
- Merge branch 'feature/terminal_vim' into dev
- Update ghostty theme name
- Minor change to tmuxinator settings
- Update .gitconfig
- Change insert symbol in starship
- Change starship terminal characters
- Set vimmode in tmux
- Merge branch 'feature/nvim_snippets' into dev
- Fix bug with debugmaster lazy loading
- Merge branch 'feature/obsidian_calendar_view' into dev
- Completion is much better
- Update calendar formatting
- Improve calendar alignment
- Improve calendar with adding overlaping dates
- Update lazy-lock
- Improve neogen keymaps and descriptions
- Change keymap for togging undo tree
- Update karabiner settings
- Update completion with snippets
- Merge branch 'feature/nvim/text-case' into dev
- Improve description of keymap
- Changess to keymaps
- Improve description of the text-case keymap
- Update nvim plugins
- Merge branch 'feature/gitlab.nvim' into dev
- Add marksman to be installed by Mason
- Update lazy lock
- Update lazy lock
- Double tab left shift -> Caps Lock
- Update lazy.lock
- Correct yearmonth and year in obsidian.lua
- Update lazy plugins
- Add gitlab.nvim
- Merge branch 'feature/nvim/goto_preview' into dev
- Change hyperkey to go to browser
- Command out shortcuts that I am not using in tmux
- Change subcommand list
- Improve atuin defaults
- Update karabiner rules
- Further improvements to atuin
- Set enter to accept in atuin
- Set atuin to use workspaces
- Set atuin filter mode to directory
- Merge branch 'feature/nvim/debugmaster' into dev
- Set macos-option-as-alt true for ghostty
- Comment out keymaps to move code on lines
- Update lazy-lock and use dev branch
- Set vi copy mode in tmux.conf
- Update lazy plugins
- Change settings of debugmaster
- Merge branch 'feature/nvim/dart' into dev
- Change key mappings for dart.nvim
- Improve marklist for dart
- Improve dart keymaps
- Update lazy plugins
- Update nvim plugins
- Set lazy to false
- Delete bartender preferences file
- Update nvim plugins
- Change obsidian keymaps
- Merge branch 'feature/nvim/undo_redo_keymaps' into dev
- Change claude to local installation
- Defaults r keystroke to vim standard
- Merge tag '2025/W06' into dev

### Fixed

- Fix bug in atuin

### Removed

- Remove custom URL
- Remove all old lsp settings
- Remove stylua from null-ls
- Remove stylua from plugins/lsp/init.lua
- Remove texlab from lang/latex.lua
- Remove ruff lsp from land/python.lua
- Remove the dependency on the personal workspace
- Remove code-runner.nvim
- Remove dressing.nvim
- Remove numb.nvim
- Remove dial.nvim
- Remover dooing.nvim
- Remove telescope-recent-files plugins
- Remove menu neovim plugin
- Remove scroll-it neovim plugin
- Remove nvim dap and dapui references
- Remove dap and add debugmaster nvim plugin
- Remove harpoon.nvim
- Remove bufferline nvim plugin

# Changelog

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

![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/hsteinshiromoto/dotfiles?style=flat)
![LICENSE](https://img.shields.io/badge/license-MIT-lightgrey.svg)

# Dotfiles

My dotfiles.

## Structure

The structure of this repository mirrors the `$HOME` directory structure exactly. Files are placed in their target locations within the repo, then symlinked using `stow . --adopt`.

### Directory Overview

- **`.claude/`** - Claude Code configuration and project-specific settings
  - `skills/` - Claude skills (`graphify`, `ste_writing`)
  - `workflows/` - Claude workflow scripts (`debug-ticket`), see `.claude/workflows/README.md`
- **`.config/`** - Cross-platform application configurations
  - `amnesia/` - Terminal session persistence
  - `atuin/` - Shell history manager configuration
  - `bat/` - Syntax highlighting cat clone
  - `btop/` - Resource monitor configuration
  - `claude/` - Claude AI assistant settings
  - `espanso/` - Text expansion tool configuration
  - `eza/` - Modern `ls` replacement theme
  - `ghostty/` - Terminal emulator configuration
  - `karabiner/` - macOS keyboard customization (complex modifications and backups)
  - `kitty/` - Terminal emulator configuration
  - `lazygit/` - Git UI configuration
  - `nvim/` - Neovim configuration (see detailed structure below)
  - `opencode/` - OpenCode AI configuration (agents, commands, skills)
  - `television/` - Fuzzy finder/launcher configuration
  - `tmuxinator/` - Tmux session management
  - `yazi/` - File manager configuration
- **`.gnupg/`** - GnuPG configuration and keys
- **`.lima/`** - Linux virtual machine configurations
- **`.local/`** - User-specific binaries and data
  - `bin/` - User executable scripts
  - `share/` - User-specific application data
- **`.serena/`** - Serena AI project configuration
- **`.ssh/`** - SSH configuration and keys
- **`.stowrc`**, **`.stow-local-ignore`** - Stow configuration files
- **`.vscode/`** - VS Code extensions configuration
- **`bin/`** - Utility scripts and aliases
- **`macos/`** - macOS-specific configurations
  - `Library/Application Support/` - macOS application data
  - `Library/KeyBindings/` - macOS custom key bindings
  - `Library/Preferences/` - macOS application preferences
- **`utils/`** - Utility files and resources
  - `prompts/` - AI prompts and templates

### Neovim Structure

The Neovim configuration (`~/.config/nvim/`) uses a modular Lua-based structure:

```
nvim/
├── lsp/                    # LSP server configurations
├── scripts/                # Shell scripts called by the config (dashboard panes)
└── lua/
    ├── config/             # Core Neovim configurations
    ├── core/               # Core functionality
    ├── plugins/            # Plugin configurations
    │   ├── ai/             # AI-related plugins
    │   ├── colorscheme/    # Theme configurations
    │   ├── completion/     # Completion plugins
    │   ├── extras/         # Additional functionality
    │   │   ├── lang/       # Language-specific plugins
    │   │   ├── pde/        # Personal Development Environment
    │   │   │   └── notes/  # Note-taking (Obsidian, etc.)
    │   │   └── ui/         # UI enhancements
    │   │       ├── statuscol/   # Status column customization
    │   │       └── statusline/  # Statusline configuration
    │   ├── local/          # Local/custom plugins
    │   ├── server/         # Server-related plugins
    │   └── test/           # Testing plugins
    └── utils/              # Utility functions
```

## Requirements


## Workflow

### Stowing Files (Dotfiles → Home Directory)

Stow creates symlinks from your home directory to files in the repository. This allows you to manage your dotfiles in version control while they appear in their standard locations.

#### Stow All Files
```bash
stow .
```

#### Stow Specific Configuration Directory
To stow only a specific directory (e.g., `.config`):
```bash
stow .config
```

#### Stow with Adoption (Replace Existing Files)
If you have existing files in your home directory that conflict with stow, use the `--adopt` flag to replace them with symlinks:
```bash
stow . --adopt
```

This is useful when you already have configuration files in `~` that you want to move under stow management.

### Adopting Existing Files (Home Directory → Dotfiles)

To adopt existing files from your home directory into this dotfiles repository:

#### Step 1: Copy Files to Repository
Copy the files from your home directory to the correct location in the repo:
```bash
cp -r ~/.config/myapp .config/myapp
```

#### Step 2: Remove Original Files
Remove or rename the original files in your home directory to avoid conflicts:
```bash
rm -rf ~/.config/myapp
```

#### Step 3: Create Symlinks with Stow
Run stow to create symlinks back to the repository:
```bash
stow .config
```

Or stow everything:
```bash
stow .
```

#### Verification
Verify the symlink was created:
```bash
ls -la ~/.config/myapp
# Should show: lrwxr-xr-x -> /path/to/dotfiles.linux/.config/myapp
```

Or with readlink:
```bash
readlink ~/.config/myapp
# Should output: /Users/username/Projects/dotfiles.linux/.config/myapp
```

### Adding New Dotfiles

1. Create or copy the file to its target location in the repository:
```bash
touch .file
# or for config files:
cp -r ~/.config/app .config/app && rm -rf ~/.config/app
```

2. Create symlinks using stow:
```bash
stow . --adopt
```

3. Add file to version control:
```bash
git add .file
```

## Application-Specific Configuration

### Espanso - System-Wide Configuration

Espanso supports custom config directories via the `ESPANSO_CONFIG_DIR` environment variable. However, since Espanso runs as a macOS LaunchAgent (not from your shell), setting this variable in shell configs like `.zshrc` won't work for system-wide text expansion.

#### Making Config Work System-Wide

To use `~/.config/espanso` instead of the default `~/Library/Application Support/espanso`:

1. **Modify the LaunchAgent plist** at `~/Library/LaunchAgents/com.federicoterzi.espanso.plist`:

```xml
<key>EnvironmentVariables</key>
<dict>
    <key>PATH</key>
    <string>/usr/bin:/bin:/usr/sbin:/sbin</string>
    <key>ESPANSO_CONFIG_DIR</key>
    <string>/Users/YOUR_USERNAME/.config/espanso</string>
</dict>
```

2. **Reload Espanso**:

```bash
launchctl unload ~/Library/LaunchAgents/com.federicoterzi.espanso.plist
launchctl load ~/Library/LaunchAgents/com.federicoterzi.espanso.plist
# or simply
espanso restart
```

**Note**: The LaunchAgent plist file is managed by Espanso itself and should not be added to this dotfiles repo. Only the config files in `.config/espanso/` are managed by stow.

### Espanso - Date Snippets

The file `.config/espanso/match/dates.yml` holds offset-date matches. Type an offset such as
`-18d`, `+2w`, `-3m`, or `+5y`. Espanso replaces it with the date, in the format of one target:
Obsidian, bash, PowerShell, Python, or JavaScript.

#### Obsidian Note Links

The file `.config/espanso/match/obsidian.yml` holds matches that write a wikilink to a
periodic note. Each trigger starts with `;`, the same style as `git.yml`. Every match has a
short code, and most also have a longer alias.

| Trigger | Alias | Result on Sunday 2026-10-04 |
| --- | --- | --- |
| `;td` | `;today` | `[[2026-10-04\|today]]` |
| `;yd` | `;yesterday` | `[[2026-10-03\|yesterday]]` |
| `;tm` | `;tomorrow` | `[[2026-10-05\|tomorrow]]` |
| `;mon` … `;sun` | `;nextmon` … `;nextsun` | `;mon` gives `[[2026-10-05\|next monday]]` |
| `;lmon` … `;lsun` | `;lastmon` … `;lastsun` | `;lfri` gives `[[2026-10-02\|last friday]]` |
| `;wk` | `;week` | `[[2026-W40\|this week]]` |
| `;nwk` | `;nextweek` | `[[2026-W41\|next week]]` |
| `;lwk` | `;lastweek` | `[[2026-W39\|last week]]` |
| `;mth` | none | `[[2026-10\|this month]]` |
| `;qtr` | `;quarter` | `[[2026-Q4\|this quarter]]` |
| `;yr` | `;year` | `[[2026\|this year]]` |

The note names match both vaults and `~/.config/nvim/lua/plugins/obsidian.lua`: daily
`YYYY-MM-DD`, weekly `YYYY-Www` on the ISO week-year, monthly `YYYY-MM`, quarterly
`YYYY-Qn`, and yearly `YYYY`.

Three rules explain the shape of this table.

1. The old triggers `[[today]]` and `[[next monday]]` are gone. Obsidian adds `]]` for you
   when you type `[[`, and it opens the link suggester. You cannot type a bracketed trigger
   cleanly, and espanso then writes into an open popup. The replacement supplies its own
   brackets, so the old triggers cannot return as aliases.
2. No trigger is a prefix of another trigger. Espanso expands the shorter one as soon as it
   matches, which leaves the longer one dead. This is why `;month` does not exist: `;mon`
   comes first. Use `;mth`.
3. `;mon` through `;sun` never return today. BSD `date -v+mon` returns today when today is
   a Monday, so the old `[[next monday]]` linked to the note you were already in.

Do not add `word: true` to this file. Espanso fires a `right_word` trigger only after you
type a separator behind it, so `;td` would wait for a space.

#### Date Resolution Helper

The script `.config/espanso/scripts/obsidian_date.py` does all of the date arithmetic. Every
match calls it with one spec and wraps the single line of output in a wikilink.

```bash
python3 .config/espanso/scripts/obsidian_date.py today      # 2026-10-04
python3 .config/espanso/scripts/obsidian_date.py next:mon   # 2026-10-05
python3 .config/espanso/scripts/obsidian_date.py week-1     # 2026-W39
```

The script uses the standard library only, and it stays compatible with Python 3.9. The
espanso LaunchAgent runs with `PATH` set to `/usr/bin:/bin:/usr/sbin:/sbin`. The interpreter
is therefore `/usr/bin/python3`, and `uv` cannot be reached. An inline `date` call is not an
option either. The flag `date -v` works only on BSD, and `date -d` works only on GNU, and
this repository stows to both.

Run `make espanso-test` to check the script. The tests are doctests inside the docstrings.

## Favorite Commands

### Find

Find a file in the current directory
```bash
find . -type f -name "<filename>"
```

Run grep on every file returned by find
```bash
find . -type f -name "<filename>" -exec grep -n "<string>" -i /dev/null —color=always {} ';'
```

### Delta

Compare two files using delta and show the output side-by-side with line numbers
```bash
delta <file1> <file2> -sn

```


## Troubleshoot

### Atuin

If the you get the following issue with `atuin`, when trying to setup symlink to the config file:
```bash
$ ln -sf /Users/hsteinshiromoto/Projects/dotfiles.linux/.config/atuin /Users/hsteinshiromoto/.config

ln: /Users/hsteinshiromoto/.config/atuin: Operation not permitted
```

Use the following solution: Clean destination and check permissions
1. Check what exists at destination
```bash
ls -la ~/.config/atuin
```

2. Remove existing file/directory (backup first if needed)
```bash
rm -rf ~/.config/atuin
```

3. Ensure parent directory has correct permissions
```bash
chmod 755 ~/.config
```

4. Retry with absolute paths
```bash
ln -sf "$HOME/dotfile/.config/atuin" "$HOME/.config/atuin"
```

### References

[1] https://systemcrafters.net/managing-your-dotfiles/using-gnu-stow/
[2] https://www.youtube.com/watch?v=Z8BL8mdzWHI

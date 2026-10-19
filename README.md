![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/hsteinshiromoto/dotfiles?style=flat)
![LICENSE](https://img.shields.io/badge/license-MIT-lightgrey.svg)

# Dotfiles

This repository contains the user's configuration files. These files are place to their target location of each application by using symlinks with `gnustow`.

## Structure

The structure of this repository mirrors the `$HOME` directory structure exactly.

### Directory Overview

```shell
.
├── .claude                                 <- # Global Claude Code's settings
│   ├── agents
│   ├── commands
│   ├── hooks
│   ├── skills
│   └── workflows
├── .config                                 <- # $XDG_CONFIG configuration files
│   ├── amnesia
│   ├── atuin
│   ├── bat
│   ├── btop
│   ├── claude
│   ├── code-server
│   ├── espanso
│   │   ├── config
│   │   ├── match
│   │   └── scripts
│   ├── eza
│   ├── ghostty
│   │   └── themes
│   ├── hammerspoon                         <- # Hammerspoon configuration files (MacOS only)
│   ├── hypr                                <- # Hyprland configuration files (Linux only)
│   ├── karabiner                           <- # Karabiner elements configuration files (MacOS only)
│   │   ├── assets
│   │   │   └── complex_modifications
│   │   └── automatic_backups
│   ├── kitty
│   ├── lazygit
│   ├── mc                                  <- # Midnight Commander settings
│   ├── neofetch
│   ├── nvim                                <- # Neovim configuration folder
│   │   ├── lsp                             <- # LSP server configurations
│   │   ├── lua
│   │   │   ├── config                      <- # Core Neovim configurations
│   │   │   ├── core                        <- # Core functionality
│   │   │   ├── plugins                     <- # Plugin configurations
│   │   │   │   ├── ai
│   │   │   │   ├── colorscheme             <- # Theme configurations
│   │   │   │   ├── completion              <- # Completion plugins
│   │   │   │   ├── extras                  <- # Additional functionality
│   │   │   │   │   ├── lang                <- # Language-specific plugins
│   │   │   │   │   ├── pde                 <- # Personal Development Environment
│   │   │   │   │   │   └── notes           <- # Note-taking (Obsidian, etc.)
│   │   │   │   │   └── ui                  <- # UI enhancements
│   │   │   │   │       ├── statuscol       <- # Status column customization
│   │   │   │   │       └── statusline      <- # Statusline configuration
│   │   │   │   ├── local                   <- # Local/custom plugins
│   │   │   │   │   └── todo_picker
│   │   │   │   ├── server                  <- # Server-related plugins
│   │   │   │   └── test                    <- # Testing plugins
│   │   │   └── utils                       <- # Utility functions
│   │   ├── scripts                         <- # Shell scripts called by the config (dashboard panes)
│   │   └── snippets
│   ├── opencode
│   │   ├── agents
│   │   └── commands
│   ├── television
│   │   └── cable
│   ├── tmuxinator
│   └── yazi
│       └── flavors
│           └── tokyo-night.yazi
├── .gnupg                                  <- # Gnupg settings
├── .lima
│   └── default
├── .local
│   ├── bin
│   └── share
│       ├── code-server
│       └── mc
├── .ssh                                    <- # SSH settings
├── .vscode
├── bin
├── journal
├── macos
│   └── Library
│       ├── Application Support
│       │   ├── Code
│       │   └── espanso
│       │       ├── match
│       │       └── user
│       ├── KeyBindings
│       └── Preferences
├── utils
│   └── prompts                             <- # Do not stow this folder
├── .tmux.conf                              <- # Tmux settings file
└── .zshrc                                  <- # Z shell settings file
```

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

### Espanso - Base Snippets

The file `.config/espanso/match/base.yml` holds general snippets. Each trigger needs a word
boundary.

| Trigger | Result |
| --- | --- |
| `2day` | Today, as `YYYY-MM-DD` |
| `:yesterday:` | Yesterday, as `YYYY-MM-DD` |
| `:tomorrow:` | Tomorrow, as `YYYY-MM-DD` |
| `:uuid7:` | A new UUID version 7 |
| `:dname:` | A random Docker-style name, such as `eager_turing` |

`:yesterday:` and `:tomorrow:` call `date -v`, which is BSD only. These two triggers work on
macOS. They fail on Linux. The other three use `python3`.

### Espanso - Git Snippets

The file `.config/espanso/match/git.yml` holds git command prefixes. Each trigger starts
with `;`.

| Trigger | Result |
| --- | --- |
| `;ga` | `git add ` |
| `;gc` | `git commit -m ""` |
| `;gp` | `git push` |
| `;gt` | `git tag -a -m ""` |
| `;gff` | `git flow feature start ` |
| `;gfr` | `git flow release start ` |
| `;gfh` | `git flow hotfix start ` |
| `;gfb` | `git flow bugfix start ` |
| `;bf` | `[bugfix]` |

### Espanso - Typo Correction

The file `.config/espanso/match/typo.yml` corrects common English typos on a word boundary.
For example, `teh` becomes `the`. Read the file for the full list.

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

## Tmux

Tmux plugins are installed and maintained using TPM. Refer to `.tmux.conf`.

## ZSH

Zsh plugins are installed using `zgenom`. Refer to `.zshrc`

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

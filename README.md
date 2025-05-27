# dotfiles.linux

My Linux dotfiles.

## Structure

The structure of this repository must be the same as the structure as the config files in the `$HOME` folder.

```
.
├── .config
│   ├── bat
│   ├── btop
│   ├── code-server
│   ├── karabiner
│   ├── kitty
│   ├── mc
│   ├── neofetch
│   ├── nix-darwin
│   ├── nvim
│   │   └── lua
│   │       ├── config
│   │       ├── plugins
│   │       │   ├── ai
│   │       │   ├── colorscheme
│   │       │   ├── completion
│   │       │   ├── dap
│   │       │   ├── dashboard
│   │       │   ├── extras
│   │       │   │   ├── lang
│   │       │   │   ├── pde
│   │       │   │   │   └── notes
│   │       │   │   └── ui
│   │       │   │       ├── statuscol
│   │       │   │       └── statusline
│   │       │   ├── lsp
│   │       │   └── test
│   │       └── utils
│   └── tmuxinator
├── .local
│   ├── bin
│   └── share
│       ├── code-server
│       │   └── User
│       └── mc
│           └── skins
├── .vscode
│   └── extensions
├── bin
├── etc
├── keyboards
│   ├── BNR1
│   ├── bridge75
│   ├── epomaker
│   ├── melgeek
│   │   └── mojo84
│   ├── monsgeek
│   └── nuphy
├── macos
│   └── Library
│       ├── Application Support
│       │   ├── Code
│       │   │   └── User
│       │   └── espanso
│       │       ├── config
│       │       ├── match
│       │       │   └── packages
│       │       └── user
│       └── KeyBindings
├── roles
└── utils
    └── prompts
```

## Requirements


## Workflow

### New dotfile

1. Create an empty file in the correct location in the repository. For instance
```bash
touch .file
```
2. Run
```bash
stow . --adopt
```
3. Add file to the version control
```bash
git add .file
```

## Favorite Commands

### Find

Find a file in the current directory
```bash
find . -type f -name “<filename>”
```

Run grep on every file returned by find
```bash
find . -type f -name “<filename>” -exec grep -n “<string>” -i /dev/null —color=always {} ‘;’
```

### Delta

Compare two files using delta and show the output side-by-side with line numbers
```bash
delta <file1> <file2> -sn

```

### References

[1] https://systemcrafters.net/managing-your-dotfiles/using-gnu-stow/
[2] https://www.youtube.com/watch?v=Z8BL8mdzWHI

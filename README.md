# dotfiles

My dotfiles.

# Install

Run
```bash
./install
```

# Workflow

## New .dotfile

1. Create an empty file in the correct location in the repository.
2. Create the desired file in the config folder.
3. Run `$ stow . --adopt`
4. Add file to the version control.

# Repository Structure

Note that the structure of this repository must be the same as the structure as the config files in the `/home/user` folder.

```bash
.
├── .bashrc
├── .config
│   ├── btop
│   │   └── btop.conf
│   ├── kitty
│   │   ├── kitty.conf
│   │   ├── monokai_classic.conf
│   │   ├── monokai_machine.conf
│   │   ├── monokai_octagon.conf
│   │   ├── monokai_pro.conf
│   │   ├── monokai_ristretto.conf
│   │   └── monokai_spectrum.conf
│   └── mc
│       ├── hotlist
│       ├── ini
│       ├── mc.ext
│       ├── mc.ext.ini
│       └── panels.ini
├── .gnupg
│   ├── gpg-agent.conf
│   └── gpg.conf
├── .ssh
│   └── config.template
├── .stow-local-ignore
├── .tmux.conf
├── .vimrc
├── .zshrc
├── Brewfile
├── LICENSE
├── Library
│   └── Application Support
│       ├── Code
│       │   └── User
│       │       └── settings.json
│       └── espanso
│           ├── config
│           │   └── default.yml
│           ├── match
│           │   ├── base.yml
│           │   ├── git.yml
│           │   ├── obsidian.yml
│           │   └── packages
│           └── user
├── Makefile
├── README.md
└── dotfiles.code-workspace
```

# Known Bugs

## Copy from tmux terminal in VSCode

- VSCode does not copy the text from tmux terminal by simply selecting it. In MacOS, it is necessary [to hold the Option key while selecting it](https://unix.stackexchange.com/questions/757939/cannot-copy-text-from-tmux-integrated-terminal-in-update-1-82-2) to get it copied.
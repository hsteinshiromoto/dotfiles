SHELL:=/bin/bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)

.PHONY: btop homebrew kitty mc shell vscode ssh tmux

all: btop homebrew kitty mc shell vscode ssh tmux

btop:
	@echo "Backing up btop ..."
	bash bin/btop.sh
	@echo "Done."

homebrew:
	@echo "Backing up homebrew ..."
	brew bundle dump
	@echo "Done."

kitty:
	@echo "Backing up kitty ..."
	bash bin/kitty.sh
	@echo "Done."

mc:
	@echo "Backing up Midnight Commander ..."
	bash bin/mc.sh
	@echo "Done."

shell:
	@echo "Backing up shell profiles ..."
	bash bin/shell.sh
	@echo "Done."

vscode:
	@echo "Backing up VSCode ..."
	bash bin/vscode.sh
	@echo "Done."

ssh:
	@echo "Backing up SSH config..."
	bash bin/ssh.sh
	@echo "Done."

tmux:
	@echo "Backing up tmux config..."
	bash bin/tmux.sh
	@echo "Done."

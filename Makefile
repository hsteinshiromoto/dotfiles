SHELL:=/bin/bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)

.PHONY: btop homebrew kitty mc shell vscode ssh tmux

all: btop homebrew kitty mc shell vscode ssh tmux

homebrew:
	@echo "Backing up homebrew ..."
	brew bundle dump
	@echo "Done."

vscode:
	@echo "Backing up vscode settings ..."
	$(eval VSCODE_SETTINGS_DIR := ${HOME}/Library/Application\ Support/Code/User)
	cp ${VSCODE_SETTINGS_DIR}/settings.json . 
	@echo "Done."
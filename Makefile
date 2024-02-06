SHELL:=/bin/bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)

.PHONY: homebrew vscode all delete

all:
        stow --verbose 3 --restow .

homebrew:
	@echo "Backing up homebrew ..."
	brew bundle dump
	@echo "Done."

vscode:
	@echo "Backing up vscode settings ..."
	$(eval VSCODE_SETTINGS_DIR := Library/Application\ Support/Code/User)
	cp ${HOME}/${VSCODE_SETTINGS_DIR}/settings.json ${VSCODE_SETTINGS_DIR}
	@echo "Done."
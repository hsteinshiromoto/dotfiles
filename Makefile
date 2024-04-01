SHELL:=/bin/bash

default: ansible

PROJECT_ROOT=$(git rev-parse --show-toplevel)

.PHONY: homebrew vscode all delete

ansible:
	bash bin/install.sh

all:
	stow --verbose 3 .

homebrew:
	@echo "Backing up homebrew ..."
	brew bundle dump
	@echo "Done."

vscode:
	@echo "Backing up vscode settings ..."
	$(eval VSCODE_SETTINGS_DIR := Library/Application\ Support/Code/User)
	cp ${HOME}/${VSCODE_SETTINGS_DIR}/settings.json ${VSCODE_SETTINGS_DIR}
	@echo "Done."

adopt:
	stow --adopt .

tree:
	tree -a -I .git -I .DS_Store -I .gitignore -I .github

install:
	ansible-playbook --ask-become-pass bootstrap.yml --check
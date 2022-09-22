SHELL:=/bin/bash

.PHONY: homebrew vscode

shell:
	@echo "Backing up shell profiles ..."
	bash bin/shell.sh
	@echo "Done."

homebrew:
	@echo "Backing up homebrew ..."
	bash bin/homebrew.sh
	@echo "Done."

vscode:
	@echo "Backing up VSCode ..."
	bash bin/vscode.sh
	@echo "Done."
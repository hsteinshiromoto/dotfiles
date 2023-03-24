SHELL:=/bin/bash

.PHONY: btop homebrew kitty mc shell vscode ssh

all: btop homebrew kitty mc shell vscode

btop:
	@echo "Backing up btop ..."
	bash bin/btop.sh
	@echo "Done."

homebrew:
	@echo "Backing up homebrew ..."
	bash bin/homebrew.sh
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

SHELL:=/bin/bash

.PHONY: homebrew

backup:
	@echo "Backing up shell profiles ..."
	bash bin/shell.sh
	@echo "Done."

homebrew:
	@echo "Backing up homebrew ..."
	bash bin/homebrew.sh
	@echo "Done."
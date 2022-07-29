SHELL:=/bin/bash


backup:
	@echo "Backing up shell profiles ..."
	bash bin/shell.sh
	@echo "Done."

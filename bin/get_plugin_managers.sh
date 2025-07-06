#!/usr/bin/env bash

# ---
# Functions
# ---

# Documentation
function display_help() {
    echo "Usage: [variable=value] $0" >&2
    echo
    echo "   -a, --all      Runs all functions"
		echo "   -t, --tpm      Installs tmux plugin manager (TPM)"
    echo "   -h, --help     Display help"
    echo "   -z, --zgenom   Installs zsh zgenom plugin manager"
    echo
}

function zgenom() {
	echo "Installing zgenom ..."
	if [ -z "$(ls -A ${HOME}/.zgenom)" ]; then
		git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"
	else
		echo "zgenom already exists in ${HOME}/.zgenom skipping ..."
	fi

	echo "Done."
}

function tpm() {
	echo "Installing tmux plugin manager (TPM) ..."
	if [ -z "$(ls -A ${HOME}/.tmux/plugins/tpm)" ]; then
		git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
	else
		echo "tpm already exists in ${HOME}/.tmux/plugins/tpm skipping ..."
	fi

	echo "Done."
}

function all() {
	echo "Running all functions ..."
	tpm
	zgenom
	echo "Done."
}

# Available options
while :
do
    case "$1" in
				-a | --all)
            all
            exit 0
            ;;

        -z | --zgenom)
            zgenom
            exit 0
            ;;

        -h | --help)
            display_help
            exit 0
            ;;


        -t | --tpm)
            tpm
            exit 0
            ;;

       "")
            display_help  # Call your function
            break
            ;;

        --) # End of all options
            shift
            break
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            ## or call function display_help
            exit 1
            ;;

      *)  # No more options
            break
            ;;
    esac
done

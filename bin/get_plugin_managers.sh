#!/usr/bin/env bash

# ---
# Functions
# ---

# Documentation
display_help() {
    echo "Usage: [variable=value] $0" >&2
    echo
    echo "   -t, --tpm      tmux plugin manager"
    echo "   -h, --help     display help"
    echo "   -z, --zgenom   zgenom plugin manager"
    echo
    # echo some stuff here for the -a or --add-options
    exit 1
}

zgenom() {
	git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"
}

tpm() {
	git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
}

# Available options
while :
do
    case "$1" in
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

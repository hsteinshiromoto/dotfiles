#!/usr/bin/env bash

# ---
# Functions
# ---

# Documentation
display_help() {
    echo "Usage: [variable=value] $0" >&2
    echo
    echo "   -b, --build_essentials     Build Essentials"
    echo "   -h, --help                 Display Help"
    echo
    # echo some stuff here for the -a or --add-options
    exit 1
}

make_variables() {
    if [[ $1 == "l" ]]; then
        OS="linux"

    else
        OS="macos"

    fi
}

build_essentials() {
    
    make_variables

    if [[ $OS == "macos" ]]; then
        # Install homebrew
        (cd ~/Downloads && bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")
        (bash ~/Downloads/install.sh)
        bash brew.sh
    fi
}

bash oh_my_zsh.sh
bash docker.sh

# Available options
while :
do
    case "$1" in
        -b | --build_essentials)
            build_essentials
            exit 0
            ;;

        -h | --help)
            display_help
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
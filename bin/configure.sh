#!/bin/bash

# References:
#     [1] https://github.com/TechDufus/dotfiles/blob/main/bin/dotfiles


DOTFILES_LOG="$HOME/dotfiles/dotfiles.log"

set -e

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ $machine == "Mac" ]; then

    export $(grep -v '^#' paths.env | xargs -0) 1> /dev/null
    export $(grep -v '^#' colors.env | xargs -0) 1> /dev/null
    export $(grep -v '^#' emoji.env | xargs -0) 1> /dev/null

elif [ $machine == "Linux" ]; then

    export $(grep -v '^#' paths.env | xargs -d '\n')
    export $(grep -v '^#' colors.env | xargs -d '\n')
    export $(grep -v '^#' emoji.env | xargs -d '\n')

fi

# Paths
VAULT_SECRET="$HOME/.ansible-vault/vault.secret"
IS_FIRST_RUN="$HOME/.dotfiles_run"

source base.sh

if ! [[ -d "$DOTFILES_DIR" ]]; then
  _task "Cloning repository"
  _cmd "git clone --quiet git@github.com:hsteinshiromoto/dotfiles.git $DOTFILES_DIR"
else
  _task "Updating repository"
  _cmd "git -C $DOTFILES_DIR pull --quiet"
fi
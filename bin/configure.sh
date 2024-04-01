#!/bin/bash

# References:
#     [1] https://github.com/TechDufus/dotfiles/blob/main/bin/dotfiles

source base.sh


if ! [[ -d "$DOTFILES_DIR" ]]; then
  _task "Cloning repository"
  _cmd "git clone --quiet git@github.com:hsteinshiromoto/dotfiles.git $DOTFILES_DIR"
else
  _task "Updating repository"
  _cmd "git -C $DOTFILES_DIR pull --quiet"
fi
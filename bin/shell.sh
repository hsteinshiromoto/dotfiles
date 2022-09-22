#!/usr/bin/env bash

echo "Backing up zshrc ..."
PROJECT_ROOT=$(git rev-parse --show-toplevel)
cp ~/.zshrc ${PROJECT_ROOT}/zsh
echo "Done!"

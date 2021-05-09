#!/usr/bin/env bash

(cd ~/Downloads && bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")
(bash ~/Downloads/install.sh)

bash brew.sh
bash oh_my_zsh.sh
bash docker.sh
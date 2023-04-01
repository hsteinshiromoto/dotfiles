#!/usr/bin/env bash

make_variables(){
    PROJECT_ROOT=$(git rev-parse --show-toplevel)
}

get(){
    for file in ini mc.ext mc.ext.ini panels.ini hotlist
    do
        echo copying ${file}
        cp ~/.config/mc/${file} ${PROJECT_ROOT}/mc
    done
}

set(){
    # [1] clone anywhere you like, but adjust paths as needed
    mkdir ~/.config/mc/dracula-theme && cd ~/.config/mc/dracula-theme
    git clone https://github.com/dracula/midnight-commander.git

    mkdir -p ~/.local/share/mc/skins && cd ~/.local/share/mc/skins
    ln -s ~/.config/mc/dracula-theme/midnight-commander/skins/dracula.ini
    ln -s ~/.config/mc/dracula-theme/midnight-commander/skins/dracula256.ini

}

# References:
# [1] https://draculatheme.com/midnight-commander
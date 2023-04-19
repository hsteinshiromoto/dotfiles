#!/usr/bin/env bash

make_variables(){
    PROJECT_ROOT=$(git rev-parse --show-toplevel)
}

get(){
    echo "Copying .zshrc ..."
    cp ~/.zshrc ${PROJECT_ROOT}/zsh
    echo "Done"
}

set(){
    echo "Installing Oh-my-zosh ..."
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "Done"

    echo "Copying .zshrc ..."
    cp ${PROJECT_ROOT}/zsh/.zshrc ~
    echo "Done"
}

# References:
# [1] https://medium.com/featurepreneur/how-to-apply-agnoster-theme-in-mac-zshrc-876f3baf8bf
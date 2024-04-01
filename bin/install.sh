#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

set +e
PROJECT_ROOT=$(git rev-parse --show-toplevel)

if [ $machine == "Mac" ]; then
    echo "Running on Mac"
    # Install Homebrew
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sudo bash
    # Install Ansible
    brew install ansible

elif [ $machine == "Linux" ]; then
    _task "Running on Linux"
    # Install Ansible
    sudo apt update
    sudo apt install ansible

else
    echo "Unsupported OS"
fi

ansible-galaxy install -r ${PROJECT_ROOT}/ansible-requirements.txt
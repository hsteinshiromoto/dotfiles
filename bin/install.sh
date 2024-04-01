#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    MSYS_NT*)   machine=Git;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ $machine == "Mac" ]; then
    echo "Running on Mac"
    # Install Homebrew
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sudo bash
    # Install Ansible
    brew install ansible
    # Add Ansible to PATH
    ansible-galaxy install -r ansible-requirements.yml
    
elif [ $machine == "Linux" ]; then
    echo "Running on Linux"
    # Install Ansible
    sudo apt update
    sudo apt install ansible
    # Install Ansible roles
    ansible-galaxy install -r ansible-requirements.yml
else
    echo "Unsupported OS"
fi


# pip3 install ansible

# export PATH="$PATH:~/.local/bin"
# ansible-galaxy install -r ansible-requirements.yml
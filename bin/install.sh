#!/bin/bash

# References:
#     [1] https://github.com/TechDufus/dotfiles/blob/main/bin/dotfiles

set -e
# ---
# Color Codes
# ---
RESTORE='\033[0m'
NC='\033[0m'
BLACK='\033[00;30m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
SEA="\\033[38;5;49m"
LIGHTGRAY='\033[00;37m'
LBLACK='\033[01;30m'
LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'
OVERWRITE='\e[1A\e[K'

# ---
# Emoji Codes
# ---
CHECK_MARK="${GREEN}\xE2\x9C\x94${NC}"
X_MARK="${RED}\xE2\x9C\x96${NC}"
PIN="${RED}\xF0\x9F\x93\x8C${NC}"
CLOCK="${GREEN}\xE2\x8C\x9B${NC}"
ARROW="${SEA}\xE2\x96\xB6${NC}"
BOOK="${RED}\xF0\x9F\x93\x8B${NC}"
HOT="${ORANGE}\xF0\x9F\x94\xA5${NC}"
WARNING="${RED}\xF0\x9F\x9A\xA8${NC}"
RIGHT_ANGLE="${GREEN}\xE2\x88\x9F${NC}"

# ---
# Paths
# ---
CONFIG_DIR="$HOME/.config/dotfiles"
DOTFILES_DIR="$HOME/dotfiles"
SSH_DIR="$HOME/.ssh"
DOTFILES_LOG="$HOME/dotfiles/dotfiles.log"

# ---
# Auxiliar Functions
# ---
function _task {
  # if _task is called while a task was set, complete the previous
  if [[ $TASK != "" ]]; then
    printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"
  fi
  # set new task title and print
  TASK=$1
  printf "${LBLACK} [ ]  ${TASK} \n${LRED}"
}

# _cmd performs commands with error checking
function _cmd {
  #create log if it doesn't exist
  if ! [[ -f $DOTFILES_LOG ]]; then
    touch $DOTFILES_LOG
  fi
  # empty conduro.log
  > $DOTFILES_LOG
  # hide stdout, on error we print and exit
  if eval "$1" 1> /dev/null 2> $DOTFILES_LOG; then
    return 0 # success
  fi
  # read error from log and add spacing
  printf "${OVERWRITE}${LRED} [X]  ${TASK}${LRED}\n"
  while read line; do
    printf "      ${line}\n"
  done < $DOTFILES_LOG
  printf "\n"
  # remove log file
  rm $DOTFILES_LOG
  # exit installation
  exit 1
}

function _clear_task {
  TASK=""
}

function _task_done {
  printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"
  _clear_task
}

# ---
# Main
# ---
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# Check if Homebrew is installed
function check_brew {
    if [[ $(command -v brew) == "" ]]; then
        echo "Installing Hombrew"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Updating Homebrew"
        brew update
    fi
}

# Check if dotfiles directory exists
if ! [[ -d "$DOTFILES_DIR" ]]; then
  _task "Cloning repository"
  _cmd "git clone --quiet git@github.com:hsteinshiromoto/dotfiles.git $DOTFILES_DIR"
else
  _task "Updating repository"
  _cmd "git -C $DOTFILES_DIR pull --quiet"
fi

# Install Ansible on Different Machines
if [ $machine == "Mac" ]; then
    # Install Homebrew
    _task "Check if homebrew is installed"
    _cmd "check_brew"
    # Install Ansible

    _task "Installing Ansible"
    _cmd "brew install ansible"

elif [ $machine == "Linux" ]; then
    _task "Running on Linux"
    # Install Ansible
    sudo apt update
    sudo apt install ansible

else
    echo "Unsupported OS"
fi

# Install Ansible roles
_task "Install Ansible Roles"
_cmd "ansible-galaxy install -r $DOTFILES_DIR/ansible-requirements.yml"; _task_done
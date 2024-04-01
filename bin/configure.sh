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

if ! [[ -d "$DOTFILES_DIR" ]]; then
  _task "Cloning repository"
  _cmd "git clone --quiet git@github.com:hsteinshiromoto/dotfiles.git $DOTFILES_DIR"
else
  _task "Updating repository"
  _cmd "git -C $DOTFILES_DIR pull --quiet"
fi
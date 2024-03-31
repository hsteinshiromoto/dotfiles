#!/bin/bash

set -e

pip3 install ansible

export PATH="$PATH:~/.local/bin"
ansible-galaxy install -r ansible-requirements.yml
ansible-galaxy role install gantsign.visual-studio-code
#!/usr/bin/env bash

# ---
# This Scripts extracts all public keys from the Yubikey
# ---
counter=1 && \
  ssh-add -L | while read -r key; do \
    echo "$key" > ~/.ssh/yubikey_key_${counter}.pub; \
    echo "Saved key $counter to ~/.ssh/yubikey_key_${counter}.pub"; \
    counter=$((counter + 1)); \
  done

#!/usr/bin/env bash

# Install Brew Packages
brew install gpg
brew install pinentry-mac #To be used with gpg
brew install python
brew install tree
brew install wget
brew install zsh

# Install MacOS Applications
brew install --cask bitwarden
brew install --cask docker
brew install --cask firefox
brew install --cask iterm2
brew install --cask notion
brew install --cask pocket-casts
brew install --cask protonvpn
brew install --cask signal
brew install --cask spotify
brew install --cask sublime-merge
brew install --cask xquartz
brew install --cask visual-studio-code

# Fonts
brew tap homebrew/cask-Fonts
brew install --cask font-source-code-pro

# Xfig
brew tap mistydemeo/homebrew-xfig
brew install xfig
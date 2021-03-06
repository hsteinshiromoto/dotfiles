#!/usr/bin/env bash

# Install Brew Packages
brew install automake
brew install cask
brew install cmake
brew install git
brew install gpg
brew install python@3.9
brew install pinentry-mac #To be used with gpg
brew install python
brew install texlive
brew install tree
brew install vim
brew install wget
brew install zsh

# ---
# Casks
# ---
brew install --cask adobe-acrobat-reader
brew install --cask alfred
brew install --cask bartender
brew install --cask bettertouchtool
brew install --cask bibdesk
brew install --cask bitwarden
brew install --cask boxcryptor
brew install --cask daisydisk
brew install --cask dbeaver-community
brew install --cask docker
brew install --cask drawio
brew install --cask dropbox
brew install --cask firefox
brew install --cask gpg-suite
brew install --cask inkscape
brew install --cask istat-menus
brew install --cask iterm2
brew install --cask microsoft-office
brew install --cask notion
brew install --cask obsidian
brew install --cask pocket-casts
brew install --cask popclip
brew install --cask protonvpn
brew install --cask signal
brew install --cask slack
brew install --cask spotify
brew install --cask standard-notes
brew install --cask steam
brew install --cask sublime-merge
brew install --cask the-unarchiver
brew install --cask transmission
brew install --cask virtualbox
brew install --cask visual-studio-code
brew install --cask vlc
brew install --cask waterfox
brew install --cask whatsapp
brew install --cask xquartz

# ---
# Other Installations
# ---

# Fonts
brew tap homebrew/cask-Fonts
brew install --cask font-source-code-pro

# Xfig
brew tap mistydemeo/homebrew-xfig
brew install xfig
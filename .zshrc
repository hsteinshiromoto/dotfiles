# ---
# Aliases
# ---
source bin/cli_alias.sh

# ---
# User configuration: gpg
# ---
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

# ---
# Load Pyenv automatically
# ---
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval "$(starship init zsh)"

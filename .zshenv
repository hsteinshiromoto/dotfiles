# ---
# Keep $path and $fpath free of duplicates.
#
# nix-darwin's /etc/zshenv prepends three directories per entry in
# $NIX_PROFILES on every shell, and zsh exports FPATH (export -T FPATH fpath).
# A nested shell therefore inherits an already-prepended $fpath and prepends
# again: ghostty -> `zsh -c "tmux attach"` -> tmux -> login zsh grew $fpath to
# 44 entries for 19 unique directories.
#
# That broke the completion cache permanently. compdump counts completion files
# over the raw $fpath (1525), while compaudit - which feeds compinit's cache
# check - counts over a de-duplicated copy (1327, see compaudit:45,
# `local -a -U +h fpath`). The two counts can never agree while $fpath holds
# duplicates, so compinit discarded ~/.zcompdump and rebuilt it on every single
# shell start. That alone cost 6-8 s per prompt.
#
# This file is the right home for the fix, not .zshrc: zsh reads ~/.zshenv
# before /etc/zshrc, which is where nix-darwin runs its own compinit.
#
# References:
# 	[1] /usr/share/zsh/5.9/functions/compdump:26
# 	[2] /usr/share/zsh/5.9/functions/compaudit:45,62
# 	[3] /usr/share/zsh/5.9/functions/compinit:489
# ---
typeset -U path fpath

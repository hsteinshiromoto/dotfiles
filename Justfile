# Start isolated claude code session. Usage: just claude [options]
claude config_dir="~/tmp/.claude claude":
	NIXPKGS_ALLOW_UNFREE=1 nix shell --impure nixpkgs#claude-code --command sh -c 'CLAUDE_CONFIG_DIR={{config_dir}} claude'

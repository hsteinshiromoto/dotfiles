return {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_markers = {
		".git",
		"flake.nix",
		"shell.nix",
		"default.nix",
		"flake.lock",
	},
	single_file_support = true,
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			formatting = {
				command = { "nixfmt" },
			},
			options = {
				nixos = {
					expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.example.options',
				},
				home_manager = {
					expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."user@example".options',
				},
			},
		},
	},
}
# Journal Summary

## 2026-05-13 — Add get_sorted_data Neovim Python Snippet

Added a new Python snippet `get_sorted_data` to `.config/nvim/snippets/python.json` with prefix `sorted_data`. The snippet:
- Finds files matching a regex pattern in a directory
- Sorts them (descending by default) and selects by index
- Has fixed docstring Args (user's original had mismatched parameters)
- Includes doctests using `Path.touch()` demonstrating sorting behavior with verifiable expected outputs

## 2026-04-28 — NixOS Server Neovim Startup Errors (4 fixes)

Debugged and fixed four issues on the NixOS server:
1. **image.nvim luarocks failure** — disabled image feature in `snacks.lua` and added `rocks = { enabled = false }` to `lazy.lua` to prevent luarocks builds entirely.
2. **`make ts` API mismatch** — updated `Makefile` `ts` target to use the new nvim-treesitter `main` branch API: `require('nvim-treesitter').update(nil, {...}):wait()`.
3. **obsidian.nvim workspace error** — uncommented the `cond = vim.fn.isdirectory(".obsidian") == 1` guard in `obsidian.lua` so the plugin only loads inside a vault.
4. **Treesitter `tab` node query error on `:`** — added `cmdline.format` override in `noice.lua` to disable treesitter parsing for the cmdline, bypassing a Neovim 0.12.1 query/parser mismatch.

## 2026-04-27 — Neovim Tree-sitter Nix parser mismatch

Debugged a `noice.nvim` query error (`Invalid field name "operator"`) appearing when opening `.nix` files. Root cause: `lazy.nvim` updated `nvim-treesitter` but did not recompile the `nix.so` parser, leaving a grammar/query version mismatch. `:TSUpdate nix` falsely reported "up-to-date". Fixed by running `:TSInstall! nix` to force recompilation. No repository files were modified.

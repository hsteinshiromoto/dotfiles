# Journal Summary

A running summary of changes to this repository, newest first.

## 2026-10-04

Retriggered `.config/espanso/match/obsidian.yml`. The ten `[[today]]`-style matches became
23 matches behind `;` short codes, each with a longer alias, and now covering weekly,
monthly, quarterly and yearly notes as well as daily. A bracketed trigger cannot be typed
cleanly in Obsidian, because `[[` auto-inserts `]]` and opens the link suggester. Two
espanso behaviours shaped the result and were read out of the source rather than assumed:
`word: true` sets `right_word`, which fires only once a separator arrives **after** the
trigger (`espanso-match/src/rolling/matcher.rs`), so `;td` would have waited for the space
bar — dropping it also matches `match/git.yml`; and espanso expands the shorter of two
prefix-sharing triggers eagerly (espanso#178), which is a hard constraint, and which is why
`;month` cannot exist alongside `;mon`. All 59 triggers across the three match files were
checked for prefix collisions mechanically. The ten inline `date -v` calls collapsed into
`.config/espanso/scripts/obsidian_date.py`, stdlib-only and 3.9-compatible because the
LaunchAgent `PATH` reaches only `/usr/bin/python3`. `date -v` is BSD-only and `date -d` is
GNU-only, so neither can live in a repo that stows to both. The resolver also fixes a real
bug: BSD `date -v+mon` returns today on a Monday, so `[[next monday]]` linked to the note
you were already in. 33 doctests run via a new `make espanso-test`. Separately, `dates.yml`
was found to be broken in six ways and espanso logs a regex error for it at every start
(`(?p<` with a lowercase p); left alone as out of scope. See [2026-10-04.md](2026-10-04.md).

## 2026-10-02

Runtime pinentry switching in `.zshrc`: `ykt` (terminal), `ykg` (GUI), `ykd` (drop the
override), `ykp` (report). One function, `_pinentry_set`, writes a single
`pinentry-program` line to `~/.gnupg/gpg-agent.conf` and runs `gpgconf --reload
gpg-agent`. Two facts from `agent/gpg-agent.c` make it work and were read rather than
assumed: `pinentry-program` is in `parse_rereadable_options`, so a reload suffices and
the cached PIN and ssh sockets survive; and gpg-agent parses the system config before
the user config, so the user file wins. This replaces the six-step second-agent recipe
in the nix repo (`modules/features/nixos/yubikey.nix:43-55`), which stays as the
fallback for a wedged agent. **The override outlives the shell and the reboot**, so
`ykd` is not optional — curses left in force gives the sops-nix user service no terminal
and fails as `0 successful groups required, got 0`. A self-detecting wrapper was ruled
out: `$DISPLAY` and `$GPG_TTY` reach pinentry over ASSUAN after the exec, not through
its environment.

## 2026-09-29

- Added `.config/nvim/lua/utils/obsidian_template.lua`, a bridge from Neovim to the Notes vault's own template renderer. The vault writes its templates in Templater syntax (`<% %>`) and obsidian.nvim reads `{{key}}` only, so `:Obsidian template` inserted the tags verbatim and seven prompting templates were unusable outside Obsidian. The bridge finds the vault by walking up to `.obsidian`, asks `bin/render_template.py --describe` which prompts a template declares, collects the answers with `vim.fn.input`, and renders with `--var` and `--json`. It reads Templater's own folder map so both apps file a note in the same place, and it prefers the vault `.venv` but falls back to `python3`. `<localleader>ot` and `<localleader>on` now call `:ObsidianTemplate` and `:ObsidianNoteFromTemplate`. Fifteen headless checks pass against a sandbox vault. See [2026-09-29.md](2026-09-29.md).

## 2026-09-17

- Turned `summarize-meeting` into a three-phase Workflow script, `.claude/workflows/summarize-meeting.js`. Phase Read finds the source (a stub note in the vault, a transcript file, or today's schedule) and returns the meeting facts. Phase Minutes writes the Obsidian note and links it in the daily note. Phase Tasks adds every action item to `~/Notes/todo.txt` with `tuxedo add`. `.claude/commands/summarize-meeting.md` became a launcher. The opencode copy gained the same tuxedo step, self-contained. See [2026-09-17.md](2026-09-17.md).

## 2026-09-06

- Compared `release/2026-W37` against `main` (26 commits, 27 files) and documented the branch. Added the `## [3.1.0] - 2026-09-06` section to `CHANGELOG.md`. Updated `README.md`: the `.claude/skills/` and `.claude/workflows/` entries, the `scripts/` entry in the Neovim tree, and a new `### Espanso - Date Snippets` section. See [2026-09-06.md](2026-09-06.md).

## 2026-08-14

- Added an `AWS login` phase to the `debug-ticket` workflow in `.claude/workflows/debug-ticket.js`, between Triage and CloudWatch. It maps the ticket environment to one of the eight profiles in `~/.aws/config`, tests the session with `aws sts get-caller-identity`, and runs `aws sso login --profile <env>` only when needed. A failed login stops the workflow with `status: "aws_login_required"` rather than querying CloudWatch with dead credentials. Added five AWS permissions to `.claude/settings.local.json`. See [2026-08-14.md](2026-08-14.md).

## 2026-08-13

- Added CloudWatch as the second phase of the `debug-ticket` workflow in `.claude/workflows/debug-ticket.js`. The new phase queries `aws logs filter-log-events` using triage facts (component, environment, errors, reported date) and threads findings through all downstream agents (lenses, skeptics, report). The phase is non-blocking: missing AWS credentials are recorded and the workflow continues. See [2026-13-08.md](2026-13-08.md).

## 2026-08-12

- Added a `### Unix Philosophy` subsection to `## Code Development Standards` in `.claude/CLAUDE.md`. Eight rules cover composition, plain text, scriptability, silence, loud failure, prototyping, and simplicity. The file is staged in git. See [2026-08-12.md](2026-08-12.md).

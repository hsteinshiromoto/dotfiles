#!/usr/bin/env python3
"""Regression tests for .claude/skills/humanize/unslop.py.

Lives in utils/ because .stow-local-ignore keeps that directory out of the
stow link set: a test file under .claude/skills/humanize/ would be linked into
~/.claude/skills/humanize/ and offered to the agent as part of the skill.

Run: python3 utils/test_unslop.py
"""

from __future__ import annotations

import importlib.util
import subprocess
import sys
import tempfile
from pathlib import Path

SCRIPT = Path(__file__).resolve().parent.parent / ".claude/skills/humanize/unslop.py"

spec = importlib.util.spec_from_file_location("unslop", SCRIPT)
if not spec or not spec.loader:
    raise SystemExit(f"cannot load {SCRIPT}")
unslop = importlib.util.module_from_spec(spec)
spec.loader.exec_module(unslop)

failures: list[str] = []


def check(name: str, got, want) -> None:
    if got != want:
        failures.append(f"{name}\n    got:  {got!r}\n    want: {want!r}")


def clean(text: str) -> str:
    return unslop.process(text, False)[0]


def found(text: str) -> dict:
    return unslop.process(text, False)[1]


# --- character tables ------------------------------------------------------
# Typed as literals, so a duplicate key would be silently dropped.
check("TRANSLATE size", len(unslop.TRANSLATE), 23)
check("primes absent from TRANSLATE", "′" in unslop.TRANSLATE, False)
check("double prime absent", "″" in unslop.TRANSLATE, False)
check("JOINERS", sorted(unslop.JOINERS), ["‌", "‍"])
check("REPORT_ONLY", sorted(unslop.REPORT_ONLY), ["–", "—"])

# --- normalisation ---------------------------------------------------------
check("curly quotes", clean("say “hi” and it’s"), 'say "hi" and it\'s')
check("ellipsis", clean("wait…"), "wait...")
check("nbsp", clean("5 km"), "5 km")
check("zero-width space", clean("a​b"), "ab")
check("em dash untouched", clean("a — b"), "a — b")
check("en dash untouched", clean("1900–1910"), "1900–1910")
check("prime untouched", clean("37°48′27″S"), "37°48′27″S")

# --- residue ---------------------------------------------------------------
check(
    "contentReference",
    clean("text :contentReference[oaicite:3]{index=3} end"),
    "text end",
)
check("utm_source", clean("https://x.com/a?utm_source=chatgpt.com&b=2"), "https://x.com/a?b=2")
check("placeholder bracket", clean("by [Your Name] here"), "by here")

# False positives the council found: these are ordinary technical prose.
check(
    "attached_file is a field name",
    clean("The API field attached_file holds it."),
    "The API field attached_file holds it.",
)
check(
    "INSERT_OR_REPLACE is SQL",
    clean("Use INSERT_OR_REPLACE in SQLite."),
    "Use INSERT_OR_REPLACE in SQLite.",
)
check(
    "Markdown link label survives",
    clean("See [Name of the repository](https://e.com/x) here."),
    "See [Name of the repository](https://e.com/x) here.",
)
check(
    "real placeholder still goes",
    clean("url=INSERT_SOURCE_URL_30 end"),
    "url= end",
)

# --- code and data are never rewritten -------------------------------------
check(
    "fenced code",
    clean("a ’b\n```\nx = “literal”\n```\n"),
    "a 'b\n```\nx = “literal”\n```\n",
)
check("inline code", clean("keep `a’b` here"), "keep `a’b` here")
check("double-backtick span", clean("Use ``the “a” key``."), "Use ``the “a” key``.")
check(
    "yaml front matter",
    clean("---\ntitle: “Q”\n---\n\nbody ’x\n"),
    "---\ntitle: “Q”\n---\n\nbody 'x\n",
)

# --- non-Latin scripts and emoji keep their joiners ------------------------
check("devanagari ZWJ kept", clean("क्‍ष"), "क्‍ष")
check(
    "emoji ZWJ kept",
    clean("\U0001f468‍\U0001f469‍\U0001f467"),
    "\U0001f468‍\U0001f469‍\U0001f467",
)
check("latin ZWNJ stripped", clean("word‌join"), "wordjoin")

# --- unclosed fence is reported, never silent ------------------------------
check("unclosed fence line", unslop.process("a\n```\nb\n", False)[2], 2)
check("closed fence reports 0", unslop.process("```\nb\n```\n", False)[2], 0)

# --- actionable() ignores report-only findings -----------------------------
check("em dash is not actionable", unslop.actionable(found("a — b")), 0)
check("curly quote is actionable", unslop.actionable(found("a’b")), 1)

# --- idempotence -----------------------------------------------------------
_dirty = "a ’b “c”… :contentReference[oaicite:1]\n"
check("idempotent", clean(clean(_dirty)), clean(_dirty))

# --- CLI -------------------------------------------------------------------
with tempfile.TemporaryDirectory() as d:
    tmp = Path(d)

    def run(*args: str) -> subprocess.CompletedProcess:
        # S603: the executable is this interpreter and the script path is
        # derived from __file__. No external input reaches the argument list.
        return subprocess.run(  # noqa: S603
            [sys.executable, str(SCRIPT), *args],
            capture_output=True,
            text=True,
            check=False,
        )

    (tmp / "dirty.md").write_text("a ’b\n", encoding="utf-8")
    (tmp / "clean.md").write_text("plain ascii\n", encoding="utf-8")
    (tmp / "dash.md").write_text("a — b\n", encoding="utf-8")
    (tmp / "code.py").write_text('LABEL = "He said “hi”"\n', encoding="utf-8")
    (tmp / "bad.md").write_bytes(b"caf\xe9\n")

    check("report dirty exits 1", run(str(tmp / "dirty.md")).returncode, 1)
    check("report clean exits 0", run(str(tmp / "clean.md")).returncode, 0)
    # Report-only findings must not gate: no edit could ever make this pass.
    check("report em dash exits 0", run(str(tmp / "dash.md")).returncode, 0)
    check("write clean exits 0", run("--write", str(tmp / "clean.md")).returncode, 0)
    check("write dirty exits 1", run("--write", str(tmp / "dirty.md")).returncode, 1)
    check("stdin with --write exits 2", run("--write").returncode, 2)

    before = (tmp / "code.py").read_text(encoding="utf-8")
    run("--write", str(tmp / "code.py"))
    check("--write refuses .py", (tmp / "code.py").read_text(encoding="utf-8"), before)

    # A bad file must not abandon the files after it.
    (tmp / "after.md").write_text("a ’b\n", encoding="utf-8")
    r = run("--write", str(tmp / "bad.md"), str(tmp / "after.md"))
    check("bad file exits 2", r.returncode, 2)
    check("later file still written", (tmp / "after.md").read_text(encoding="utf-8"), "a 'b\n")

if failures:
    print(f"FAIL: {len(failures)} of {len(failures)} failing check(s)\n")
    for f in failures:
        print(f"  {f}")
    raise SystemExit(1)
print("ok")

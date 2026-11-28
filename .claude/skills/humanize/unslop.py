#!/usr/bin/env python3
"""Strip mechanical AI-writing artefacts from text.

Character-level and residue-level only. Diction, syntax, structure and rhetoric
need judgement, so the `humanize` skill handles those and this script does not.

Default mode reports and changes nothing. `--write` is the only mode that edits.

Why report-only by default: an em dash and an en dash are both legitimate
punctuation, so a blind substitution damages correct prose. Those two are
reported and never rewritten.
"""

from __future__ import annotations

import argparse
import re
import sys
import unicodedata
from pathlib import Path

# Characters with an unambiguous ASCII equivalent in English prose.
TRANSLATE = {
    " ": " ",  # no-break space
    " ": " ",  # narrow no-break space
    " ": " ",  # figure space
    " ": " ",  # punctuation space
    " ": " ",  # thin space
    " ": " ",  # hair space
    " ": " ",  # en space
    " ": " ",  # em space
    " ": " ",
    " ": " ",
    " ": " ",
    "‘": "'",  # left single quote
    "’": "'",  # right single quote / apostrophe
    "‚": "'",
    "‛": "'",
    "“": '"',  # left double quote
    "”": '"',  # right double quote
    "„": '"',
    "‟": '"',
    "′": "'",  # prime
    "″": '"',  # double prime
    "…": "...",  # horizontal ellipsis
    "−": "-",  # minus sign
    "‐": "-",  # hyphen
    "‑": "-",  # non-breaking hyphen
}

# Invisible characters that carry no meaning in Latin-script prose.
INVISIBLE = {
    "​": "zero-width space",
    "⁠": "word joiner",
    "﻿": "byte-order mark",
    "­": "soft hyphen",
}

# ZWNJ and ZWJ are REQUIRED letters in Indic, Arabic and Persian script, and
# they join emoji sequences. Removing them there corrupts the text, so they are
# only stripped from lines that are plainly Latin-script prose.
JOINERS = {"‌": "zero-width non-joiner", "‍": "zero-width joiner"}

# Reported, never rewritten: both are legitimate punctuation.
REPORT_ONLY = {"—": "em dash", "–": "en dash"}

# Vendor residue. Each of these is a paste artefact with no meaning in the text.
RESIDUE = [
    (r":?contentReference\[oaicite:\d+\](?:\{[^}]*\})?", "ChatGPT contentReference"),
    (r"\boai_citation[^\s]*", "ChatGPT oai_citation"),
    (r"\bturn\d+(?:search|view|news)\d+\b", "ChatGPT turn-search token"),
    (r'\battributableIndex="[^"]*"', "ChatGPT attributableIndex"),
    (r"\[cite:\s*\d+(?:\s*,\s*\d+)*\]", "Gemini cite marker"),
    (r"\[span_\d+\]\((?:start|end)_span\)", "Gemini span marker"),
    (r"\bgrok_render_citation_card_json\b|\bgrok_card\b", "Grok card token"),
    (r"【\d+†[^】]*】", "DeepSeek lenticular citation"),
    (r"\bppl-ai-file-upload[^\s]*|\battached_file\b", "Perplexity file token"),
    (r"\bINSERT_[A-Z0-9_]+\b", "placeholder token"),
    (r"\|access-date=\d{4}-[xX]{2}-[xX]{2}", "placeholder access-date"),
    (r"\|date=\d{4}-\d{2}-XX", "placeholder date"),
    (
        r"\[(?:Your |Insert |Article Title|Award or |Describe |Name of )[^\]\n]{0,60}\]",
        "unfilled placeholder bracket",
    ),
]

# Vendor tracking parameters on cited URLs.
UTM = re.compile(
    r"([?&])(?:utm_source=(?:chatgpt\.com|openai|copilot\.com)"
    r"|referrer=grok\.com)(?=$|[&#\s\"'<>)\]])"
)

CODE_FENCE = re.compile(r"^\s*(?:```|~~~)")
INLINE_CODE = re.compile(r"`[^`\n]*`")

LATIN_ONLY = re.compile(r"^[\x00-˿ -⁯₠-⃏\s]*$")


def split_code(text: str) -> list[tuple[str, bool]]:
    """Split into (chunk, is_code) spans so code is never rewritten."""
    out: list[tuple[str, bool]] = []
    in_fence = False
    for line in text.splitlines(keepends=True):
        if CODE_FENCE.match(line):
            in_fence = not in_fence
            out.append((line, True))
            continue
        if in_fence:
            out.append((line, True))
            continue
        pos = 0
        for m in INLINE_CODE.finditer(line):
            if m.start() > pos:
                out.append((line[pos : m.start()], False))
            out.append((m.group(0), True))
            pos = m.end()
        out.append((line[pos:], False))
    return out


def clean_chunk(chunk: str, aggressive: bool) -> tuple[str, dict[str, int]]:
    found: dict[str, int] = {}

    def note(label: str, n: int = 1) -> None:
        if n:
            found[label] = found.get(label, 0) + n

    residue_hits = 0
    for pattern, label in RESIDUE:
        chunk, n = re.subn(pattern, "", chunk)
        residue_hits += n
        note(label, n)
    if residue_hits:
        # Close the gap the removal opened, without touching indentation or the
        # trailing double space that means a line break in Markdown.
        chunk = re.sub(r"(?<=\S)[ ]{2,}(?=\S)", " ", chunk)

    chunk, n = UTM.subn(lambda m: m.group(1), chunk)
    note("vendor tracking parameter", n)
    if n:
        # Tidy the separators the strip left behind: "?&x=1" -> "?x=1".
        chunk = re.sub(r"\?&+", "?", chunk)
        chunk = re.sub(r"&&+", "&", chunk)
        chunk = re.sub(r"[?&](?=$|[\s\"'<>)\]])", "", chunk)

    for ch, label in INVISIBLE.items():
        n = chunk.count(ch)
        if n:
            chunk = chunk.replace(ch, "")
            note(f"{label} (U+{ord(ch):04X})", n)

    for ch, label in JOINERS.items():
        n = chunk.count(ch)
        if not n:
            continue
        if aggressive or LATIN_ONLY.match(chunk.replace(ch, "")):
            chunk = chunk.replace(ch, "")
            note(f"{label} (U+{ord(ch):04X})", n)
        else:
            note(f"{label} (U+{ord(ch):04X}) KEPT - non-Latin script", n)

    for ch, repl in TRANSLATE.items():
        n = chunk.count(ch)
        if n:
            chunk = chunk.replace(ch, repl)
            note(f"{unicodedata.name(ch, 'U+%04X' % ord(ch))} -> {repl!r}", n)

    for ch, label in REPORT_ONLY.items():
        note(f"{label} (U+{ord(ch):04X}) REPORT ONLY", chunk.count(ch))

    return chunk, found


def process(text: str, aggressive: bool) -> tuple[str, dict[str, int]]:
    out: list[str] = []
    total: dict[str, int] = {}
    for chunk, is_code in split_code(text):
        if is_code:
            out.append(chunk)
            continue
        cleaned, found = clean_chunk(chunk, aggressive)
        out.append(cleaned)
        for k, v in found.items():
            total[k] = total.get(k, 0) + v
    return "".join(out), total


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("paths", nargs="*", help="files to process; default is stdin")
    ap.add_argument("--write", action="store_true", help="edit files in place")
    ap.add_argument(
        "--aggressive",
        action="store_true",
        help="also strip ZWJ/ZWNJ from non-Latin text (corrupts Indic/Arabic/emoji)",
    )
    args = ap.parse_args()

    if not args.paths:
        if args.write:
            print("--write needs file paths", file=sys.stderr)
            return 2
        cleaned, found = process(sys.stdin.read(), args.aggressive)
        sys.stdout.write(cleaned)
        for k, v in sorted(found.items()):
            print(f"{v:5d}  {k}", file=sys.stderr)
        return 0

    hits = 0
    for p in map(Path, args.paths):
        text = p.read_text(encoding="utf-8")
        cleaned, found = process(text, args.aggressive)
        if found:
            hits += 1
            print(f"{p}")
            for k, v in sorted(found.items()):
                print(f"  {v:5d}  {k}")
        if args.write and cleaned != text:
            p.write_text(cleaned, encoding="utf-8")
    return 1 if (hits and not args.write) else 0


if __name__ == "__main__":
    raise SystemExit(main())

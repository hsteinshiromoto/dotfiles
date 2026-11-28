---
name: humanize
description: Detect and remove the signs of AI writing from prose. Runs a mechanical pass over Unicode artefacts and chatbot residue, then rewrites the rhetoric, syntax, diction and formatting tells. Use for /humanize, "make this not sound like AI", "de-slop this draft".
disable-model-invocation: true
---

Edit prose so it reads as a person wrote it. Four passes, in order. Pass 1 is mechanical and a script does it. Passes 2 to 4 need judgement and you do them.

## Scope, stated once

**There is no Anthropic or OpenAI watermark in text, so there is none to remove.** The invisible characters that people call a watermark are ordinary typographic characters — U+202F, U+00A0, U+200B — that predate the models by decades and carry no payload. OpenAI called the U+202F artefact "a quirk of large-scale reinforcement learning, not a watermark", and it disappeared within days of the April 2025 o3 release. Google's SynthID marks images, not text. Pass 1 normalises those characters because they are untidy and they break diffs, search and some parsers. Call it character normalisation and nothing else.

This skill improves writing. It does not promise a detector score, and no edit can: detectors disagree with each other, fourteen of them scored below 80% accuracy in one evaluation, and they falsely flag non-native English writers about twelve times more often than native speakers.

**Never change what the text claims.** Facts, numbers, names, citations, quoted material and code are out of scope. If a sentence is empty puffery, delete it; do not restate it as a different claim.

## Pass 1 — mechanical

```bash
# report only, changes nothing
python3 ~/.claude/skills/humanize/unslop.py FILE...

# edit in place
python3 ~/.claude/skills/humanize/unslop.py --write FILE...
```

Reads stdin when given no paths. Skips fenced and inline code. Exits 1 in report mode when it finds anything, so it works in a pre-commit hook.

It rewrites: curly quotes and apostrophes, all the exotic spaces, the ellipsis character, the minus sign, non-breaking and soft hyphens. It deletes: zero-width space, word joiner, BOM, soft hyphen, and the vendor residue listed below. It removes `utm_source=chatgpt.com`, `utm_source=openai`, `utm_source=copilot.com` and `referrer=grok.com` from URLs.

It reports and never rewrites em dashes and en dashes, because both are legitimate punctuation. Decide each one yourself — see Pass 4.

It leaves U+200C and U+200D alone on any line that is not plainly Latin script, because those are required letters in Devanagari, Arabic and Persian and they join emoji sequences. `--aggressive` overrides that and will corrupt such text.

Residue the script strips, which you should also recognise by eye:

| Source | Token |
|---|---|
| ChatGPT | `contentReference[oaicite:1]`, `oai_citation`, `turn0search0`, `attributableIndex="…"` |
| Gemini | `[cite: 1]`, `[span_1](start_span)` |
| Grok | `grok_card`, `grok_render_citation_card_json` |
| DeepSeek | lenticular brackets `【1†source】` |
| Perplexity | `attached_file`, `ppl-ai-file-upload` |
| Any | `[Your Name]`, `INSERT_SOURCE_URL_30`, `|access-date=2026-xx-xx` |

After `--write`, read the file. Removing a token leaves a gap: a dangling `url=`, a sentence that now ends mid-clause. Repair those in Pass 2.

## Pass 2 — rhetoric and content

This pass does the most work. The model's core habit is to drop the specific, rare, awkward fact and reach for the generic, positive one, so the subject ends up **less specific and more exaggerated at the same time**. Reverse that: cut the inflation, and where you can, restore the concrete detail from the source.

Delete or rewrite:

1. **Significance inflation.** Any sentence whose job is to say the subject matters. *stands as, serves as, is a testament to, marked a pivotal moment, underscores its importance, reflects a broader, symbolising its enduring, contributing to the, setting the stage for, represents a shift, key turning point, evolving landscape, indelible mark, deeply rooted, forms part of the wider.* These carry no information. Delete the sentence; do not soften it.
2. **The participle tag.** A trailing `-ing` clause that evaluates the fact just stated: *"…are held by the National Museum, highlighting their historical significance."* Cut everything from the comma.
3. **Vague connection.** *"sources identified John Doe as being associated with leadership of ExampleCorp"* becomes *"John Doe was CEO of ExampleCorp"*. Say the relationship or drop it.
4. **Record-identification padding.** *"His professional profile lists him as…"*, *"Databases identify the subject as…"* State the fact and cite the source normally.
5. **Vague attribution.** *Industry reports, Observers have cited, Experts argue, Some critics argue, several publications.* Name the source or cut the claim.
6. **Coverage padding.** *independent coverage, featured in national media outlets, profiled in trade publications, maintains a strong digital presence.*
7. **Retrieval hedging.** *While specific details are limited…, not widely documented in the available sources, based on available information.* Either the text knows or it does not. Say the fact, or say nothing.
8. **The challenges-and-future ending.** *"Despite these challenges…"* and headings called *Challenges and Legacy* or *Future Outlook*. Cut the section unless it carries sourced facts.
9. **Negative parallelism.** *Not only X but also Y*, *It is not just X, it's Y*, *Y rather than X*. Keep at most one in a long piece, and only where the contrast is the actual point.
10. **Rule of three.** Three adjectives, or three parallel phrases, where two or four would be as true. Break the pattern. Watch for it most where nobody would ordinarily add a flourish: commit messages, bug reports, edit summaries.

## Pass 3 — syntax and diction

**Put the copula back.** *serves as / stands as / functions as / operates as / represents* become **is**. *features / offers / boasts / maintains* become **has**. *began his career as* becomes **was**.

**Use the plain word.** *authored* → wrote. *relocated* → moved. *utilized* → used. *attempted* → tried. *passed away* → died. *garnered* → got, won. *showcased* → showed. *underscored* → showed.

**Cut the signature vocabulary** unless it is the precise word: *delve, intricate, pivotal, crucial, robust, vibrant, tapestry, landscape* (abstract), *realm, testament, meticulous, commendable, interplay, bolstered, fostering, enhance, valuable insights, deep dive, align with, harness the power, cutting-edge, in today's digital landscape.*

**Watch the current set as well, not only the famous one.** The 2024 list decayed: *delve* in arXiv abstracts went 0.04% (2022) to 0.35% (2024) to 0.02% (2026), below where it started. The 2026 replacements are *underexplored, grounded, aligns, synthesizes, reproducible, structurally.* The list moves every year; treat any fixed word list here as dated.

**Restore the things models avoid.** Human writing has more of these, so putting them back helps as much as deleting tells:

- Simple is/has phrases: *there is a*, *it has a*.
- Superlatives and definite statements: *one of the best*, *the only*, *the first*.
- Qualifiers and intensifiers: *very*, *perhaps*, *tends to*.
- Wordy constructions where they are natural: *as a result of*, *in order to*, *the fact that*.

**Vary the sentences.** Model prose has low variance in sentence length and shallow, uniform clause structure. Put a four-word sentence next to a thirty-word one. Let one paragraph run long and the next be two lines.

**Do not polish the variation out.** If the draft repeats a word three times because that is the right word three times, leave it. Elegant variation — *the researcher*, then *the academic*, then *the scholar*, then *the investigator* for one person — is itself a tell.

## Pass 4 — structure and format

- **Em dashes.** Keep a few. Replace the rest with a comma, a colon, brackets or a full stop. Remove the spaces around any that stay: `word—word`, not `word — word`. Spaced em dashes are the model's habit, not the typographic convention.
- **Do not flatten the punctuation instead.** Newer models that were tuned off the em dash now overuse the comma and the full stop, and low punctuation variety has become its own tell. Semicolons, colons and brackets are allowed to exist.
- **Headings** take sentence case, not Title Case. Start at the level the document uses; never put a level-1 heading carrying the document's own title, and never skip a level.
- **Rename the giveaway headings.** *Awards and recognition*, *Challenges and Future Directions*, *Legacy and Impact*. Any `X and Y` heading deserves a second look.
- **Bullets.** Remove the bolded lead-in before the colon in every item. Let a list be a list, or turn it back into a paragraph. A short message does not need `## Background` and `## Next Steps`.
- **Bold** belongs in headings and key terms, not sprinkled through running prose.
- **Emoji** come off section headings and bullet markers.
- **Tables** that hold one metric and one figure become a sentence.
- **Markdown in a field that does not render it** — `**bold**`, `### heading`, `---`, `[text](url)` in a plain-text box, a whole answer wrapped in triple backticks — is the single most conclusive sign. Convert it to the target format.
- **Openers and closers.** *Certainly,* *Of course,* *Great question,* *I hope this helps,* *Let me know if you need anything else,* *In summary,* *In conclusion,* *Overall.* Delete all of them.
- **Letter register in a chat or comment.** *Dear …, I hope this message finds you well … Thank you for your time and consideration.* Rewrite as a message.

## Finish

Call the `ste_writing` skill on the result. It does the general Simplified Technical English pass and this skill does not duplicate it: `/humanize` removes the tells, `ste_writing` makes what is left plain.

## Report

End with a short table — what changed, by pass, and the count. Then list, separately, anything you **did not** change and why: an em dash the author clearly meant, a repeated word that was correct, a heading the house style requires. Name any place where removing a tell would have altered a claim, and leave that text alone.

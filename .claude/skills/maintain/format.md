# Maintain: Format

Heading case normalization and prose wrapping at 80 characters.

## Inputs

- **Scope**: List of resolved post directories (from `commands/maintain.md`).
- **Mode**: Dry-run (default) or `--apply`.

## Checks

### 1. Heading case (Title Case)

All markdown headings (`##`, `###`, etc.) should use Title Case.
Flag headings that deviate. Auto-fixable with `--apply`.

Title Case rules:
- Capitalize first and last word always
- Capitalize all major words (nouns, verbs, adjectives, adverbs)
- Lowercase minor words: a, an, the, and, but, or, for, nor, in, on,
  at, to, by, of, up, as — unless first or last word
- Preserve technical terms, code in backticks, and acronyms as-is

### 2. Prose wrapping (80 chars)

Rewrap prose paragraphs to 80 characters. Auto-fixable with `--apply`.

**Skip** (leave untouched):
- YAML frontmatter (`---` delimiters)
- Fenced code blocks (`` ```{r ...} `` through `` ``` ``)
- Fenced divs (`::: {.callout-*}` through `:::`, including nested)
- Raw HTML blocks (`<details>`, `<aside>`, `<style>`, etc.)
- Display math (`$$...$$`)
- Inline math expressions that would break if split
- `{{< include >}}` and other shortcodes (entire line)
- Tables (lines containing `|`)
- List items with long URLs (wrap after the URL, not mid-URL)
- Block quotes (`>` prefixed lines — rewrap within the quote, keeping
  the `>` prefix)
- Footnote definitions (`[^fn-*]:` — rewrap within the footnote)

**Before/after format:** Show the full paragraph before and after
rewrapping, so the user can verify no Quarto syntax was affected.

## Output Format

### Summary table

Always start with a summary table showing finding counts per post:

```
| # | Post | headings | long-lines | Total |
|---|------|----------|------------|-------|
| 1 | shrotriya2019distillpt1 | 1 | 5 | 6 |
| ...| | | | |
```

Summary line: `Found N issues in M posts. (K posts clean.)`

### Before/after detail tables

**Required for every dry-run and --apply presentation.** After the summary
table, show a per-post before/after table for every post with findings.
The user cannot evaluate or approve changes without seeing the concrete
before and after values.

```
#### <post-slug>

| # | Check | Location | Before | After |
|---|-------|----------|--------|-------|
| 1 | heading-case | Line 15 | `## Setup and motivation` | `## Setup and Motivation` |
| 2 | prose-wrap | Lines 42-44 | `This is a very long paragraph that exceeds...` | `This is a very long paragraph\nthat exceeds...` |
```

For prose-wrap findings, show the full paragraph in both Before and After
columns so the user can verify no Quarto syntax was corrupted.

Every finding must show the literal current text and the literal proposed
replacement. Never present a finding without both columns filled.

## Approval Flow

1. Present summary table + all before/after detail tables.
2. **Post selection**: Checkbox list of posts with finding counts. User
   deselects posts to skip. Clean posts omitted from list.
3. **Finding selection**: For each selected post, user cherry-picks which
   findings to apply by number.
4. If `--apply`: write approved changes to disk.
   If dry-run: show what would change, then stop.

Shortcuts: User can say "accept all" or "skip all" at any step.

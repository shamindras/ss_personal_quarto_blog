# Maintain: Ally (Accessibility)

Static accessibility audit for QMD content.

## Inputs

- **Scope**: List of resolved post directories (from `commands/maintain.md`).
- **Mode**: Dry-run (default) or `--apply`.

## Checks

For each post's `index.qmd`:

### 1. Missing alt-text on markdown images

**Important Quarto distinction:** In Quarto, `![text](path)` text is a
**caption** (displayed visibly below the image), NOT alt-text. The actual
screen-reader alt-text is set via the `fig-alt` attribute in curly braces:

```markdown
![Caption text](image.png){fig-alt="Alt text for screen readers"}
```

For each markdown image, check:
- If `{fig-alt="..."}` attribute exists → has alt-text, skip
- If no `{...}` attributes at all → missing alt-text, flag
- If `{...}` attributes exist but no `fig-alt` → missing alt-text, flag
- If `fig-alt=""` (empty) → missing alt-text, flag (unless decorative)

Do NOT treat the `![caption]()` text as alt-text. An image with
`![My Caption](img.png)` but no `fig-alt` attribute is still missing
alt-text.

For each flagged image, suggest a `fig-alt` value based on the image
filename, caption text, and surrounding context.

### 2. Missing fig-alt on code-generated figures

For R/Python code chunks that produce plots, check for `#| fig-alt:`
chunk option. Flag if missing. Suggest alt-text based on the code's
intent (read the code to understand what is being plotted).

### 3. Missing image-alt in frontmatter

Check for `image-alt` field in YAML frontmatter. This is used by Quarto
for listing page thumbnail alt-text. Flag if missing and suggest alt-text
based on the `image` filename and post title.

### 4. Heading level hierarchy

Parse all markdown headings. Flag level skips:
- `##` → `####` (skipped `###`)
- `#` → `###` (skipped `##`)

Note: Post titles render as `h1`, so body content typically starts at `##`.
A jump from title to `###` without `##` is a skip.

### 5. Empty or non-descriptive links

Flag links with non-descriptive text:
- `[click here](url)` — non-descriptive
- `[here](url)` — non-descriptive
- `[link](url)` — non-descriptive
- `[](url)` — empty link text

Suggest using descriptive text that makes sense out of context.

### 6. Decorative images

If an image is purely decorative (e.g., a separator or spacer), it should
have `alt=""` (explicitly empty). This tells screen readers to skip it.
Flag decorative images with non-empty alt text and suggest `alt=""`.

Note: This check requires judgment — only flag images that are clearly
decorative based on filename (e.g., `separator.png`, `spacer.png`).

## Output Format

### Summary table

Always start with a summary table showing finding counts per post:

```
| # | Post | image-alt | fig-alt (images) | fig-alt (code) | headings | links | Total |
|---|------|-----------|------------------|----------------|----------|-------|-------|
| 1 | shrotriya2019distillpt1 | 1 | - | - | - | - | 1 |
| ...| | | | | | | |
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
| 1 | image-alt | frontmatter | `image: images/foo.png` | `image: images/foo.png`<br>`image-alt: "Description"` |
| 2 | fig-alt | Line 45 | `![Caption](plot.png)` — no fig-alt | Add `{fig-alt="Scatter plot of ..."}` |
| 3 | heading | Line 60 | `## → ####` (skipped ###) | Add `###` or change to `###` |
```

Every finding must show the literal current text and the literal proposed
replacement. Never present a finding without both columns filled.

## Approval Flow

1. Present summary table + all before/after detail tables.
2. **Post selection**: Checkbox list of posts with finding counts. Clean
   posts omitted.
3. **Finding selection**: For each selected post, user cherry-picks which
   findings to apply by number.
4. If `--apply`: write approved changes to disk.
   If dry-run: show what would change, then stop.

Shortcuts: User can say "accept all" or "skip all" at any step.

# Maintain: Lint

Frontmatter validation and Quarto best practices.

## Inputs

- **Scope**: List of resolved post directories (from `commands/maintain.md`).
- **Mode**: Dry-run (default) or `--apply`.

## Checks

For each post's `index.qmd`, run these checks:

### 1. Required frontmatter fields

Verify these fields exist and are non-empty:
- `title`
- `description`
- `date` (must be ISO format: `YYYY-MM-DD`)
- `categories` (must be a list with at least one entry)
- `image` (thumbnail path)

### 2. Image-alt in frontmatter

Check for `image-alt` field in frontmatter. Quarto uses this for listing
thumbnail alt-text. Flag if missing.

### 3. Description length

`description` should be under 160 characters (SEO best practice). Flag if
over 160 chars, showing the current length.

### 4. Date consistency

The `date` field in YAML should match the date prefix of the post directory
name. E.g., for `posts/2019-07-11-shrotriya2019distillpt1/`, the date
should be `2019-07-11`. Flag mismatches.

### 5. Internal links

Scan the QMD body for internal links. Links to other pages on the site
should use `.qmd` extensions, not `.html`. Flag any `.html` internal links.

### 6. Heading level hierarchy

Parse all markdown headings (`#`, `##`, `###`, etc.) in the body. Flag any
level skips — e.g., jumping from `#` (h1) to `###` (h3) without an
intervening `##` (h2). Note: Quarto posts typically start at `##` since
the title renders as `h1`.

### 7. Code block languages

Find all fenced code blocks (`` ``` ``). Flag any that lack a language
specifier (e.g., `` ```r `` or `` ```python ``). Skip code blocks inside
HTML comments or raw blocks.

## Output Format

### Summary table

Always start with a summary table showing finding counts per post:

```
| # | Post | fields | image-alt | desc | date | links | headings | code | Total |
|---|------|--------|-----------|------|------|-------|----------|------|-------|
| 1 | shrotriya2019distillpt1 | - | 1 | - | - | - | - | 2 | 3 |
| ...| | | | | | | | | |
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
| 2 | description | frontmatter | `description: "..."` (172 chars) | `description: "..."` (155 chars) |
```

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

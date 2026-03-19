# Maintain: Legacy

Distill-era syntax cleanup. Permanent and idempotent.

## Inputs

- **Scope**: List of resolved post directories (from `commands/maintain.md`).
- **Mode**: Dry-run (default) or `--apply`.

## Checks

For each post's `index.qmd`:

### 1. `<aside>` tags

Distill used `<aside>` for margin notes. Quarto uses `.column-margin` divs.

Detect:
```html
<aside>
Content here
</aside>
```

Replace with:
```markdown
::: {.column-margin}
Content here
:::
```

Handle both inline and multi-line `<aside>` blocks.

### 2. Disqus references

The blog migrated from Disqus to giscus. Flag any references to Disqus in
the post body:
- Literal string "Disqus" or "disqus" in prose
- `disqus` in YAML frontmatter fields
- HTML comments referencing Disqus

Suggest removal or update based on context. If the reference is in prose
describing the comment system, suggest updating to reference giscus or
removing the sentence.

### 3. `distill::` references

Flag any `distill::` package references outside of code blocks:
- `distill::create_post`
- `distill::create_website`
- Other `distill::` function calls in prose

These are artifacts from the Distill-era workflow. Suggest removal or
rewording.

### 4. Distill shortcodes

Flag any Distill-specific HTML elements:
- `<d-cite>` → suggest Quarto citation syntax `[@key]`
- `<d-footnote>` → suggest Quarto footnote syntax `^[text]`
- `<d-appendix>` → suggest Quarto appendix div
- `<d-bibliography>` → suggest YAML `bibliography:` field
- `<d-math>` → suggest `$...$` or `$$...$$`

### 5. Distill layout classes

Flag Distill-specific CSS classes:
- `l-body` → standard Quarto body (remove class)
- `l-body-outset` → `.column-body-outset`
- `l-page` → `.column-page`
- `l-screen` → `.column-screen`
- `l-screen-inset` → `.column-screen-inset`

## Output Format

### Summary table

Always start with a summary table showing finding counts per post:

```
| # | Post | aside | disqus | distill:: | shortcodes | layout | Total |
|---|------|-------|--------|-----------|------------|--------|-------|
| 1 | shrotriya2019distillpt1 | 3 | 1 | - | - | - | 4 |
| ...| | | | | | | |
```

Summary line: `Found N issues in M posts. (K posts clean.)`

If a post has no findings: report it as clean. This skill is designed to
eventually report all posts clean once the migration is complete.

### Before/after detail tables

**Required for every dry-run and --apply presentation.** After the summary
table, show a per-post before/after table for every post with findings.
The user cannot evaluate or approve changes without seeing the concrete
before and after values.

```
#### <post-slug>

| # | Check | Location | Before | After |
|---|-------|----------|--------|-------|
| 1 | aside | Lines 42-45 | `<aside>`<br>`Note text`<br>`</aside>` | `::: {.column-margin}`<br>`Note text`<br>`:::` |
| 2 | disqus | Line 87 | `Leave a comment via Disqus below` | Remove sentence (giscus is auto-enabled) |
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

## Idempotency

This skill is idempotent — running it multiple times on the same post
produces the same result. Already-converted syntax is not flagged. A fully
cleaned post reports as clean with no findings.

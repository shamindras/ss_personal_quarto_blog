# Maintain: Tags

Category audit, normalization, and canonical enforcement.

## Inputs

- **Scope**: List of resolved post directories (from `commands/maintain.md`).
- **Mode**: Dry-run (default) or `--apply`.

## Canonical Categories

Read `.claude/skills/blog/conventions.md` to get the current canonical set:

`distill`, `linear algebra`, `math`, `norms`, `personal`, `reproducibility`,
`roundup`, `rstats`, `tidyverse`

## Checks

For each post's `index.qmd`:

### 1. Non-canonical categories

Flag any category not in the canonical set. Suggest removal or addition to
the canonical set (if the category seems legitimate and used by multiple
posts).

### 2. Alphabetical ordering

Categories should be listed in alphabetical order. Flag if out of order and
show the sorted version.

### 3. Content-based suggestions

Scan the post body for signals that suggest missing categories:
- R code chunks or mentions of R packages → suggest `rstats` if missing
- Mentions of tidyverse packages (dplyr, ggplot2, tidyr, etc.) → suggest
  `tidyverse` if missing
- Mathematical notation or LaTeX → suggest `math` if missing
- Roundup-style content → suggest `roundup` if missing

Only suggest additions, never removals based on content analysis.

### 4. Duplicate categories

Flag any duplicate entries in the categories list.

## Output Format

### Summary table

Always start with a summary table showing finding counts per post:

```
| # | Post | non-canonical | ordering | content | duplicates | Total |
|---|------|---------------|----------|---------|------------|-------|
| 1 | shrotriya2019distillpt1 | - | 1 | - | - | 1 |
| ...| | | | | | |
```

Summary line: `Found N issues in M posts. (K posts clean.)`

### Before/after detail tables

**Required for every dry-run and --apply presentation.** After the summary
table, show a per-post before/after table for every post with findings.
The user cannot evaluate or approve changes without seeing the concrete
before and after values.

```
#### <post-slug>

| # | Check | Before | After |
|---|-------|--------|-------|
| 1 | ordering | `categories: [rstats, tidyverse, reproducibility]` | `categories: [reproducibility, rstats, tidyverse]` |
| 2 | content | `categories: [reproducibility, tidyverse]` (uses R code) | `categories: [reproducibility, rstats, tidyverse]` |
```

Every finding must show the literal current categories list and the
literal proposed replacement. Never present a finding without both
columns filled.

## Approval Flow

1. Present summary table + all before/after detail tables.
2. **Post selection**: Checkbox list of posts with finding counts. Clean
   posts omitted.
3. **Finding selection**: For each selected post, user cherry-picks which
   findings to apply by number.
4. If `--apply`: write approved changes to disk (update YAML frontmatter).
   If dry-run: show what would change, then stop.

Shortcuts: User can say "accept all" or "skip all" at any step.

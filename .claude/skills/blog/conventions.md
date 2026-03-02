# Blog Naming Conventions

All naming is computed programmatically from three inputs: `<month>` (full
lowercase name), `<YYYY>` (4-digit year), and `<YY>` (2-digit year).

## Naming Patterns

| Element | Pattern | Example (Feb 2026) |
|---------|---------|---------------------|
| Slug | `shrotriya<YYYY><month><YY>roundup` | `shrotriya2026february26roundup` |
| Directory | `<YYYY>-<MM>-<DD>-shrotriya<YYYY><month><YY>roundup/` | `2026-02-28-shrotriya2026february26roundup/` |
| Thumbnail | `images/preview-<month>-<YYYY>-01.png` | `images/preview-february-2026-01.png` |
| Branch | `feat/<month>-<YY>-roundup` | `feat/february-26-roundup` |
| Date | Last day of `<month>` in `<YYYY>` | `2026-02-28` |

## Date Calculation

Use the last day of the specified month. Be leap-year aware:

- January → 31, February → 28 (29 in leap years), March → 31
- April → 30, May → 31, June → 30, July → 31, August → 31
- September → 30, October → 31, November → 30, December → 31

A year is a leap year if divisible by 4, except centuries not divisible by 400.

The `--date <YYYY-MM-DD>` flag overrides auto-calculation.

## Category System

**Canonical categories** (existing in the blog):

`distill`, `linear algebra`, `math`, `norms`, `personal`, `reproducibility`,
`roundup`, `rstats`, `tidyverse`

**Template-fixed categories** (always included, never removed):

| Template | Fixed categories |
|----------|-----------------|
| `roundup` | `personal`, `roundup` |

**Additional categories** via `--categories "rstats,math"`:
- Merged with template-fixed categories (no duplicates).
- If a category is not in the canonical set, warn the user and ask for
  confirmation before proceeding.

## Title Pattern

`"Shamindra's <Month> <YYYY> Roundup"` — month is title-cased.

## Description Pattern (default)

```
A quick roundup of any interesting <Month> <YYYY> activities
```

Override with `--description "..."`.

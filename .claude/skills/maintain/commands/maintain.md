---
description: "Blog maintenance. Subcommands: lint, tags, prose, ally, assets, legacy, all. Use --help for details."
---

Parse `$ARGUMENTS` for the subcommand (first positional word), remaining
positional words (scope), and flags.

| Subcommand | Action |
|------------|--------|
| `lint` | Read `.claude/skills/maintain/lint.md`. Follow the steps there. |
| `tags` | Read `.claude/skills/maintain/tags.md`. Follow the steps there. |
| `prose` | Read `.claude/skills/maintain/prose.md`. Follow the steps there. |
| `ally` | Read `.claude/skills/maintain/ally.md`. Follow the steps there. |
| `assets` | Read `.claude/skills/maintain/assets.md`. Follow the steps there. |
| `legacy` | Read `.claude/skills/maintain/legacy.md`. Follow the steps there. |
| `all` | Read `.claude/skills/maintain/all.md`. Follow the steps there. |
| `--help` | Display the help text below and **stop**. |

If no subcommand or an unknown subcommand is given, display the help text
and **stop**.

## Scope Parsing

After the subcommand, remaining positional words are the **scope** — which
posts to check. Pass the resolved scope to the sub-skill.

| Pattern | Meaning |
|---------|---------|
| *(empty)* | All posts under `posts/` |
| `shrotriya2026february26roundup` | Single post by slug |
| `shrotriya2019tidyfunpt1 shrotriya2019reprtitanic` | Multiple slugs |
| `2019-*` | Glob pattern matched against directory names |

**Slug resolution:** For each slug, find the matching directory under
`posts/` whose name ends with the slug. E.g., `shrotriya2019distillpt1`
resolves to `posts/2019-07-11-shrotriya2019distillpt1/`. If no match is
found, warn and skip that slug.

**Glob resolution:** Match the pattern against directory names under
`posts/`. E.g., `2019-*` matches all directories starting with `2019-`.

## Flags

| Flag | Effect |
|------|--------|
| *(no flag)* | Dry-run mode. Show findings with before/after previews. Nothing written to disk. |
| `--apply` | Apply mode. Same approval flow, but approved changes are written to disk. |
| `--except <skill1> <skill2> ...` | Skip the listed sub-skills. Only valid with `all` subcommand. |
| `--help` | Show help text and **stop**. |

Pass the `--apply` flag through to the sub-skill so it knows whether to
write changes.

### `--except` parsing

When `--except` is present, collect all words after it until the next
`--` flag or end of arguments. These are sub-skill names to exclude.

- Validate each name against the sub-skill list: `lint`, `tags`, `prose`,
  `ally`, `assets`, `legacy`. Warn and ignore unknown names.
- Only valid with the `all` subcommand. If used with an individual
  sub-skill (e.g., `/maintain lint --except tags`), warn that `--except`
  is ignored for single sub-skills.
- Pass the exclusion list to `all.md` so it skips those sub-skills in
  both scanning and the summary matrix.

## Help Text

```
/maintain --help

Blog maintenance and auditing tool.

Subcommands:
  lint      Frontmatter validation, Quarto best practices
  tags      Category audit, alphabetize, flag non-canonical
  prose     Spelling, grammar, broken links
  ally      Accessibility: alt-text, heading levels
  assets    Thumbnail size/naming/borders, image organization
  legacy    Distill-era syntax cleanup
  all       Run all sub-skills in sequence

Scope (optional, after subcommand):
  (none)                    All posts
  <slug>                    Single post by slug
  <slug1> <slug2>           Multiple slugs
  <glob-pattern>            Glob against directory names (e.g. 2019-*)

Flags:
  --apply                   Write approved changes to disk (default is dry-run)
  --except <s1> <s2> ...    Skip listed sub-skills (only with `all`)
  --help                    Show this help

Examples:
  /maintain tags
  /maintain tags shrotriya2026february26roundup
  /maintain lint 2019-*
  /maintain all --apply
  /maintain all --except lint tags
  /maintain all shrotriya2019distillpt1 --except prose --apply
  /maintain legacy shrotriya2019distillpt1 --apply
```

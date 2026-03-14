# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal academic website and research blog for Shamindra Shrotriya, built with **Quarto** and hosted on **Netlify** at https://www.shamindras.com.

## Build Commands

Local development uses [just](https://github.com/casey/just) as a command runner.
All build recipes clean `_site/` first to avoid stale output.

```bash
just dev                 # Dev server with drafts visible (clean + live reload)
just prod                # Production server with drafts hidden (clean + live reload)
just clean               # Remove _site/ directory
just renv-restore        # Restore R packages from renv.lock
```

## R Environment

- R 4.5.1 managed via **renv**. Run `renv::restore()` to install dependencies from `renv.lock`.
- `.Rprofile` activates renv automatically.
- Key R packages: tidyverse, knitr, plotly, emo, here, janitor.

## Site Structure

| File/Dir | Purpose |
|----------|---------|
| `_quarto.yml` | Main site config (navbar, theme, metadata) |
| `index.qmd` | Landing page (about template) |
| `posts.qmd` | Blog listing with search/filter/RSS |
| `research.qmd` | Research papers and collaborators |
| `software.qmd` | Open-source project descriptions |
| `_brand.yml` | Single source for site colors and fonts (consumed by Quarto) |
| `refs.bib` | Shared BibTeX bibliography |
| `ember.scss` | Custom Bootstrap theme (litera base with brand overrides) |
| `netlify.toml` | Netlify deploy config (publish dir, 404 redirect) |
| `styles.css` | Additional CSS overrides |
| `posts/_metadata.yml` | Shared metadata for all blog posts |
| `_extensions/mcanouil/iconify/` | Icon shortcode extension |
| `data/pdfs/` | CV, teaching statement, thesis PDFs |
| `dependencies.R` | Declares implicit Quarto R deps (e.g. `downlit`) so renv tracks them |
| `_freeze/` | Cached computational output (committed to git) |

## Blog Post Conventions

- Posts live in `posts/YYYY-MM-DD-<slug>/index.qmd`
- Each post directory may contain `images/` and `pdfs/` subdirectories
- `posts/_metadata.yml` sets shared defaults: `freeze: true`, giscus comments, CC BY license, Shamindra as author, 80-char line wrap, `bibliography`, `code-link: true`
- Front matter typically includes: title, description, categories, slug, date, image, bibliography
- Posts use `freeze: true` — computational output is cached in `_freeze/` and not re-executed unless explicitly invalidated

## Branch-First Rule

**Before any non-trivial work — plans, implementations, or commits — check and
declare the branch.**

- **Plan mode**: The plan file MUST include a `**Feature branch**: \`<type>/<desc>\`
  (from \`main\`)` line near the top, before implementation steps. If the plan omits
  this, add it before calling ExitPlanMode.
- **Implementation mode**: Before editing any file, run `git branch --show-current`.
  If on `main` and the work is non-trivial (3+ files, new file, multi-scope, or
  `feat`/`refactor` type), create or propose a feature branch **before** touching
  code. Do not defer to commit time.
- **Trivial exception**: Single-file typo fixes, one-line tweaks, or docs-only
  changes may proceed on `main` without a branch.
- **Branch format**: `<type>/<short-kebab-desc>` (e.g. `feat/add-new-post`,
  `fix/quarto-config`).

This rule takes priority over any skill-level branch check. The `/commit` skill
has its own branch check at step 2, but that is a safety net, not the primary gate.

## Git Workflow

Conventional commits via `/commit`. See `.claude/skills/git/workflow.md`
for types, scopes, and flags. Blog-specific overrides (including `--build`
for `_site/` output) in `.claude/skills/git/blog-overrides.md`.
Skill sync via `/sync-skill <name> --from <repo>`.

## Blog Skill

Uses `/blog` skill for blog post lifecycle. Subcommands: `new`, `preview`,
`finalize`, `publish`. See `.claude/skills/blog/conventions.md` for naming rules.

Example: `/blog new --template roundup --month february --year 2026`

## Workflow

### Developing (writing/editing posts)

1. `just dev` — cleans, renders with drafts visible, starts live-reload server
2. Edit `.qmd` files — browser refreshes on each save
3. `/commit` to save progress on the feature branch

### Deploying to production

1. `just prod` — cleans, renders with drafts hidden, starts live-reload server
2. Verify the site looks correct, then stop the server
3. `/commit --all` — commit the rendered `_site/` output
4. `git push` — Netlify serves `_site/` as static files (no CI build step)

Draft visibility is controlled by Quarto profiles: `_quarto.yml` sets
`draft-mode: gone` (production), `_quarto-dev.yml` sets `draft-mode: visible`.

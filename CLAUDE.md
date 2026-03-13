# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal academic website and research blog for Shamindra Shrotriya, built with **Quarto** and hosted on **Netlify** at https://www.shamindras.com.

## Build Commands

Local development uses [just](https://github.com/casey/just) as a command runner:

```bash
just preview             # Local dev server (production mode, drafts hidden)
just preview-dev         # Local dev server with draft posts visible
just render              # Full site render to _site/ (drafts hidden)
just render-dev          # Full site render including draft posts
just clean               # Remove _site/ directory
just renv-restore        # Restore R packages from renv.lock
quarto render <file.qmd> # Render a single page/post
```

Draft visibility is controlled by Quarto profiles: `_quarto.yml` sets `draft-mode: gone`
(production), and `_quarto-dev.yml` sets `draft-mode: visible` (activated via `--profile dev`).

## R Environment

- R 4.5.1 managed via **renv**. Run `renv::restore()` to install dependencies from `renv.lock`.
- `.Rprofile` activates renv automatically.
- Key R packages: tidyverse, knitr, plotly, emo, here, janitor, googlesheets4.

## Site Structure

| File/Dir | Purpose |
|----------|---------|
| `_quarto.yml` | Main site config (navbar, theme, analytics, metadata) |
| `index.qmd` | Landing page (about template) |
| `posts.qmd` | Blog listing with search/filter/RSS |
| `research.qmd` | Research papers and collaborators |
| `software.qmd` | Open-source project descriptions |
| `refs.bib` | Shared BibTeX bibliography |
| `ember.scss` | Custom Bootstrap theme (Atkinson Hyperlegible font) |
| `styles.css` | Additional CSS overrides |
| `posts/_metadata.yml` | Shared metadata for all blog posts |
| `_extensions/mcanouil/iconify/` | Icon shortcode extension |
| `data/pdfs/` | CV, teaching statement, thesis PDFs |
| `_freeze/` | Cached computational output (committed to git) |

## Blog Post Conventions

- Posts live in `posts/YYYY-MM-DD-<slug>/index.qmd`
- Each post directory may contain `images/` and `pdfs/` subdirectories
- `posts/_metadata.yml` sets shared defaults: `freeze: true`, giscus comments, CC BY license, Shamindra as author, 80-char line wrap
- Front matter typically includes: title, description, categories, slug, date, image, bibliography
- Posts use `freeze: true` — computational output is cached in `_freeze/` and not re-executed unless explicitly invalidated

## Git Workflow

Uses `/commit` skill with conventional commits: `<type>(<scope>): <description>`.
Flags: `--staged`, `--all`, `--draft`, `--amend`, `--all-and-push`, `--no-split`,
`--emoji`, `--land`, `--land-main`, `--help`.

See `.claude/skills/git/workflow.md` for scopes and conventions.

## Blog Skill

Uses `/blog` skill for blog post lifecycle. Subcommands: `new`, `preview`,
`finalize`, `publish`. See `.claude/skills/blog/conventions.md` for naming rules.

Example: `/blog new --template roundup --month february --year 2026`

## Deployment

Netlify builds the site from source using the `@quarto/netlify-plugin-quarto` plugin
(configured in `netlify.toml` and `package.json`). The plugin installs Quarto and runs
`quarto render`. Since `freeze: true` is set and `_freeze/` is committed, Netlify does
not need R — it uses cached computational output. Pushing to `main` triggers automatic builds.

`_site/` is gitignored — it is only generated locally or by Netlify during CI.

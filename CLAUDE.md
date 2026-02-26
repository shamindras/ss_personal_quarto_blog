# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal academic website and research blog for Shamindra Shrotriya, built with **Quarto** and hosted on **Netlify** at https://www.shamindras.com.

## Build Commands

```bash
quarto preview           # Local dev server with live reload
quarto render            # Full site render to _site/
quarto render <file.qmd> # Render a single page/post
```

No Makefile, justfile, or package.json exists — Quarto CLI is the sole build tool.

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

## Deployment

Netlify via Git integration — pushing to `main` triggers automatic builds. No CI/CD config files in the repo.

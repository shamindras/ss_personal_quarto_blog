

# shamindras.com

[![](https://api.netlify.com/api/v1/badges/902e0dd6-7868-4e73-9b1a-c9114d53f6b6/deploy-status.png)](https://app.netlify.com/sites/ss-personal-quarto-blog/deploys)

## About

Personal research blog by **Shamindra Shrotriya** — Principal AI
Solution Architect with a PhD in Statistics from Carnegie Mellon
University.

Let’s Get Statistical! This blog covers statistical theory and
methodology, machine learning research, rstats, python, books, sports,
and whatever else catches my interest. Pull up a chair, leave a comment,
and join me so we can explore together.

Live at [shamindras.com](https://www.shamindras.com).

## Tech Stack

| Tool | Purpose |
|----|----|
| [Quarto](https://quarto.org/) | Static site generator |
| R / [renv](https://rstudio.github.io/renv/) | Computational posts + dependency management |
| [just](https://github.com/casey/just) | Command runner |
| [giscus](https://giscus.app/) | GitHub-backed comments |
| [Netlify](https://www.netlify.com/) | Hosting and deployment |

Made with ❤️ using [Quarto](https://quarto.org).

## Repo Structure

| Path          | Purpose                                    |
|---------------|--------------------------------------------|
| `_quarto.yml` | Main site configuration                    |
| `index.qmd`   | Landing / about page                       |
| `posts.qmd`   | Blog listing with search and RSS           |
| `posts/`      | Blog post source files                     |
| `_freeze/`    | Cached computational output                |
| `assets/css/` | Custom theme SCSS and CSS                  |
| `data/`       | Shared images, PDFs, and include fragments |
| `_brand.yml`  | Site colors and fonts                      |
| `Justfile`    | Build recipes                              |

## Local Development

``` bash
# Clone the repo
git clone https://github.com/shamindras/ss_personal_quarto_blog.git
cd ss_personal_quarto_blog

# Restore R dependencies
just renv-restore

# Dev server (drafts visible, live reload)
just dev

# Production server (drafts hidden, live reload)
just prod
```

## Post Naming

Posts follow the convention:

    posts/YYYY-MM-DD-shrotriyaYYYY<topic>/index.qmd

Each post directory contains an `index.qmd` and an `images/` folder.

## Contributing

This is a personal blog, so I’m not accepting feature contributions.
That said, if you spot a typo, broken link, or factual error, I’d
appreciate a heads-up. You can:

- Leave a comment via [giscus](https://giscus.app/) on any post
- Open an
  [issue](https://github.com/shamindras/ss_personal_quarto_blog/issues)
- Send a pull request with the fix

## LLM Usage

All written content in this repository, unless explicitly stated, is
authored by me. LLMs (Claude Code) are used for scaffolding tasks:
formatting, layout, git commits, alt-text, thumbnail generation, and
code automation.

# Roundup Post Template

## Fixed Categories

`personal`, `roundup`

## Frontmatter

```yaml
---
title: "Shamindra's {{Month}} {{YYYY}} Roundup"
description: |
  A quick roundup of any interesting {{Month}} {{YYYY}} activities
categories: [personal, roundup]
slug: {{slug}}
date: "{{date}}"
image: {{thumbnail}}
bibliography: ../../refs.bib
draft: true
format:
  html:
    code-link: true
execute:
  echo: true
editor_options:
  markdown:
    wrap: 80
---
```

Fields inherited from `posts/_metadata.yml` (do NOT include): author, toc,
toc-title, toc-location, title-block-banner, citation, comments, license,
freeze.

Remove `draft: true` if `--no-draft` flag is set.

## Section Placeholders

All sections below are included as optional placeholders. The user deletes
unused sections each month. Do NOT omit any section during scaffolding.

The Introduction must link to the most recent published roundup. Find it by
sorting `posts/` directories matching `*roundup*` by date prefix descending,
excluding the current post being created.

```markdown
## Introduction

Welcome to the {{Month}} {{YYYY}} roundup! Similar to
[last time]({{previous-roundup-url}}){target="_blank"}
I'm documenting anything interesting I come across and any activities
I get up to. This is more for my personal benefit but may also help
others.

## Summary

<!-- 2-3 line overview of highlights: key skills learned, books read,
     articles discovered, and anything else notable this month. -->

## Skills Learned

-

## Interesting Tutorials

-

    <details> <summary>Key Takeaways</summary>

    -

    </details>

## Interesting Articles

-

    <details> <summary>Key Takeaways</summary>

    -

    </details>

## Interesting Books

### Non-fiction

-

### Fiction

-

### Audiobooks

-

### Ebooks

-

## Interesting Papers

-

## Interesting Podcasts and Interviews

-

    <details> <summary>Key Takeaways</summary>

    -

    </details>

## Interesting Presentations and Talks

-

    <details> <summary>Key Takeaways</summary>

    -

    </details>

## Useful Links

-

## Personal Blogging

-

## Teaching

-

## Professional Updates

-

## Concluding Thoughts

```

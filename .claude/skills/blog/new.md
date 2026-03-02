# /blog new — Scaffold a New Blog Post

You should have already read `conventions.md` and the relevant
`templates/<name>.md` before this file.

## 1. Parse flags

Scan remaining `$ARGUMENTS` (after `new` subcommand) for:

| Flag | Required | Default | Effect |
|------|----------|---------|--------|
| `--template <name>` | Yes | — | Template to use (e.g., `roundup`) |
| `--month <name>` | Yes | — | Full month name (case-insensitive) |
| `--year <YYYY>` | Yes | — | Four-digit year |
| `--categories <a,b>` | No | (none) | Additional categories beyond template defaults |
| `--description "..."` | No | (auto) | Override auto-generated description |
| `--no-preview` | No | false | Skip starting quarto preview |
| `--no-branch` | No | false | Stay on current branch |
| `--no-draft` | No | false | Scaffold without `draft: true` |
| `--date <YYYY-MM-DD>` | No | (auto) | Override auto-calculated date |

Error if required flags are missing. Warn on unknown flags.

## 2. Validate template

Check that `.claude/skills/blog/templates/<name>.md` exists. Error if not found
and list available templates from that directory.

## 3. Normalize inputs

- Lowercase the month name.
- Validate it is one of: january, february, march, april, may, june, july,
  august, september, october, november, december.
- Validate year is a 4-digit number.
- Compute 2-digit year: last 2 digits of `<YYYY>`.

## 4. Calculate date

Compute the last day of the specified month in the specified year (leap-year
aware), following the rules in `conventions.md`.

If `--date` is provided, use that instead. Validate it is a valid date in
`YYYY-MM-DD` format.

## 5. Compute naming

Using the rules from `conventions.md`, compute all naming elements:

- **Slug**: `shrotriya<YYYY><month><YY>roundup`
- **Directory name**: `<YYYY>-<MM>-<DD>-<slug>`
- **Directory path**: `posts/<directory-name>/`
- **Thumbnail path**: `images/preview-<month>-<YYYY>-01.png`
- **Branch name**: `feat/<month>-<YY>-roundup`
- **Title**: from template (e.g., `"Shamindra's <Month> <YYYY> Roundup"`)
- **Description**: from `--description` or template default

## 6. Create feature branch

Skip if `--no-branch` is set.

1. Check for clean working tree (`git status --porcelain`). Error if dirty.
2. Run `git checkout main && git pull origin main`.
3. Create and switch to the new branch: `git checkout -b <branch-name>`.

## 7. Check conflicts

Error if `posts/<directory-name>/` already exists.

## 8. Create directory

Create `posts/<directory-name>/` and `posts/<directory-name>/images/`.

## 9. Copy thumbnail

Find the most recent published roundup by listing `posts/` directories matching
`*roundup*`, sorting by date prefix descending, and selecting the first one.

Copy its preview image (`images/preview-*-01.png`) to the new post's
`images/` directory, renaming it to the new thumbnail pattern.

If no previous roundup is found, warn the user and skip this step.

## 10. Find previous roundup URL

For the Introduction link, find the most recent published roundup (same search
as step 9). Build its URL as a relative path:
`../../posts/<previous-dir-name>/` — this creates a site-relative link that
works in Quarto's rendered output.

If no previous roundup exists, use a placeholder `#` and warn the user.

## 11. Generate index.qmd

Populate the template from `templates/<name>.md` with all computed values:

- Replace `{{Month}}` with title-cased month name.
- Replace `{{YYYY}}` with the 4-digit year.
- Replace `{{slug}}` with the computed slug.
- Replace `{{date}}` with the computed date.
- Replace `{{thumbnail}}` with the thumbnail path.
- Replace `{{previous-roundup-url}}` with the URL from step 10.
- If `--categories` provided, merge with template fixed categories (no dupes).
- If `--description` provided, use it instead of the template default.
- If `--no-draft` is set, omit `draft: true` from the frontmatter.

Write the rendered content to `posts/<directory-name>/index.qmd`.

**Important**: Do NOT include a setup chunk with `library(bookdown)` — Quarto
handles cross-references natively.

## 12. Validate categories

If any category from `--categories` is not in the canonical set (see
`conventions.md`), warn the user and ask for confirmation before proceeding.

## 13. Start quarto preview

Skip if `--no-preview` is set.

Run `quarto preview posts/<directory-name>/index.qmd` in the background. This
starts a full site preview server that:
- Opens the browser directly to the new post
- Provides full navbar and site context
- Live reloads on every save to the file

## 14. Display summary

Show the user a summary of what was created:

```
Blog post scaffolded successfully!

  Branch:    <branch-name>
  Directory: posts/<directory-name>/
  File:      posts/<directory-name>/index.qmd
  Thumbnail: posts/<directory-name>/<thumbnail>
  Status:    draft
  Preview:   running (live reload on save)

Next steps:
  1. Edit posts/<directory-name>/index.qmd — saves auto-refresh the browser
  2. Use /commit to save progress
  3. Run /blog finalize when ready to publish
  4. Run /blog publish to create a PR
```

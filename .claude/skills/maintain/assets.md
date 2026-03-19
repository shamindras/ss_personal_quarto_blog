# Maintain: Assets

Thumbnail and image standardization.

## Inputs

- **Scope**: List of resolved post directories (from `commands/maintain.md`).
- **Mode**: Dry-run (default) or `--apply`.

## Canonical Thumbnail Spec

Reference: `posts/2026-02-28-shrotriya2026february26roundup/` (the most
recent post, treated as the canonical example).

- **Dimensions**: 1376×768px
- **Naming**: `images/preview-<descriptor>.png`
- **Border**: 1px solid black (currently applied via inline CSS per-post)
- **Location**: Inside `images/` subdirectory within the post directory

## Checks

For each post directory:

### 1. Thumbnail naming convention

The thumbnail (referenced by `image:` in frontmatter) should match the
pattern `images/preview-*.png`. Flag if:
- Thumbnail is not in `images/` subdirectory
- Thumbnail filename does not start with `preview-`
- Thumbnail is not a PNG

Show current name and suggest a conforming name.

### 2. Thumbnail dimensions

Use `sips` (macOS) or `file` command to check image dimensions. Flag if
not 1376×768px. Show current dimensions.

Note: This is informational — resizing is a manual step. Report only.

### 3. Thumbnail reuse

Check if any thumbnail file is referenced by multiple posts (by comparing
`image:` paths across all posts). Flag shared thumbnails.

### 4. Image directory structure

All images should be in an `images/` subdirectory within the post
directory. Flag any image files (`.png`, `.jpg`, `.jpeg`, `.gif`, `.svg`)
found loose in the post directory root.

### 5. Prohibited subdirectories

Post directories should NOT contain these subdirectories:
- `pdfs/` (use `data/pdfs/` for shared PDFs)
- `data/` (use project-level `data/` directory)
- `figures/` (use `images/` instead)

Flag if any of these exist.

### 6. Frontmatter image path

Verify the `image:` field in frontmatter points to a file that actually
exists in the post directory. Flag broken image references.

## Output Format

### Summary table

Always start with a summary table showing finding counts per post:

```
| # | Post | naming | dimensions | reuse | structure | prohibited | path | Total |
|---|------|--------|------------|-------|-----------|------------|------|-------|
| 1 | shrotriya2019distillpt1 | 1 | 1 | - | - | - | - | 2 |
| ...| | | | | | | | |
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
| 1 | naming | `image: "distill_img.png"` | `image: "images/preview-distill.png"` |
| 2 | dimensions | 800×600 | 1376×768 (manual resize needed) |
| 3 | structure | `./plot.png` (in post root) | `./images/plot.png` |
```

Every finding must show the literal current value and the literal proposed
change. Never present a finding without both columns filled.

## Approval Flow

1. Present summary table + all before/after detail tables.
2. **Post selection**: Checkbox list of posts with finding counts. Clean
   posts omitted.
3. **Finding selection**: For each selected post, user cherry-picks which
   findings to apply by number.
4. If `--apply`: write approved changes to disk.
   If dry-run: show what would change, then stop.

### What `--apply` can do

- Rename/move image files to conform to naming conventions
- Update `image:` frontmatter to point to new path
- Create `images/` subdirectory if needed
- Move loose images into `images/`

### What `--apply` cannot do

- Resize images (report dimensions, user resizes manually)
- Add borders to images (report missing borders, user applies manually)
- Delete prohibited subdirectories (report, user decides)

Shortcuts: User can say "accept all" or "skip all" at any step.

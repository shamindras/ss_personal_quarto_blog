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

### 2. Thumbnail formatting (crop, resize, border)

Use `sips` (macOS) to check image dimensions. Flag if the thumbnail does
not match the canonical spec: 1376×768px with a 1px solid black border.

When `--apply` is approved, apply the full formatting pipeline
automatically. **Back up the original first** — see §Backup Convention.

#### Formatting pipeline

Uses ImageMagick (`magick`) for all operations in a single command.
**Do NOT crop** — cropping loses content. Instead, resize to fit and
pad to fill the target dimensions.

**Single-command pipeline:**

```bash
magick <path> \
  -resize 1374x766^ \
  -gravity center \
  -extent 1374x766 \
  -bordercolor black \
  -border 1 \
  <path>
```

This does:
1. **Resize to fill** 1374×766 — the `^` flag scales so the *smaller*
   dimension matches the target, preserving aspect ratio. The image
   will be at least 1374×766, possibly larger in one dimension.
2. **Trim overflow** from center — `-gravity center -extent` crops
   any excess equally from both sides. Only a tiny sliver is lost
   (typically 1–5% from the longer dimension).
3. **Add 1px black border** on all sides → final size 1376×768

The inner dimensions are 1374×766 (not 1376×768) because the 1px
border adds 1px on each side.

**Important:** Do NOT use `-resize WxH` (without `^`) — that fits
*within* the box and leaves letterbox padding, causing thumbnails to
appear different heights on the listing page. Do NOT use
`sips --cropToHeightWidth` alone — that crops without resizing first
and loses significant content.

If ImageMagick is not installed, report:
"Formatting not applied — ImageMagick not found. Install via
`brew install imagemagick`."

#### Detect existing border

Before adding a border, visually inspect via the Read tool. If the
thumbnail already has a visible black border, skip the border step
and report "Border already present."

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

### 7. Image file size limits

Flag any image (thumbnail or inline) that exceeds these thresholds:

| Image type | Max size | Rationale |
|------------|----------|-----------|
| Thumbnail (`preview-*.png`) | 400KB | Loads on listing page for every visitor |
| Profile image (`data/images/about-profile-*`) | 300KB | Loads on landing page for every visitor |
| Inline post image | 500KB | Embedded in post body |

Report the file, its current size, and the threshold it exceeds.

### 8. PNG compression (oxipng)

Check whether PNG files have been losslessly compressed. Run
`oxipng -o 4 --strip safe --pretend` (dry-run mode) to detect
potential savings. Flag any PNG where oxipng reports ≥5% savings.

When `--apply` is approved, run the full compression:
```bash
oxipng -o 4 --strip safe <path>
```

If oxipng is not installed, report:
"Compression check skipped — oxipng not found. Install via
`brew install oxipng`."

**Note:** `just img-optimize` runs oxipng across all posts and shared
images as a bulk alternative.

### 9. Image dimensions

Flag images whose pixel dimensions are significantly larger than their
display size. Common oversized patterns:

| Image type | Max dimensions | Rationale |
|------------|---------------|-----------|
| Profile image | 384×384px | Displayed at ~192px (2× retina) |
| Thumbnails | 1376×768px | Canonical thumbnail spec |
| Inline images | 1600px wide | 2× retina for ~800px content column |

Report the file, current dimensions, and suggested target.

When `--apply` is approved, resize with `sips --resampleWidth <target>`
(backup first — see §Backup Convention).

## Output Format

### Summary table

Always start with a summary table showing finding counts per post:

```
| # | Post | naming | formatting | reuse | structure | prohibited | path | filesize | compression | dimensions | Total |
|---|------|--------|------------|-------|-----------|------------|------|---------|-------------|------------|-------|
| 1 | shrotriya2019distillpt1 | 1 | 1 | - | - | - | - | - | 1 | - | 3 |
| ...| | | | | | | | | | | |
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
| 2 | formatting | 3350×1971px, no border | Crop → resize to 1376×768 → add 1px black border (backup → `*.original.png`) |
| 3 | structure | `./plot.png` (in post root) | `./images/plot.png` |
```

Every finding must show the literal current value and the literal proposed
change. Never present a finding without both columns filled.

## Backup Convention

**Any destructive image operation (resize, convert, border-add) must
back up the original first.** This allows easy reversion.

Backup path: alongside the original, with `.original` before the
extension:
```
images/preview-january-2020-01.png          ← resized (active)
images/preview-january-2020-01.original.png ← backup of pre-resize file
```

Steps:
1. Copy the file to the `.original` backup path.
2. Perform the operation on the original path (so frontmatter `image:`
   does not need updating).
3. Report the backup path in the before/after table.

If a `.original` backup already exists, skip the backup (idempotent —
the first original is the one worth keeping).

**Backups are gitignored by convention.** Add `*.original.png` (and
`*.original.jpg`) to `.gitignore` if not already present, so backups
stay local and don't bloat the repo.

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
- **Resize thumbnails** to canonical dimensions via `sips` (backup first)
- **Add borders** to thumbnails via `sips` or ImageMagick (backup first)
- **Compress PNGs** losslessly via `oxipng -o 4 --strip safe`
- **Resize oversized images** via `sips --resampleWidth` (backup first)

### What `--apply` cannot do

- Delete prohibited subdirectories (report, user decides)

Shortcuts: User can say "accept all" or "skip all" at any step.

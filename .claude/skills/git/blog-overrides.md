# Blog-Specific Commit Overrides

These overrides apply only when this file exists (blog repo only).

## `--build` flag

Fast-track flag for committing `_site/` build output. Skips diff preview,
split analysis, and confirmation since the message is always identical.

**Mutual exclusions** — error if combined with `--build`:
- `--build` + `--staged`
- `--build` + `--amend`
- `--build` + `--draft`

### Step overrides for `--build`

- **Step 3**: Stage only `_site/` files (`git add _site/`).
- **Step 4**: Show `git diff --staged --stat` only (never full diff for `_site/`).
- **Step 5**: Skip split analysis entirely.
- **Step 6**: Fixed message: `chore(quarto): update site build output`
- **Step 7**: Skip confirmation (deterministic message, no user input needed).
- **Step 8**: Commit immediately.
- **Step 9**: Standard post-commit.

### Auto-detection

- When all changes are `_site/`-only but `--build` wasn't used, suggest:
  "All changes are in `_site/`. Use `--build` to fast-track this commit."
- When `_site/` changes coexist with source changes, propose splitting:
  "Source and build changes detected. Suggest committing source first,
  then using `--build` for `_site/`."

## `_site/` split rule

- **Never combine `_site/` changes with source changes** in a single commit.
- Always propose splitting when both are present, regardless of `--no-split`.

## Draft lifecycle awareness

When committing a post that has `draft: true` in its front matter:
- Note the draft status in the commit message:
  `feat(posts): add <description> to <slug> draft`
- After the commit, print hint:
  "Post is still in draft. Run `/blog finalize` when ready."

When a commit removes `draft: true` from a post's front matter:
- Use message format: `feat(posts): finalize <slug> for publishing`

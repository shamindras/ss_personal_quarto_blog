# /blog preview — Resume Editing with Live Preview

## 1. Parse flags

Scan remaining `$ARGUMENTS` (after `preview` subcommand) for:

| Flag | Required | Default | Effect |
|------|----------|---------|--------|
| `--post <slug>` | No | (auto-detect) | Target a specific post by slug |

Warn on unknown flags.

## 2. Find target post

### If `--post <slug>` is specified
Search `posts/` for a directory whose name contains the slug. Error if not
found or if multiple matches exist.

### If on a feature branch (not `main`)
Infer the post from the branch name. The branch format is
`feat/<month>-<YY>-roundup`. Search `posts/` for a directory containing
the corresponding slug pattern (`*<month><YY>roundup*`).

If no match is found, fall back to scanning for `draft: true` posts.

### If on `main`
Scan all `posts/*/index.qmd` files for `draft: true` in the frontmatter.

- If exactly one draft is found, use it.
- If multiple drafts are found, list them and ask the user to pick.
- If no drafts are found, inform the user and **stop**.

## 3. Switch branch if needed

If the target post is associated with a feature branch and we're not already
on it:

1. Check for clean working tree (`git status --porcelain`). Error if dirty.
2. Switch to the feature branch: `git checkout <branch-name>`.

If no feature branch exists for the post (e.g., drafted directly on `main`),
stay on the current branch.

## 4. Start quarto preview

Run `quarto preview posts/<directory-name>/index.qmd` in the background.

This starts a full site preview server that:
- Opens the browser directly to the post
- Provides full navbar and site context
- Live reloads on every save

Display the post path and confirm preview is running.

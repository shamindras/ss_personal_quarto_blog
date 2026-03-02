# /blog publish — Push Branch and Create PR

## 1. Parse flags

Scan remaining `$ARGUMENTS` (after `publish` subcommand) for:

| Flag | Required | Default | Effect |
|------|----------|---------|--------|
| `--title "..."` | No | (auto) | Override PR title |
| `--draft-pr` | No | false | Create the PR as a GitHub draft |

Warn on unknown flags.

## 2. Pre-flight checks

1. Check current branch. Error if on `main`.
2. Check for `draft: true` in the post's `index.qmd`. If still present,
   warn: "Post still has `draft: true`. Run `/blog finalize` first, or
   proceed anyway?" Wait for user confirmation.
3. Check for uncommitted changes (`git status --porcelain`). Error if dirty:
   "Uncommitted changes found. Run `/commit` first."

## 3. Push branch

Run `git push -u origin <branch-name>`.

Never force-push. If the push fails, show the error and **stop**.

## 4. Check for existing PR

Run `gh pr list --head <branch-name> --json number,url`.

If a PR already exists, display its URL and **stop**:
"PR already exists: <url>"

## 5. Create PR

Extract post metadata from `index.qmd` frontmatter: title, description,
categories, template type (infer from categories — e.g., `roundup` if
categories include `roundup`).

Auto-generate the PR title (unless `--title` overrides):
`feat(posts): add <post-title>`

Create the PR:

```bash
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
- New blog post: <post-title>
- Template: <template>
- Categories: <categories>

## Description
<post description from frontmatter>
EOF
)"
```

If `--draft-pr` is set, add `--draft` to the `gh pr create` command.

## 6. Display result

Show the PR URL and print:
`Run /commit --land to merge the PR and publish.`

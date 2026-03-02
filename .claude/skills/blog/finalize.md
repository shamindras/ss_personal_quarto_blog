# /blog finalize — Remove Draft Status

## 1. Detect current post

1. Check current branch with `git branch --show-current`.
2. Error if on `main` — "Run `/blog finalize` from a feature branch."
3. Find the draft post on the current branch: search `posts/*/index.qmd`
   files for `draft: true` in the frontmatter.
4. If no draft post is found, inform the user and **stop**.
5. If multiple drafts are found, list them and ask the user to pick.

## 2. Modify frontmatter

Remove the `draft: true` line entirely from the post's `index.qmd`.

Do NOT replace it with `draft: false` — Quarto's default is non-draft, and
existing published posts have no `draft` field. Simply delete the line.

## 3. Show diff

Run `git diff -- posts/<directory-name>/index.qmd` and display the output
so the user can confirm the change.

## 4. Commit

Stage and commit the change:

```
git add posts/<directory-name>/index.qmd
git commit -m "feat(posts): finalize <post-slug> for publishing"
```

Use a HEREDOC for the commit message to preserve formatting.

## 5. Confirm

- Run `git log --oneline -3` and display.
- Print: `Run /blog publish to create a PR.`

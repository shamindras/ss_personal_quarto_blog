# Git Workflow

## Branching

- Always branch from `main`.
<!-- REPO-SPECIFIC: branching-examples -->
- Format: `<type>/<short-kebab-desc>` (e.g. `feat/add-new-post`, `fix/quarto-config`).
<!-- END REPO-SPECIFIC -->
- Keep branch names short and descriptive.

## Proactive Branch Awareness

During `/commit`, Claude applies judgment about the current branch:
- **On a feature branch**: proceed without interruption.
- **On `main` with trivial changes**: note the branch, proceed.
- **On `main` with non-trivial changes**: proactively suggest creating a
  feature branch before committing (soft suggestion, user can override).

Goal: keep `main` clean by default without adding friction to quick fixes.

## Feature Branches in Plans

**REQUIRED**: When presenting a plan for user approval (via ExitPlanMode), the
plan file MUST include the feature branch name near the top. This is non-negotiable
— plans without an explicit branch declaration are incomplete.

Format:

Place this immediately after the Context section, before implementation steps.

<!-- REPO-SPECIFIC: plan-example -->
> **Feature branch**: `feat/new-blog-post` (from `main`)
<!-- END REPO-SPECIFIC -->

## Conventional Commits

Format: `<type>(<scope>): <description>`

### Rules

- Subject line ≤72 characters.
- Imperative mood, lowercase after colon, no trailing period.
- Body (optional) wrapped at 79 characters — explains what/why, not how.

### Types

Primary (used most often):

| Type | When to use |
|------|-------------|
<!-- REPO-SPECIFIC: types -->
| `feat` | New post, page, feature, or capability |
| `fix` | Broken rendering, wrong config, runtime error fixed |
| `refactor` | Restructured existing content/config, no behavior change |
| `docs` | README, CLAUDE.md, skill files, comments-only changes |
| `chore` | Deps, renv.lock, tooling, extensions |
<!-- END REPO-SPECIFIC -->

Others (use when they clearly apply):

| Type | When to use |
|------|-------------|
| `test` | Added or updated tests |
| `style` | Formatting-only (rare — most tools auto-format) |
| `ci` | CI/CD pipeline files |

### Type Selection Heuristic

<!-- REPO-SPECIFIC: type-heuristic-1 -->
1. Does the diff add a **new** post/page/capability? → `feat`
<!-- END REPO-SPECIFIC -->
2. Does it **fix** something that was broken? → `fix`
3. Does it **move/rename/restructure** without changing behavior? → `refactor`
4. Is it **only** documentation or comments? → `docs`
<!-- REPO-SPECIFIC: type-heuristic-5 -->
5. Is it tooling, deps, renv.lock, or extensions? → `chore`
<!-- END REPO-SPECIFIC -->
6. Does it add/update **tests**? → `test`
7. None of the above? Re-read the diff — one of the above almost always fits.

### Scopes

<!-- REPO-SPECIFIC: scopes -->
**By content area:**

| Scope | Files |
|-------|-------|
| `(posts)` | `posts/*/` — blog post content |
| `(quarto)` | `_quarto.yml`, `posts/_metadata.yml`, `_site/` build output, `justfile` |
| `(theme)` | `ember.scss`, `styles.css`, `_extensions/` |
| `(research)` | `research.qmd` |
| `(software)` | `software.qmd` |
| `(renv)` | `renv.lock`, `.Rprofile`, `renv/` |
| `(data)` | `data/`, `refs.bib` |
| `(docs)` | `README.md`, `CLAUDE.md` |
| `(claude)` | `.claude/` settings and skills |

When a file doesn't clearly belong to a scope above, use the closest match
or omit the scope for truly cross-cutting changes.
<!-- END REPO-SPECIFIC -->

<!-- REPO-SPECIFIC: splitting -->
## Commit Splitting (Blog Convention)

### Scope-based splitting (default)

- **Default behavior: one commit per scope/content area**
- Even within shared files (`_quarto.yml`, `CLAUDE.md`), split hunks by the content area they relate to
- Group related changes across multiple files by scope
- This ensures a clean, semantic git history where each commit represents changes to a single content area
- **Never combine `_site/` changes with source changes** in a single commit

### When to keep changes together

- Atomic features that span multiple scopes (rare — ask user first)
- User explicitly requests combining (override default)
- Changes to shared infrastructure that genuinely affects all areas

### Example

❌ **Don't do this:**
```
feat(posts): add new post and update site
- posts/2026-03-31-.../index.qmd
- _site/ (200 files)
- _quarto.yml
```

✅ **Do this instead:**
```
feat(posts): add march 2026 roundup draft
refactor(quarto): add march roundup to navbar
chore(quarto): update site build output
```

### How to split

1. **Identify scopes for all changes:**
   - For content-specific files (e.g., `posts/2024-01-01-my-post/*`), scope is obvious: `(posts)`
   - For shared files (`_quarto.yml`, `CLAUDE.md`), analyze each hunk to determine which scope it relates to
   - For multi-scope hunks, either split the hunk or ask user which scope to use

2. **Group changes by scope:**
   - Organize all hunks (across all files) by their identified scope
   - Each scope becomes a proposed commit

3. **Present grouping to user:**
   ```
   Proposed commits:

   1. feat(posts): add new blog post on optimization
      - posts/2024-06-15-optimization/index.qmd (new file)
      - posts/2024-06-15-optimization/images/fig1.png (new file)

   2. refactor(quarto): update navbar ordering
      - _quarto.yml (navbar changes)

   3. chore(renv): update lock file
      - renv.lock (package updates)
   ```

4. **Exceptions** — keep together ONLY if:
   - User explicitly requests it (`--no-split` or direct instruction)
   - Changes are truly atomic AND user confirms (never assume)

5. **Verify with user before proceeding**

### Splitting shared files

When a single file (e.g., `_quarto.yml`) contains changes for multiple scopes:

1. Analyze hunks and attribute each to a scope
2. Group hunks by scope
3. Stage and commit each scope separately
4. Present the grouping plan to the user before committing
<!-- END REPO-SPECIFIC -->

## Attribution

- Do **not** add a `Co-Authored-By` trailer for Claude in commit messages unless the user explicitly opts in.
- By default, commits should be authored solely by the user.

## Command conventions

- Always run `git` commands **from the repo root** using relative paths.
- **Never** use `git -C <absolute-path>` — it generates non-portable permission
  entries in `.claude/settings.local.json` and causes repeated approval prompts.
- Reference files with repo-relative paths (e.g. `git diff -- posts/`,
  not `git diff -- /Users/.../ss_personal_quarto_blog/posts/`).

<!-- REPO-SPECIFIC: examples -->
## Examples

Single-line:

```
feat(posts): add march 2026 roundup draft post
```

```
feat(posts): remove draft status from feb roundup post
```

```
fix(posts): correct broken image path in roundup post
```

```
refactor(posts): reformat post to 80-char line wrapping
```

```
chore(quarto): update site build output
```

```
docs(docs): update build commands and workflow
```

Multi-line:

```
feat(posts): add march 2026 roundup draft post

Initial draft with sections for links, papers, and tools. Includes
thumbnail image and bibliography entries.
```

```
refactor(quarto): simplify justfile with dev/prod preview recipes

Replace separate clean/render/preview steps with unified recipes
that handle the full pipeline. No behavior change.
```
<!-- END REPO-SPECIFIC -->

# Git Workflow

## Branching

- Always branch from `main`.
- Format: `<type>/<short-kebab-desc>` (e.g. `feat/add-new-post`, `fix/quarto-config`).
- Keep branch names short and descriptive.

## Proactive Branch Awareness

During `/commit`, Claude applies judgment about the current branch:
- **On a feature branch**: proceed without interruption.
- **On `main` with trivial changes**: note the branch, proceed.
- **On `main` with non-trivial changes**: proactively suggest creating a
  feature branch before committing (soft suggestion, user can override).

Goal: keep `main` clean by default without adding friction to quick fixes.

## Feature Branches in Plans

When presenting a plan for user approval (via ExitPlanMode), always explicitly
state the feature branch name that will be created from `main`. Use the
standard branch naming format: `<type>/<short-kebab-desc>`.

Example in plan file:
> **Feature branch**: `feat/new-blog-post` (from `main`)

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
| `feat` | New post, page, feature, or capability |
| `fix` | Broken rendering, wrong config, runtime error fixed |
| `refactor` | Restructured existing content/config, no behavior change |
| `docs` | README, CLAUDE.md, skill files, comments-only changes |
| `chore` | Deps, renv.lock, tooling, extensions |

Others (use when they clearly apply):

| Type | When to use |
|------|-------------|
| `test` | Added or updated tests |
| `style` | Formatting-only (rare — most tools auto-format) |
| `ci` | CI/CD pipeline files |

### Type Selection Heuristic

1. Does the diff add a **new** post/page/capability? → `feat`
2. Does it **fix** something that was broken? → `fix`
3. Does it **move/rename/restructure** without changing behavior? → `refactor`
4. Is it **only** documentation or comments? → `docs`
5. Is it tooling, deps, renv.lock, or extensions? → `chore`
6. Does it add/update **tests**? → `test`
7. None of the above? Re-read the diff — one of the above almost always fits.

### Scopes

**By content area:**

| Scope | Files |
|-------|-------|
| `(posts)` | `posts/*/` — blog post content |
| `(quarto)` | `_quarto.yml`, `posts/_metadata.yml` |
| `(theme)` | `ember.scss`, `styles.css`, `_extensions/` |
| `(research)` | `research.qmd` |
| `(software)` | `software.qmd` |
| `(renv)` | `renv.lock`, `.Rprofile`, `renv/` |
| `(data)` | `data/`, `refs.bib` |
| `(docs)` | `README.md`, `CLAUDE.md` |
| `(claude)` | `.claude/` settings and skills |

When a file doesn't clearly belong to a scope above, use the closest match
or omit the scope for truly cross-cutting changes.

## Commit Splitting (Blog Convention)

### Scope-based splitting (default)

- **Default behavior: one commit per scope/content area**
- Even within shared files (`_quarto.yml`, `CLAUDE.md`), split hunks by the content area they relate to
- Group related changes across multiple files by scope
- This ensures a clean, semantic git history where each commit represents changes to a single content area

### When to keep changes together

- Atomic features that span multiple scopes (rare — ask user first)
- User explicitly requests combining (override default)
- Changes to shared infrastructure that genuinely affects all areas

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

## Attribution

- Do **not** add a `Co-Authored-By` trailer for Claude in commit messages unless the user explicitly opts in.
- By default, commits should be authored solely by the user.

## Command conventions

- Always run `git` commands **from the repo root** using relative paths.
- **Never** use `git -C <absolute-path>` — it generates non-portable permission
  entries in `.claude/settings.local.json` and causes repeated approval prompts.
- Reference files with repo-relative paths (e.g. `git diff -- posts/`,
  not `git diff -- /Users/.../ss_personal_quarto_blog/posts/`).

## Examples

Single-line:

```
feat(posts): add new blog post on gradient descent
```

```
fix(quarto): correct navbar link ordering
```

```
chore(renv): update lock file
```

Multi-line:

```
refactor(theme): improve mobile responsiveness

Update ember.scss breakpoints and styles.css grid layout for better
rendering on small screens. No content changes.
```

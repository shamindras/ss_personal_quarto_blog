# Repo Overrides — plan-prompt-drafter

Context read at invocation time by `/plan-prompt-drafter`.
All universal prompt-drafting rules live in the skill file itself.
This file contains only repo-specific additions.

<!-- REPO-SPECIFIC: repo-context -->
## CLAUDE.md Pointers

Read `CLAUDE.md` at the repo root. Pay particular attention to:

- § Build Commands — just dev/prod workflow, clean builds
- § Site Structure — _quarto.yml, posts, assets, _brand.yml layout
- § Blog Post Conventions — naming, front matter, freeze, _metadata.yml
- § Reusable Includes — include fragments in data/qmds/includes/
- § Branch-First Rule — feature branch workflow
- § Git Workflow — conventional commits via /commit
- § Blog Skill — /blog lifecycle (new, preview, finalize, publish)
- § Maintain Skill — /maintain for linting and auditing
- § Workflow (Developing / Deploying) — dev vs prod rendering, draft visibility
- § R Environment — renv, R packages (only when prompt touches R code)

## Repo-Specific Prompt Additions

- When a prompt involves new posts, include `/blog` skill steps
  (new → preview → finalize → publish)
- When a prompt touches site config (_quarto.yml, _brand.yml) or theme files
  (ember.scss, styles.css), add a `just prod` verification step
- When a prompt adds or modifies posts, include `/maintain lint` as a quality
  gate before committing
- When a prompt touches freeze-dependent content, note freeze invalidation
  implications (cached output in `_freeze/` won't re-render unless explicitly
  invalidated)

## Skill Pointers

- Git workflow: see `.claude/skills/git/workflow.md` for commit types, scopes,
  branch naming, and conventions. Drafted prompts must respect these; do not
  restate them, just point to the skill.
- Blog lifecycle: see `/blog` for post creation and publishing. Do not restate
  the new → preview → finalize → publish flow.
- Maintenance: see `/maintain` for linting and auditing. Do not restate
  subcommands or conventions.

## Out-of-Scope Handling

Do not assume what is out of scope. Survey the user interactively
(one question at a time, checkbox format per step 5a in the skill)
about what should be deferred, then place those items in a "Future
Considerations" section explicitly marked as out of scope for the
current session.
<!-- END REPO-SPECIFIC -->

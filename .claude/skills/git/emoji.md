# Emoji Prefix Mapping

When `--emoji` is active, prefix the commit description with the type's emoji.

Format: `<type>(<scope>): <emoji> <description>`

## Mapping

| Type       | Emoji | Example                                      |
|------------|-------|----------------------------------------------|
<!-- REPO-SPECIFIC: emoji-examples -->
| `feat`     | ✨    | `feat(posts): ✨ add new blog post on optimization` |
| `fix`      | 🐛    | `fix(quarto): 🐛 correct navbar link ordering`     |
| `refactor` | ♻️     | `refactor(theme): ♻️ improve mobile responsiveness` |
| `docs`     | 📝    | `docs(docs): 📝 update project guidance`            |
| `chore`    | 📦    | `chore(renv): 📦 update lock file`                  |
| `test`     | ✅    | `test(posts): ✅ add render validation`              |
| `style`    | 🎨    | `style(theme): 🎨 reformat scss`                    |
| `ci`       | 👷    | `ci(netlify): 👷 add build workflow`                 |
<!-- END REPO-SPECIFIC -->

## Rules

- Insert emoji after `<scope>): ` and before the lowercase description
- 72-char subject limit still applies (emoji counts as ~2 chars)
- If subject exceeds limit, shorten description — never drop the emoji
- Unknown type: omit emoji, warn
- Multi-commit splits: each commit gets its own type's emoji
- PR titles inherit emoji when combined with `--land`

## Step override

- **Step 6**: Apply mapping to draft the commit subject as
  `<type>(<scope>): <emoji> <description>`

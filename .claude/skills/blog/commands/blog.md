---
description: "Blog post lifecycle. Subcommands: new, preview, finalize, publish. Use --help for details."
---

Parse `$ARGUMENTS` for the subcommand (first positional word) and remaining flags.

| Subcommand | Action |
|------------|--------|
| `new` | Read `.claude/skills/blog/conventions.md`, then `.claude/skills/blog/templates/<name>.md` (from `--template` flag), then `.claude/skills/blog/new.md`. Follow the steps in `new.md`. |
| `preview` | Read `.claude/skills/blog/preview.md`. Follow the steps there. |
| `finalize` | Read `.claude/skills/blog/finalize.md`. Follow the steps there. |
| `publish` | Read `.claude/skills/blog/publish.md`. Follow the steps there. |
| `--help` | Display the help text below and **stop**. |

If no subcommand or an unknown subcommand is given, display the help text and **stop**.

## Help Text

```
/blog --help

Subcommands:
  new       Scaffold a new blog post from a template
  preview   Resume editing with live-reloading preview
  finalize  Remove draft status, commit the change
  publish   Push branch, create GitHub PR

Common usage:
  /blog new --template roundup --month february --year 2026
  /blog preview
  /blog preview --post february26roundup
  /blog finalize
  /blog publish
  /blog publish --draft-pr

Full lifecycle: new → commit → finalize → publish → /commit --land
```

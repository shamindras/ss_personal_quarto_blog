# Future Work: Node-Based Formatting Pipeline

This document captures the planned shift from the Claude-only
`/maintain format` sub-skill to a deterministic Node-based pipeline,
to be implemented once the `mise` toolchain is set up.

## Overview

Replace `/maintain format` with markdownlint-cli2 for both heading case
and line-length enforcement. This gives deterministic, CI-runnable
formatting that works identically in CLI and Neovim.

## Components

### 1. markdownlint-cli2

Install via Homebrew or mise:

```bash
brew install markdownlint-cli2
# or
mise install markdownlint-cli2
```

### 2. markdownlint-rule-title-case-style

Custom npm rule for heading case enforcement:

```bash
npm install --save-dev markdownlint-rule-title-case-style
```

### 3. `.markdownlint-cli2.jsonc`

Config file at project root:

```jsonc
{
  // Line length (MD013)
  "MD013": {
    "line_length": 80,
    "code_blocks": false,
    "tables": false,
    "headings": false
  },
  // Title case for headings
  "customRules": [
    "markdownlint-rule-title-case-style"
  ],
  // Ignore paths
  "ignores": [
    "_site/**",
    "_freeze/**",
    "_extensions/**",
    "renv/**"
  ]
}
```

### 4. `.editorconfig`

For Neovim `textwidth=80` via `max_line_length`:

```ini
root = true

[*.qmd]
max_line_length = 80
indent_style = space
indent_size = 2
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.md]
max_line_length = 80
indent_style = space
indent_size = 2
```

### 5. Justfile recipes

```just
# Format QMD files (check only)
format:
    markdownlint-cli2 "posts/**/*.qmd"

# Format QMD files (fix)
format-fix:
    markdownlint-cli2 --fix "posts/**/*.qmd"
```

### 6. conform.nvim integration

In Neovim config, use markdownlint-cli2 as the formatter for `.qmd`
files via conform.nvim:

```lua
require("conform").setup({
  formatters_by_ft = {
    quarto = { "markdownlint-cli2" },
    markdown = { "markdownlint-cli2" },
  },
})
```

This ensures `gq` and format-on-save use the same rules as the CLI,
producing identical output in both environments.

## Migration Path

1. Set up `mise` toolchain with Node
2. Install markdownlint-cli2 and the title-case rule
3. Create `.markdownlint-cli2.jsonc` and `.editorconfig`
4. Add `format` / `format-fix` Justfile recipes
5. Run `just format` — verify it catches the same issues as
   `/maintain format`
6. Configure conform.nvim for editor integration
7. `/maintain format` remains available as a fallback for
   Quarto-aware edge cases (nested fenced divs, complex math)

## Why Not Prettier / dprint / mdformat?

These general-purpose formatters risk corrupting Quarto-specific
syntax:
- Fenced divs (`:::` callouts, `.column-margin`, theorem environments)
- Shortcodes (`{{< include >}}`, `{{< iconify >}}`)
- Cross-references and citations

markdownlint-cli2 with `--fix` only modifies what its rules target
(line length, heading case), leaving all other syntax untouched.

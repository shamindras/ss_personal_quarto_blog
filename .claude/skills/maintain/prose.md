# Maintain: Prose

Proofreading — errors only, never rewrite author's voice.

## Inputs

- **Scope**: List of resolved post directories (from `commands/maintain.md`).
- **Mode**: Dry-run (default) or `--apply`.

## Scope Rules

- **Skip**: `{{< include >}}` fragment content (maintained separately)
- **Skip**: Code blocks (fenced and inline)
- **Skip**: YAML frontmatter
- **Skip**: URLs and file paths
- **Skip**: LaTeX math expressions (`$...$` and `$$...$$`)
- **Check**: All remaining prose in the QMD body

## Checks

### 1. Spelling errors

Flag clear misspellings. Ignore:
- Technical terms, package names, function names
- Proper nouns
- Words in code formatting (backticks)

### 2. Grammar errors

Flag objective grammar errors only:
- Subject-verb agreement
- Missing articles where clearly wrong
- Incorrect tense usage
- Sentence fragments that are clearly unintentional

**Do NOT flag**: Stylistic choices, informal tone, sentence length, passive
voice, or anything that could be the author's intentional voice.

### 3. Broken links

Check all markdown links in the post body:
- Internal links: verify the target file exists on disk
- External links: flag obviously malformed URLs (missing protocol, clearly
  incomplete domains)
- Empty links: `[text]()` or `[text](#)` — always flag
- Placeholder links: `[text](TODO)` or similar — always flag

Note: Do NOT make HTTP requests to verify external links. Only flag
structurally broken ones.

### 4. Logic errors / factual inconsistencies

Flag only clear, objective issues:
- Contradictions within the same post
- Incorrect date references (e.g., "published in 2020" in a 2019 post)
- Mismatched cross-references (referring to "Part 1" when linking to Part 3)

## Output Format

### Summary table

Always start with a summary table showing finding counts per post:

```
| # | Post | spelling | grammar | links | logic | Total |
|---|------|----------|---------|-------|-------|-------|
| 1 | shrotriya2019distillpt1 | 1 | - | 2 | - | 3 |
| ...| | | | | | |
```

Summary line: `Found N issues in M posts. (K posts clean.)`

### Before/after detail tables

**Required for every dry-run and --apply presentation.** After the summary
table, show a per-post before/after table for every post with findings.
The user cannot evaluate or approve changes without seeing the concrete
before and after values.

```
#### <post-slug>

| # | Type | Location | Before | After |
|---|------|----------|--------|-------|
| 1 | spelling | Line 42 | `recieve` | `receive` |
| 2 | grammar | Line 87 | `the data are collected` | `the data is collected` |
| 3 | broken-link | Line 15 | `[here]()` | `[here](https://...)` or remove link |
```

Every finding must show the literal current text and the literal proposed
replacement. Include 1-2 surrounding words for context. Never present a
finding without both columns filled.

## Approval Flow

1. Present summary table + all before/after detail tables.
2. **Post selection**: Checkbox list of posts with finding counts. Clean
   posts omitted.
3. **Finding selection**: For each selected post, author accepts or rejects
   each finding individually by number.
4. If `--apply`: write approved changes to disk.
   If dry-run: show what would change, then stop.

Shortcuts: User can say "accept all" or "skip all" at any step.

## Important

- Never rewrite the author's voice or style.
- When in doubt about whether something is an error vs. intentional style,
  **do not flag it**.
- Present suggestions as exactly that — suggestions. The author has final say.

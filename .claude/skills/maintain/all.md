# Maintain: All

Run all maintenance sub-skills in sequence.

## Inputs

- **Scope**: List of resolved post directories (from `commands/maintain.md`).
- **Mode**: Dry-run (default) or `--apply`.
- **Exclusions**: List of sub-skill names to skip (from `--except` flag).

## Execution Order

The full sub-skill list, in order (corrective first, validation last):

1. **legacy** — deepest structural changes (HTML cleanup)
2. **tags** — frontmatter normalization
3. **format** — heading case normalization, prose wrapping at 80 chars
4. **ally** — accessibility additions (alt-text, image-alt)
5. **assets** — thumbnail/image fixes
6. **prose** — proofreading on settled content
7. **lint** — final validation pass catches anything others introduced

If `--except` was provided, remove the listed sub-skills from this
sequence before proceeding. E.g., `--except lint tags` reduces the
list to: legacy, format, ally, assets, prose.

## Matrix-First Approach

When running all sub-skills, use a summary matrix instead of sequential
traversal:

### Step 1: Full scan

Run all non-excluded sub-skills against all in-scope posts in one pass.
Collect all findings without interaction. Read each sub-skill file to
understand its checks, then execute them all. Excluded sub-skills are
not scanned and do not appear in the matrix.

### Step 2: Summary matrix

Present findings as a table — posts as rows, skills as columns, finding
counts in cells. `-` means clean.

```
                           legacy tags ally assets prose lint
shrotriya2019distillpt1       3    1    1     1     -    2
shrotriya2019tidyfunpt1       -    1    1     1     -    1
shrotriya2019reprtitanic      -    1    1     1     -    1
...
```

Include a total row at the bottom.

### Step 3: Navigation choice

Ask the user how they want to drill into findings:

- **By column** (skill-first): "Fix all tags across posts"
  → Runs the approval flow from that skill's `.md` file for all posts.
- **By row** (post-first): "Clean up distillpt1 fully"
  → Runs findings from all skills for that one post.
- **By cell**: "Show the 3 legacy findings in distillpt1"
  → Shows specific skill's findings for one post.
- **Skip column/row**: User can deselect entire skills or posts from the
  matrix before drilling in.

### Step 4: Finding selection

Within each drill-in, present the before/after detail tables as defined in
each sub-skill's `.md` file. Every finding must show the literal current
text and literal proposed replacement — the user cannot evaluate changes
without seeing concrete before and after values.

### Step 5: Return to matrix

After each drill-in, return to the matrix (updated to reflect applied
changes). User continues until done or says "done" to bail.

## Bail-out

At any point the user can say "done", "stop", or "bail" to exit the
`/maintain all` flow. Any already-applied changes (if `--apply`) are kept.

## Output

After all drill-ins are complete (or user bails), show a final summary:

```
Maintenance complete.
  Applied: N changes across M posts
  Skipped: K findings
  Remaining: J findings (not reviewed)
```

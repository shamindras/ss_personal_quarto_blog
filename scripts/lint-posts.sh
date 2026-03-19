#!/usr/bin/env bash
# Blog post linting — checks frontmatter fields across all posts.
# Same checks as /maintain lint (subset: required fields only).

set -euo pipefail

posts_dir="posts"
issues=0
clean=0
total=0

printf "🔍 Running blog lint checks...\n"
printf "Checking required frontmatter fields across all posts.\n\n"

for dir in "$posts_dir"/*/; do
    qmd="$dir/index.qmd"
    [ -f "$qmd" ] || continue

    slug=$(basename "$dir")
    total=$((total + 1))
    missing=""

    # Extract frontmatter (between first two --- lines)
    front=$(awk '/^---$/{n++; next} n==1{print} n==2{exit}' "$qmd")

    for field in title description date categories image image-alt; do
        if ! echo "$front" | grep -q "^${field}:"; then
            missing="$missing $field"
        fi
    done

    if [ -n "$missing" ]; then
        printf "  ⚠️  %s — missing:%s\n" "$slug" "$missing"
        issues=$((issues + 1))
    else
        printf "  ✅ %s\n" "$slug"
        clean=$((clean + 1))
    fi
done

printf "\n%d posts checked: %d clean, %d with issues.\n" "$total" "$clean" "$issues"

if [ "$issues" -gt 0 ]; then
    printf "\nRun /maintain lint for detailed findings and fixes.\n"
fi

#!/usr/bin/env bash
# repo-hygiene.sh — Structural checks for the Quarto blog repo
set -euo pipefail

PASS=0
FAIL=0

pass() { PASS=$((PASS + 1)); printf "  ✅ %s\n" "$1"; }
fail() { FAIL=$((FAIL + 1)); printf "  ❌ %s\n" "$1"; }

# ---------- 1. Audit: tracked files that should be ignored ----------
printf "\n🔍 Audit: tracked files that should be ignored\n"

relics=("README.html" "profile.jpg")
for f in "${relics[@]}"; do
    if git ls-files --error-unmatch "$f" &>/dev/null; then
        fail "$f is still tracked"
    else
        pass "$f not tracked"
    fi
done

# ---------- 2. Audit: orphaned symlinks ----------
printf "\n🔍 Audit: orphaned symlinks in posts/\n"

orphaned=0
while IFS= read -r -d '' link; do
    if [[ ! -e "$link" ]]; then
        fail "broken symlink: $link"
        orphaned=1
    fi
done < <(find posts/ -type l -print0 2>/dev/null)
[[ $orphaned -eq 0 ]] && pass "no broken symlinks"

# ---------- 3. Audit: non-underscore QMDs in includes ----------
printf "\n🔍 Audit: non-underscore QMDs in data/qmds/includes/\n"

bad_includes=0
if [[ -d data/qmds/includes ]]; then
    while IFS= read -r -d '' qmd; do
        base=$(basename "$qmd")
        if [[ "$base" != _* ]]; then
            fail "$qmd lacks underscore prefix"
            bad_includes=1
        fi
    done < <(find data/qmds/includes/ -name "*.qmd" -print0 2>/dev/null)
    [[ $bad_includes -eq 0 ]] && pass "all include QMDs have underscore prefix"
else
    fail "data/qmds/includes/ directory missing"
fi

# ---------- 4. Audit: legacy freeze artifacts ----------
printf "\n🔍 Audit: legacy _freeze/ artifacts\n"

# Check for any freeze stem dir that isn't index/ (depth 2 = post-dir/stem)
legacy_found=0
while IFS= read -r -d '' fdir; do
    stem=$(basename "$fdir")
    if [[ "$stem" != "index" ]]; then
        fail "legacy freeze artifact: $fdir"
        legacy_found=1
    fi
done < <(find _freeze/posts/ -mindepth 2 -maxdepth 2 -type d -print0 2>/dev/null)
if git ls-files --error-unmatch _freeze/site_libs/ &>/dev/null; then
    fail "_freeze/site_libs/ is still tracked"
    legacy_found=1
fi
[[ $legacy_found -eq 0 ]] && pass "no legacy freeze artifacts"

# ---------- 5. Structure: every post dir has index.qmd ----------
printf "\n🔍 Structure: post directories\n"

missing_index=0
while IFS= read -r -d '' pdir; do
    if [[ ! -f "$pdir/index.qmd" ]]; then
        fail "$pdir missing index.qmd"
        missing_index=1
    fi
done < <(find posts/ -mindepth 1 -maxdepth 1 -type d ! -name '_*' -print0 2>/dev/null)
[[ $missing_index -eq 0 ]] && pass "all post directories have index.qmd"

# ---------- 6. Orphan scan: images in data/ not referenced ----------
printf "\n🔍 Orphan scan: unreferenced images in data/images/\n"

orphan_img=0
if [[ -d data/images ]]; then
    while IFS= read -r -d '' img; do
        base=$(basename "$img")
        if ! grep -rq "$base" --include="*.qmd" --include="*.yml" --include="*.yaml" . 2>/dev/null; then
            fail "unreferenced image: $img"
            orphan_img=1
        fi
    done < <(find data/images/ -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.svg" \) -print0 2>/dev/null)
    [[ $orphan_img -eq 0 ]] && pass "all data/images/ files are referenced"
fi

# ---------- Summary ----------
printf "\n📊 Summary: %d passed, %d failed\n\n" "$PASS" "$FAIL"
[[ $FAIL -eq 0 ]] && exit 0 || exit 1

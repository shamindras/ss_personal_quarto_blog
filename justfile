_default:
    @just --choose --unsorted

# Start dev server with drafts visible (clean build + live reload)
dev: clean
    @printf "🔧 Starting dev preview (drafts visible)...\n"
    quarto preview --profile dev

# Start production server with drafts hidden (clean build + live reload)
prod: clean
    @printf "📦 Starting prod preview (drafts hidden)...\n"
    quarto preview

# Clean rendered output
clean:
    @printf "🧹 Cleaning _site/ and .quarto/ cache...\n"
    @rm -rf _site/ .quarto/
    @printf "✅ Cleaned!\n"

# Run all repo structure and hygiene checks
repo-hygiene:
    @bash scripts/repo-hygiene.sh

# Restore R dependencies
renv-restore:
    @printf "📚 Restoring R packages from renv.lock...\n"
    @Rscript -e 'renv::restore()'
    @printf "✅ R packages restored!\n"

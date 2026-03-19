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

# Run blog linting checks (same checks as /maintain lint)
lint:
    @bash scripts/lint-posts.sh

# Run all repo structure and hygiene checks
repo-hygiene:
    @bash scripts/repo-hygiene.sh

# Render README.qmd to README.md for GitHub
readme:
    quarto render README.qmd

# Lossless PNG compression across all posts and shared images
img-optimize:
    @printf "Optimizing images...\n"
    @find posts data/images -name "*.png" -exec oxipng -o 4 --strip safe {} +
    @printf "Done!\n"

# Restore R dependencies
renv-restore:
    @printf "📚 Restoring R packages from renv.lock...\n"
    @Rscript -e 'renv::restore()'
    @printf "✅ R packages restored!\n"

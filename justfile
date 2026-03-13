# Default: list available commands
default:
    @just --list

# Start dev server with drafts visible (clean build + live reload)
dev: clean
    @echo "🔧 Starting dev preview (drafts visible)..."
    quarto preview --profile dev

# Build production site and stage for commit (drafts hidden)
build: clean
    @echo "📦 Building site (production mode)..."
    quarto render
    @echo "📋 Staging _site/ for commit..."
    git add _site/
    @echo "✅ Site built and staged — ready to commit"

# Clean rendered output
clean:
    @echo "🧹 Cleaning _site/ directory..."
    rm -rf _site/
    @echo "✅ Cleaned"

# Restore R dependencies
renv-restore:
    @echo "📚 Restoring R packages from renv.lock..."
    Rscript -e 'renv::restore()'
    @echo "✅ R packages restored"

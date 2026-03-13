# Default: list available commands
default:
    @just --list

# Preview site locally (production mode, drafts hidden)
preview:
    @echo "🌐 Starting preview (production mode)..."
    quarto preview

# Preview site locally with draft posts visible
preview-dev:
    @echo "🔧 Starting preview with drafts visible..."
    quarto preview --profile dev

# Full site render (production mode, drafts hidden)
render:
    @echo "📦 Rendering site (production mode)..."
    quarto render
    @echo "✅ Site rendered to _site/"

# Full site render with draft posts visible
render-dev:
    @echo "🔧 Rendering site with drafts visible..."
    quarto render --profile dev
    @echo "✅ Site rendered to _site/ (including drafts)"

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

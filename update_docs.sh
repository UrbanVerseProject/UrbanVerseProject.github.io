#!/bin/bash
# Quick script to rebuild and deploy documentation

set -e  # Exit on error

echo "🔄 Updating documentation..."

# Navigate to documentation directory
cd "$(dirname "$0")/documentation"

# Check if virtual environment exists
if [ -d "venv" ]; then
    echo "🔌 Activating virtual environment..."
    source venv/bin/activate
fi

# Rebuild documentation
echo "🏗️  Rebuilding documentation from source files..."
make current-docs

# Check if build was successful
if [ ! -f "_build/current/index.html" ]; then
    echo "❌ Build failed! index.html not found."
    exit 1
fi

# Go back to repository root
cd ..

# Deploy to docs/ folder
echo "📦 Deploying to docs/ folder..."
rm -rf docs/*
cp -r documentation/_build/current/* docs/

# Fix absolute paths in HTML files
echo "🔧 Fixing absolute paths for GitHub Pages..."
# Fix FontAwesome paths
find docs/ -name "*.html" -type f -exec sed -i '' \
  -e 's|href="/Users/[^"]*fontawesome-free/css/all.min.css"|href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"|g' \
  -e 's|src="/Users/[^"]*fontawesome-free/js/all.min.js"|src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"|g' \
  {} \; 2>/dev/null || \
find docs/ -name "*.html" -type f -exec sed -i \
  -e 's|href="/Users/[^"]*fontawesome-free/css/all.min.css"|href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"|g' \
  -e 's|src="/Users/[^"]*fontawesome-free/js/all.min.js"|src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"|g' \
  {} \;

# Remove canonical URLs with absolute paths (they can cause issues with private repos)
find docs/ -name "*.html" -type f -exec sed -i '' \
  -e 's|<link rel="canonical" href="https://[^"]*github\.io[^"]*" />||g' \
  {} \; 2>/dev/null || \
find docs/ -name "*.html" -type f -exec sed -i \
  -e 's|<link rel="canonical" href="https://[^"]*github\.io[^"]*" />||g' \
  {} \;

# Fix paths to work from /docs/ subdirectory
# Convert root-relative paths (starting with /) to relative paths
# Fix canonical URLs and data-url_root
find docs/ -name "*.html" -type f -exec sed -i '' \
  -e 's|href="/\([^h][^t][^t][^p]\)|href="./\1|g' \
  -e 's|src="/\([^h][^t][^t][^p]\)|src="./\1|g' \
  -e 's|href="/docs/|href="./|g' \
  -e 's|src="/docs/|src="./|g' \
  -e 's|href="./docs/|href="./|g' \
  -e 's|data-url_root="[^"]*"|data-url_root="./"|g' \
  -e 's|<link rel="canonical" href="[^"]*docs/[^"]*" />||g' \
  {} \; 2>/dev/null || \
find docs/ -name "*.html" -type f -exec sed -i \
  -e 's|href="/\([^h][^t][^t][^p]\)|href="./\1|g' \
  -e 's|src="/\([^h][^t][^t][^p]\)|src="./\1|g' \
  -e 's|href="/docs/|href="./|g' \
  -e 's|src="/docs/|src="./|g' \
  -e 's|href="./docs/|href="./|g' \
  -e 's|data-url_root="[^"]*"|data-url_root="./"|g' \
  -e 's|<link rel="canonical" href="[^"]*docs/[^"]*" />||g' \
  {} \;

# Fix JavaScript files that might have hardcoded paths
find docs/ -name "*.js" -type f -exec sed -i '' \
  -e 's|"/docs/|"./|g' \
  -e "s|'/docs/|'./|g" \
  {} \; 2>/dev/null || \
find docs/ -name "*.js" -type f -exec sed -i \
  -e 's|"/docs/|"./|g' \
  -e "s|'/docs/|'./|g" \
  {} \;

echo "✅ Documentation updated successfully!"
echo ""
echo "📁 Updated files are in: docs/"
echo ""
echo "Next steps:"
echo "  1. Review changes: git status"
echo "  2. Commit: git add documentation/source/ docs/"
echo "  3. Push: git commit -m 'Update documentation' && git push"


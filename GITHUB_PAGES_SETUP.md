# GitHub Pages Setup Solution

## Problem
- If GitHub Pages serves from `/docs`, the main page at root (`index.html`) is not accessible
- If GitHub Pages serves from `/root`, the main page works but documentation assets don't load correctly

## Solution: Serve from Root with Relative Paths

### Configuration

1. **GitHub Pages Settings:**
   - Go to: https://github.com/UrbanVerseProject/UrbanVerseProject.github.io/settings/pages
   - Set **Source**: `Deploy from a branch`
   - Set **Branch**: `main` (or your default branch)
   - Set **Folder**: `/ (root)` ← **This is the key!**

2. **File Structure:**
   ```
   /
   ├── index.html          ← Main UrbanVerse page (served at /)
   ├── static/             ← Main page assets
   ├── docs/               ← Documentation (served at /docs/)
   │   ├── index.html      ← Documentation homepage
   │   ├── _static/        ← Documentation assets
   │   └── ...
   └── documentation/      ← Source files for building docs
   ```

3. **URLs:**
   - Main page: `https://urbanverseproject.github.io/`
   - Documentation: `https://urbanverseproject.github.io/docs/`

### How It Works

When GitHub Pages serves from `/root`:
- ✅ `index.html` at root is accessible at `/`
- ✅ `docs/index.html` is accessible at `/docs/`
- ✅ All relative paths in docs work correctly from `/docs/` subdirectory
- ✅ Main page assets work from root

### Key Configuration Files

1. **`documentation/conf.py`:**
   ```python
   html_baseurl = ""  # Empty for relative paths
   ```
   This ensures Sphinx generates relative paths that work from any subdirectory.

2. **`update_docs.sh`:**
   - Automatically fixes any absolute paths to relative paths
   - Converts `/docs/` paths to `./` (relative)
   - Fixes FontAwesome paths to use CDN

### Testing

After deploying:

1. **Test main page:**
   ```
   https://urbanverseproject.github.io/
   ```
   Should show your UrbanVerse research page.

2. **Test documentation:**
   ```
   https://urbanverseproject.github.io/docs/
   ```
   Should show documentation with all assets loading correctly.

3. **Check browser console:**
   - Open DevTools (F12)
   - Check for 404 errors on assets
   - All paths should be relative (starting with `./` or `../`)

### Troubleshooting

If assets don't load in docs:

1. **Rebuild documentation:**
   ```bash
   ./update_docs.sh
   ```

2. **Check paths in generated HTML:**
   ```bash
   grep -r 'href="/' docs/ | head -10
   grep -r 'src="/' docs/ | head -10
   ```
   Should find minimal or no absolute paths (except CDN URLs like `https://`).

3. **Verify .nojekyll exists:**
   ```bash
   ls -la docs/.nojekyll
   ```
   This file tells GitHub Pages not to process files with Jekyll.

### Alternative: Add Link from Main Page to Docs

You can add a link to documentation in your main `index.html`:

```html
<a href="./docs/" style="...">Documentation</a>
```

This makes it easy for users to navigate from the main page to the docs.


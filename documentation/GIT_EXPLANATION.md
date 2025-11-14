# Git Repository Structure Explanation

## Why Some Files Are/Are Not Committed

### ✅ Files That SHOULD Be Committed

1. **Source Files** (`documentation/source/`):
   - All `.rst` and `.md` files - **SHOULD be committed**
   - These are your source documentation files
   - Currently: **All source files ARE tracked**

2. **Configuration Files**:
   - `conf.py` - Sphinx configuration
   - `index.rst` - Main documentation index
   - `Makefile` - Build instructions
   - `requirements.txt` - Python dependencies
   - **All SHOULD be committed**

3. **Built Documentation** (`docs/` folder):
   - All HTML files in `docs/` - **SHOULD be committed**
   - These are the deployed documentation files
   - Currently: **All files in `docs/` ARE tracked**

### ❌ Files That Should NOT Be Committed

1. **Build Artifacts** (`documentation/_build/`):
   - **Typically should NOT be committed** (but currently are)
   - These are generated files that can be rebuilt
   - Should be in `.gitignore`

2. **Virtual Environment** (`documentation/venv/`):
   - **Should NOT be committed** ✅ (currently ignored)
   - Can be recreated with `pip install -r requirements.txt`

3. **Temporary Files**:
   - `.DS_Store` (macOS)
   - `*.pyc` (Python cache)
   - `__pycache__/` directories

## Current Status

Based on the repository check:

- ✅ **Source files** (`documentation/source/`) - **All tracked**
- ✅ **Built docs** (`docs/`) - **All tracked** (481 files)
- ⚠️ **Build folder** (`documentation/_build/`) - **Currently tracked** (but shouldn't be)
- ✅ **Virtual environment** (`documentation/venv/`) - **Correctly ignored**

## Best Practice Recommendation

### Option 1: Don't Commit `_build/` (Recommended)

The `_build/` folder contains generated files that can be rebuilt. You should:

1. **Add to `.gitignore`**:
   ```bash
   echo "documentation/_build/" >> .gitignore
   ```

2. **Remove from git** (but keep files locally):
   ```bash
   git rm -r --cached documentation/_build/
   git commit -m "Stop tracking _build folder"
   ```

3. **Why?**
   - `_build/` can be regenerated with `make current-docs`
   - Reduces repository size
   - Avoids merge conflicts on generated files
   - Only `docs/` needs to be committed (for GitHub Pages)

### Option 2: Keep `_build/` Committed (Current Approach)

If you want to keep `_build/` committed:
- ✅ Pros: Can view built docs without rebuilding
- ❌ Cons: Larger repo, merge conflicts on generated files

## Recommended `.gitignore` File

Create a `.gitignore` in the repository root:

```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python

# Virtual Environment
documentation/venv/
venv/
env/
ENV/

# Build artifacts (optional - uncomment if you don't want to track _build)
# documentation/_build/

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Documentation build (if not tracking)
# documentation/_build/current/
```

## Summary

**Your current setup:**
- ✅ Source files are tracked (correct)
- ✅ `docs/` folder is tracked (correct - needed for GitHub Pages)
- ⚠️ `_build/` is tracked (optional - can be ignored)
- ✅ `venv/` is ignored (correct)

**Recommendation:**
- Keep source files tracked ✅
- Keep `docs/` tracked ✅ (needed for deployment)
- Consider ignoring `_build/` (can be regenerated)
- Keep `venv/` ignored ✅

The files you see in `_build/` and `source/` that are "not committed" might be:
1. New files you just created (need to `git add`)
2. Files that are already committed (check with `git ls-files`)
3. Files that should be ignored (like `venv/`)


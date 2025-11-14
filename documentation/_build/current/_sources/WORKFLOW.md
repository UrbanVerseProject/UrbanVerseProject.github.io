# Documentation Update Workflow

## ⚠️ Important: Don't Edit HTML Files Directly!

The HTML files in `docs/` are **automatically generated** from source files. If you edit them directly, your changes will be **lost** when you rebuild the documentation.

## ✅ Correct Workflow

### Step 1: Edit Source Files

Edit the **source files** (RST or Markdown) in `documentation/source/`:

```
documentation/
└── source/
    ├── setup/
    │   └── installation/
    │       ├── index.rst          ← Edit these files
    │       ├── asset_caching.rst  ← Not the HTML files!
    │       └── ...
    ├── overview/
    │   ├── simulation.rst         ← Edit these files
    │   └── ...
    └── ...
```

**Main source files:**
- `documentation/index.rst` - Main documentation homepage
- `documentation/source/setup/` - Installation guides
- `documentation/source/overview/` - Overview documentation
- `documentation/source/developer/` - Developer guides
- `documentation/source/refs/` - References

### Step 2: Rebuild Documentation

After editing source files, rebuild the HTML:

#### Option A: Using Make (Recommended)

```bash
# Navigate to documentation folder
cd documentation

# Activate virtual environment (if you have one)
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Rebuild documentation
make current-docs
```

#### Option B: Using Sphinx Directly

```bash
cd documentation
sphinx-build . _build/current
```

### Step 3: Deploy Updated Documentation

Copy the newly built HTML files to the `docs/` folder:

```bash
# From repository root
rm -rf docs/*
cp -r documentation/_build/current/* docs/
```

**Windows:**
```cmd
rmdir /s /q docs
xcopy /E /I documentation\_build\current\* docs\
```

### Step 4: Commit and Push

```bash
git add documentation/source/  # Your source changes
git add docs/                  # Updated HTML files
git commit -m "Update documentation: [describe your changes]"
git push
```

## 📝 Quick Reference: File Locations

| What to Edit | Location | Example |
|-------------|----------|---------|
| **Main page** | `documentation/index.rst` | Welcome page content |
| **Installation** | `documentation/source/setup/installation/*.rst` | Installation guides |
| **Overview** | `documentation/source/overview/*.rst` | Simulation, environments |
| **Developer** | `documentation/source/developer/*.rst` | Code structure docs |
| **References** | `documentation/source/refs/*.rst` | Licenses, assets |

## 🔄 Complete Update Example

Let's say you want to update the installation guide:

```bash
# 1. Edit the source file
# Open: documentation/source/setup/installation/index.rst
# Make your changes and save

# 2. Rebuild
cd documentation
make current-docs

# 3. Deploy
cd ..
rm -rf docs/*
cp -r documentation/_build/current/* docs/

# 4. Commit
git add documentation/source/setup/installation/index.rst
git add docs/
git commit -m "Update installation guide with new steps"
git push
```

## 🛠️ Setting Up Build Environment (First Time)

If you haven't set up the build environment yet:

```bash
# Navigate to documentation folder
cd documentation

# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Now you can build
make current-docs
```

## 📚 Understanding RST Format

The source files use **reStructuredText (RST)** format. Here are common patterns:

```rst
Title
=====

Section
-------

Subsection
~~~~~~~~~~

**Bold text**

*Italic text*

`Link text <https://example.com>`_

.. code-block:: python

    def example():
        pass

.. note::
    This is a note.

.. warning::
    This is a warning.
```

## 🎯 Common Tasks

### Add a New Page

1. Create new `.rst` file in appropriate `source/` subdirectory
2. Add it to the table of contents in `index.rst` or parent `.rst` file
3. Rebuild and deploy

### Update Images

1. Add image to `documentation/source/_static/` or `documentation/assets/`
2. Reference in RST: `.. image:: _static/myimage.png`
3. Rebuild and deploy

### Change Configuration

Edit `documentation/conf.py` for:
- Theme settings
- Project name
- Extensions
- etc.

Then rebuild.

## ⚡ Quick Script for Updates

Create a script `update_docs.sh` in repository root:

```bash
#!/bin/bash
cd documentation
make current-docs
cd ..
rm -rf docs/*
cp -r documentation/_build/current/* docs/
echo "✅ Documentation updated! Now commit and push."
```

Make it executable: `chmod +x update_docs.sh`

Then just run: `./update_docs.sh`

## 🐛 Troubleshooting

### Changes not showing up?

1. **Did you rebuild?** - HTML files are generated, you must rebuild
2. **Did you deploy?** - Copy from `_build/current/` to `docs/`
3. **Did you commit?** - Make sure `docs/` folder is committed
4. **GitHub Pages cache?** - Wait a few minutes or force refresh (Ctrl+F5)

### Build errors?

- Check RST syntax
- Ensure all dependencies installed: `pip install -r requirements.txt`
- Check for missing images or broken links

### Want to preview before deploying?

```bash
cd documentation/_build/current
python3 -m http.server 8000
# Then visit http://localhost:8000
```

## 📖 Summary

**Remember:**
1. ✅ Edit **source files** (`.rst` in `documentation/source/`)
2. ✅ **Rebuild** with `make current-docs`
3. ✅ **Deploy** by copying to `docs/`
4. ✅ **Commit** both source and HTML files
5. ❌ **Don't** edit HTML files in `docs/` directly


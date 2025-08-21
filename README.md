# Gabriel Faúndez - Curriculum Vitae

[![Build LaTeX - Production](https://github.com/FarDust/curriculum-vitae/actions/workflows/build-production.yml/badge.svg)](https://github.com/FarDust/curriculum-vitae/actions/workflows/build-production.yml)
[![Build LaTeX - Develop](https://github.com/FarDust/curriculum-vitae/actions/workflows/build-develop.yml/badge.svg)](https://github.com/FarDust/curriculum-vitae/actions/workflows/build-develop.yml)

Professional curriculum vitae built with LaTeX using the [Awesome CV](https://github.com/posquit0/Awesome-CV) template. This repository automatically compiles and deploys multiple document formats with different CI/CD workflows for development and production environments.

## 📄 Document Types

This repository generates three types of professional documents:

- **CV** (`cv-gabriel-faundez.pdf`) - Complete curriculum vitae with detailed experience
- **Resume** (`resume-gabriel-faundez.pdf`) - Concise professional summary
- **Portfolio** (`portfolio-gabriel-faundez.pdf`) - Project-focused document

## 🚀 Automated Workflows

### Production Builds
- **Trigger**: Pushes to `main` branch and version tags (`v*`)
- **Artifacts**: Clean names, stored in `curriculum/` on GCS
- **Retention**: Permanent (no expiration)

## 🛠️ Development & Maintenance

### Prerequisites
- XeLaTeX (TeX Live 2025 or later)
- [uv](https://docs.astral.sh/uv/) (for Python package management)
- Make (optional, for convenience commands)

### Setup
```bash
# Quick setup (installs uv and pre-commit automatically)
make setup

# Or manually
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install pre-commit
pre-commit install
```

### Building Documents
```bash
# Build resume (2-page version)
make resume

# Build CV (complete version)
make cv

# Build cover letter
make coverletter

# Build all documents
make all

# Quick single-pass build
make quick

# Watch for changes and rebuild
make watch
```

### Quality Assurance
This project uses pre-commit hooks for maintainability:

- **LaTeX formatting** with `latexindent`
- **LaTeX best practices** - citation formatting, label validation, etc.
- **LaTeX compilation** with `latexmk` (validates build success)
- **File structure validation** - tabs, line endings, executables
- **Security scanning** with GitGuardian (repository level)
- **General file hygiene** - trailing whitespace, line endings, etc.

All hooks use well-maintained external repositories - no local maintenance required!

```bash
# Run all checks manually
make lint

# Check page count
make check-pages

# Validate syntax only
make validate
```

### Project Structure
```
├── shared/           # Shared content across documents
├── resume/          # Resume-specific sections
├── cv/              # CV-specific sections
├── portfolio/       # Portfolio-specific sections
├── fonts/           # Font files
├── awesome-cv.cls   # LaTeX class file (customized)
└── Makefile         # Build automation
```
- **Features**: GitHub releases for tagged versions

### Development Builds
- **Trigger**: Pushes to `develop` branch
- **Artifacts**: Suffixed with `-dev`, stored in `curriculum/dev/` on GCS
- **Retention**: 30 days

### Pull Request Builds
- **Trigger**: Pull request events (opened, updated, reopened)
- **Artifacts**: Suffixed with `-pr-{number}`, GitHub artifacts only
- **Features**: Automatic PR comments with download links

## 🌐 Public Access

Documents are automatically uploaded to Google Cloud Storage and accessible via my portfolio website: [fardust.tralmor.com/experience](https://fardust.tralmor.com/experience)

## 🛠️ Development

### Prerequisites
- XeLaTeX distribution (for local compilation)
- Git (for version control)

### Local Build
```bash
# Compile all documents
xelatex cv-gabriel-faundez.tex
xelatex resume-gabriel-faundez.tex
xelatex portafolio-gabriel-faundez.tex
```

### Repository Structure
```
.
├── .github/workflows/          # CI/CD workflows
│   ├── build-latex.yml        # Reusable workflow template
│   ├── build-production.yml   # Production builds
│   ├── build-develop.yml      # Development builds
│   └── build-pr.yml           # Pull request builds
├── cv/                         # CV-specific content
├── resume/                     # Resume-specific content
├── portfolio/                  # Portfolio-specific content
├── shared/                     # Common LaTeX components
├── fonts/                      # Font files
├── *.tex                       # Main document files
└── awesome-cv.cls             # LaTeX class file
```

### Contributing
1. Create a feature branch from `develop`
2. Make your changes
3. Open a pull request
4. Review generated PDFs from PR artifacts
5. Merge to `develop` for testing, then `main` for production

### Deployment Environments
- **Development**: `curriculum/dev/` - For testing changes
- **Production**: `curriculum/` - For live documents
- **Pull Requests**: GitHub artifacts only - For review

## 📦 Architecture

Built with modern DevOps practices:
- **Reusable Workflows**: DRY principle with parameterized builds
- **Environment Separation**: Isolated dev/prod artifact storage
- **Automated Testing**: PR builds with instant feedback
- **Version Control**: Git tags trigger GitHub releases
- **Cloud Integration**: Seamless GCS deployment

## 🔧 Technologies

- **LaTeX**: Document compilation with XeLaTeX
- **GitHub Actions**: CI/CD automation
- **Google Cloud Storage**: Document hosting
- **Awesome CV**: Professional LaTeX template

---

*Last updated: August 2025*

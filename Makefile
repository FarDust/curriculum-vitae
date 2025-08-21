# Makefile for LaTeX CV project
# Author: Gabriel Faundez

# Variables
RESUME_FILE = resume-gabriel-faundez
CV_FILE = cv-gabriel-faundez
COVERLETTER_FILE = coverletter-gabriel-faundez
LATEX_CMD = xelatex
LATEX_FLAGS = -interaction=nonstopmode

# Default target
.DEFAULT_GOAL := resume

# Help target
.PHONY: help
help: ## Show this help message
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Clean build artifacts
.PHONY: clean
clean: ## Clean all build artifacts and backup files
	@echo "Cleaning build artifacts..."
	@rm -f *.aux *.log *.out *.fls *.fdb_latexmk *.synctex.gz *.toc *.lof *.lot *.idx *.ind *.ilg *.bbl *.blg *.bcf *.run.xml *.nav *.snm *.vrb
	@echo "Cleaning backup files..."
	@find . -name "*.bak[0-9]*" -type f -delete 2>/dev/null || true
	@echo "✓ Clean completed"

# Clean only backup files
.PHONY: clean-backups
clean-backups: ## Clean only latexindent backup files
	@echo "Cleaning backup files..."
	@find . -name "*.bak[0-9]*" -type f -delete 2>/dev/null || true
	@echo "✓ Backup files cleaned"

# Build resume
.PHONY: resume
resume: ## Build the resume PDF
	@echo "Building resume..."
	@$(LATEX_CMD) $(LATEX_FLAGS) $(RESUME_FILE).tex
	@$(LATEX_CMD) $(LATEX_FLAGS) $(RESUME_FILE).tex  # Second run for references
	@find . -name "*.bak[0-9]*" -type f -delete 2>/dev/null || true  # Clean backup files
	@echo "✓ Resume built: $(RESUME_FILE).pdf"

# Build CV
.PHONY: cv
cv: ## Build the CV PDF
	@echo "Building CV..."
	@$(LATEX_CMD) $(LATEX_FLAGS) $(CV_FILE).tex
	@$(LATEX_CMD) $(LATEX_FLAGS) $(CV_FILE).tex  # Second run for references
	@find . -name "*.bak[0-9]*" -type f -delete 2>/dev/null || true  # Clean backup files
	@echo "✓ CV built: $(CV_FILE).pdf"

# Build cover letter
.PHONY: coverletter
coverletter: ## Build the cover letter PDF
	@echo "Building cover letter..."
	@$(LATEX_CMD) $(LATEX_FLAGS) $(COVERLETTER_FILE).tex
	@$(LATEX_CMD) $(LATEX_FLAGS) $(COVERLETTER_FILE).tex  # Second run for references
	@find . -name "*.bak[0-9]*" -type f -delete 2>/dev/null || true  # Clean backup files
	@echo "✓ Cover letter built: $(COVERLETTER_FILE).pdf"

# Build all documents
.PHONY: all
all: resume cv coverletter ## Build all documents

# Quick build (single pass)
.PHONY: quick
quick: ## Quick build of resume (single pass)
	@echo "Quick building resume..."
	@$(LATEX_CMD) $(LATEX_FLAGS) $(RESUME_FILE).tex
	@echo "✓ Quick build completed: $(RESUME_FILE).pdf"

# Watch and rebuild on changes (requires inotify-tools)
.PHONY: watch
watch: ## Watch for changes and rebuild resume automatically
	@echo "Watching for changes... (Press Ctrl+C to stop)"
	@while inotifywait -e modify -r . --include='.*\.tex$$|.*\.cls$$' >/dev/null 2>&1; do \
		echo "Changes detected, rebuilding..."; \
		make quick; \
	done

# Validate LaTeX syntax
.PHONY: validate
validate: ## Validate LaTeX syntax without building PDF
	@echo "Validating LaTeX syntax..."
	@$(LATEX_CMD) -draftmode -interaction=nonstopmode $(RESUME_FILE).tex >/dev/null 2>&1 && echo "✓ Syntax validation passed" || echo "✗ Syntax validation failed"

# Install pre-commit hooks
.PHONY: setup-hooks
setup-hooks: ## Install pre-commit hooks
	@echo "Installing pre-commit hooks..."
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit install; \
		echo "✓ Pre-commit hooks installed"; \
	else \
		echo "✗ pre-commit not found. Install with: uv tool install pre-commit"; \
	fi

# Run pre-commit on all files
.PHONY: lint
lint: ## Run pre-commit hooks on all files (formatting, validation, and best practices)
	@echo "Running pre-commit hooks..."
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit run --all-files; \
	else \
		echo "✗ pre-commit not found. Install with: uv tool install pre-commit"; \
	fi

# Check PDF page count
.PHONY: check-pages
check-pages: resume ## Check page count of resume
	@if command -v pdfinfo >/dev/null 2>&1; then \
		echo "Resume page count: $$(pdfinfo $(RESUME_FILE).pdf | grep Pages | awk '{print $$2}')"; \
	else \
		echo "pdfinfo not available. Install poppler-utils to check page count."; \
	fi

# Open resume in default viewer
.PHONY: view
view: resume ## Open resume in default PDF viewer
	@if command -v xdg-open >/dev/null 2>&1; then \
		xdg-open $(RESUME_FILE).pdf; \
	elif command -v open >/dev/null 2>&1; then \
		open $(RESUME_FILE).pdf; \
	else \
		echo "Could not find command to open PDF. Please open $(RESUME_FILE).pdf manually."; \
	fi

# Development setup
.PHONY: setup
setup: ## Setup development environment with uv and pre-commit
	@echo "Setting up development environment..."
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "Installing uv..."; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
		echo "✓ uv installed"; \
	else \
		echo "✓ uv already installed"; \
	fi
	@if ! command -v pre-commit >/dev/null 2>&1; then \
		echo "Installing pre-commit with uv..."; \
		uv tool install pre-commit; \
		echo "✓ pre-commit installed"; \
	else \
		echo "✓ pre-commit already installed"; \
	fi
	@pre-commit install
	@echo "✓ Development environment setup completed"

# Show project structure
.PHONY: structure
structure: ## Show project structure
	@echo "Project structure:"
	@tree -I '*.pdf|*.log|*.aux|*.out|*.fls|*.fdb_latexmk|*.synctex.gz' . || ls -la

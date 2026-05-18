# Common operations for these dotfiles.
# Run `just` to list available recipes.
#
# https://github.com/casey/just

set shell := ["bash", "-euo", "pipefail", "-c"]

DOTFILES := justfile_directory()

# Show available recipes.
default:
    @just --list

# Run the full setup (installs apps, symlinks dotfiles, applies macOS prefs).
setup:
    bash {{DOTFILES}}/src/os/setup.sh

# (Re)create the standard symlinks (bash, git, tmux, vim).
link:
    bash {{DOTFILES}}/src/os/create_symbolic_links.sh

# Symlink the shared VS Code / Cursor configs.
link-editors:
    bash {{DOTFILES}}/src/os/link_vscode_configs.sh

# Run all installers (Homebrew, casks, CLI tools, language runtimes).
install:
    bash {{DOTFILES}}/src/os/installs/main.sh

# Apply only the Brewfile (formulae + casks + MAS apps).
bundle:
    brew bundle --no-lock --file={{DOTFILES}}/Brewfile

# Show what's installed vs. what the Brewfile expects.
bundle-check:
    brew bundle check --verbose --file={{DOTFILES}}/Brewfile

# Regenerate the Brewfile from currently-installed packages.
# Use with care — overwrites the committed Brewfile.
bundle-dump:
    brew bundle dump --file={{DOTFILES}}/Brewfile --force

# Apply macOS defaults.
prefs:
    bash {{DOTFILES}}/src/os/preferences/main.sh

# Update everything (system + Homebrew + Node + pnpm).
update:
    sudo softwareupdate --install --all
    brew update
    brew upgrade
    brew cleanup
    -mas upgrade
    -npm update -g
    -pnpm update -g

# Lint shell scripts with shellcheck.
lint-shell:
    bash {{DOTFILES}}/scripts/lint/shell.sh

# Lint markdown files.
lint-md:
    bash {{DOTFILES}}/scripts/lint/markdown.sh

# Run all linters.
lint: lint-shell lint-md

# Check repo health (lint + broken links).
check: lint
    bash {{DOTFILES}}/scripts/check_links/markdown.sh

# Common operations for these dotfiles.
# Run `just` to list available recipes.
#
# https://github.com/casey/just

set shell := ["bash", "-euo", "pipefail", "-c"]

DOTFILES := justfile_directory()

# Show available recipes.
default:
    @just --list

# Full setup: `just setup personal|work|server` (remembered in ~/.dotfiles_profile).
setup profile="":
    bash {{DOTFILES}}/src/os/setup.sh {{ if profile != "" { "--profile " + profile } else { "" } }}

# Set up (or re-run on) the home server.
setup-server: (setup "server")

# Set up key-based SSH from this laptop to the home server.
server-key:
    bash {{DOTFILES}}/src/os/set_server_ssh_key.sh

# (Re)create the standard symlinks (bash, git, tmux, vim).
link:
    bash {{DOTFILES}}/src/os/create_symbolic_links.sh

# Symlink the shared VS Code / Cursor configs.
link-editors:
    bash {{DOTFILES}}/src/os/link_vscode_configs.sh

# Run all installers (Homebrew, casks, CLI tools, language runtimes).
install:
    bash {{DOTFILES}}/src/os/installs/main.sh

# Apply this machine's Brewfile layers (formulae + casks + MAS apps).
bundle:
    bash {{DOTFILES}}/src/os/installs/macos/brewfile.sh

# Show what's missing from this machine's Brewfile layers.
bundle-check:
    bash {{DOTFILES}}/src/os/installs/macos/brewfile.sh --check

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

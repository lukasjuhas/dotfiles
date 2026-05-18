# Declarative Homebrew install list. Applied via `brew bundle` from
# `src/os/installs/macos/brewfile.sh`.
#
# To check current state vs. this file:    brew bundle check --file=Brewfile
# To install everything missing:           brew bundle --file=Brewfile
# To regenerate from installed packages:   brew bundle dump --file=Brewfile --force
#
# https://github.com/Homebrew/homebrew-bundle

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Shell & terminal
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew "bash"
brew "bash-completion@2"
brew "tmux"
brew "zellij"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Modern CLI quality-of-life
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew "bat"
brew "direnv"
brew "eza"
brew "fd"
brew "fzf"
brew "git-delta"
brew "mole"      # https://github.com/tw93/Mole — Mac cleanup
brew "ripgrep"
brew "tree"
brew "zoxide"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Dev workflow
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew "gh"
brew "git"
brew "just"
brew "lazygit"
brew "shellcheck"
brew "vim"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Security & signing
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew "gnupg"
brew "pinentry-mac"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Languages, runtimes & package managers
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew "cocoapods"
brew "composer"
brew "php"
brew "php-cs-fixer"
brew "pipx"
brew "pnpm"
brew "python@3.13"
brew "ruff"
brew "watchman"
brew "yarn"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Cloud & infrastructure
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew "awscli"
brew "terraform"
brew "tflint"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Databases
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew "mysql", restart_service: :changed
brew "redis", restart_service: :changed

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Media tooling
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew "ffmpeg"
brew "imagemagick"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Compression & web font tools
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew "brotli"
brew "zopfli"
tap "bramstein/webfonttools"
brew "bramstein/webfonttools/sfnt2woff"
brew "bramstein/webfonttools/sfnt2woff-zopfli"
brew "bramstein/webfonttools/woff2"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mac App Store CLI
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew "mas"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Editors & dev tooling (casks)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cask "cursor"
cask "visual-studio-code"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Browsers
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cask "google-chrome"
cask "firefox"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Containers & databases (UI)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cask "docker-desktop"
cask "tableplus"
cask "mongodb-compass"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# API / network tools
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cask "postman"
cask "insomnia"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# AI assistants
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cask "claude"
cask "chatgpt"
cask "block-goose"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Productivity & menubar
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cask "raycast"
cask "rectangle"
cask "jordanbaird-ice"
cask "meetingbar"
cask "granola"
cask "linear-linear"
cask "kap"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Utilities
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cask "the-unarchiver"
cask "1password"
cask "flux"
cask "protonvpn"
cask "proton-mail-bridge"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Communication
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cask "slack"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Media
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cask "spotify"
cask "sonos"
cask "vlc"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Fonts
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cask "font-fira-code"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Mac App Store apps
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mas "Things 3",    id: 904280696
mas "Amphetamine", id: 937984704
mas "LittleIpsum", id: 405772121

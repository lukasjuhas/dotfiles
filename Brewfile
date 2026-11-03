# Base Homebrew list: installed on EVERY machine (personal, work, server).
#
# Each machine applies this file plus its own layer:
#
#   personal → Brewfile + Brewfile.laptop + Brewfile.personal
#   work     → Brewfile + Brewfile.laptop + Brewfile.work
#   server   → Brewfile + Brewfile.server
#
# The mapping lives in `src/os/installs/macos/brewfile.sh`; the machine
# profile is stored in `~/.dotfiles_profile` by `setup.sh`.
#
#   just bundle         install everything missing for this machine
#   just bundle-check   show what's missing for this machine
#
# https://github.com/Homebrew/homebrew-bundle

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Shell & terminal
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew "bash"
brew "bash-completion@2"
brew "tmux"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Modern CLI quality-of-life
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew "bat"
brew "direnv"
brew "eza"
brew "fd"
brew "fzf"
brew "git-delta"
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
brew "vim"

# Python + Python versions (`uv python install <version>`), and Python
# CLI tools (`uv tool install`). See `src/os/installs/python.sh`.
brew "uv"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Apps
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cask "raycast"
cask "tailscale-app"   # sign in once after setup: open -a Tailscale

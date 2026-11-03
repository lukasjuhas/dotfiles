#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Personal laptop only: mount the home server's d2 drive at login.
#
# Finder's sidebar can't be edited from a script on macOS 26, so drag
# /Volumes/d2 into the sidebar once; Finder then reconnects on click.

declare -r D2_BIN="$(cd ../../.. && pwd)/bin/d2"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Personal\n\n"

execute \
    "install_login_agent local.dotfiles.d2 '$D2_BIN' --mount-only" \
    "Mount d2 at login (local.dotfiles.d2)"

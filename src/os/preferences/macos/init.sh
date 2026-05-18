#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# On modern macOS (Catalina+) most `defaults write` commands silently
# no-op unless the terminal has "Full Disk Access". This block detects
# that and walks the user through granting it.
#
# https://lapcatsoftware.com/articles/containers.html

if ! ls "$HOME/Library/Containers/com.apple.Safari/Data" &> /dev/null; then
    printf "\n"

    open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"

    ask "Please grant the terminal \"Full Disk Access\" and then press any key to continue. "
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Close any open "System Settings" panes so they don't override the
# preferences we are about to change.

./close_system_preferences_panes.applescript

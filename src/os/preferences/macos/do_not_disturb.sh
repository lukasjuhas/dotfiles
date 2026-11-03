#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Every machine: Do Not Disturb on, and back on at every login.
#
# macOS has no supported setting or file to script this, so it goes
# through a Shortcuts shortcut ("Turn Do Not Disturb on until turned
# off"). The repo holds only the unsigned recipe; each Mac signs and
# imports its own copy, which needs one click on "Add Shortcut".
#
# Keep "Share across devices" off (System Settings → Focus) so this
# doesn't spread to other devices on the same Apple ID.

declare -r SHORTCUT_NAME="Do Not Disturb On"
declare -r SHORTCUT_RECIPE="$(cd ../../.. && pwd)/shortcuts/$SHORTCUT_NAME.plist"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

has_shortcut() {
    shortcuts list 2> /dev/null | grep -qxF "$SHORTCUT_NAME"
}

import_shortcut() {

    local tmpDir=""
    local tries=150

    tmpDir="$(mktemp -d)"

    if ! plutil -convert binary1 -o "$tmpDir/recipe.wflow" "$SHORTCUT_RECIPE" \
        || ! shortcuts sign --mode anyone \
            --input "$tmpDir/recipe.wflow" \
            --output "$tmpDir/$SHORTCUT_NAME.shortcut" &> /dev/null; then
        print_error "Do Not Disturb (could not sign the shortcut)"
        rm -rf "$tmpDir"
        return 1
    fi

    open "$tmpDir/$SHORTCUT_NAME.shortcut"
    print_in_yellow "   Click \"Add Shortcut\" in the Shortcuts window…\n"

    # Wait up to 5 minutes for the click.
    while ! has_shortcut && [ "$tries" -gt 0 ]; do
        sleep 2
        tries=$((tries - 1))
    done

    rm -rf "$tmpDir"

    has_shortcut
    print_result $? "Do Not Disturb (import shortcut)"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n   Do Not Disturb\n\n"

    has_shortcut \
        || import_shortcut \
        || return 1

    execute \
        "shortcuts run '$SHORTCUT_NAME'" \
        "Do Not Disturb on"

    execute \
        "install_login_agent local.dotfiles.do-not-disturb /usr/bin/shortcuts run '$SHORTCUT_NAME'" \
        "Do Not Disturb on at every login (local.dotfiles.do-not-disturb)"

}

main

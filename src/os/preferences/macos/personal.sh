#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Personal laptop only: mount the home server's d2 drive at login.
#
# Finder's sidebar can't be edited from a script on macOS 26, so drag
# /Volumes/d2 into the sidebar once; Finder then reconnects on click.

declare -r LABEL="local.dotfiles.d2"
declare -r PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
declare -r D2_BIN="$(cd ../../.. && pwd)/bin/d2"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

write_plist() {

    # launchd doesn't expand `~`, so absolute paths are written in.

    mkdir -p "$(dirname "$PLIST")"

    cat > "$PLIST" << PLIST_EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LABEL</string>
    <key>ProgramArguments</key>
    <array>
        <string>$D2_BIN</string>
        <string>--mount-only</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/$LABEL.log</string>
</dict>
</plist>
PLIST_EOF

}

main() {

    print_in_purple "\n   Personal\n\n"

    execute \
        "write_plist && plutil -lint -s '$PLIST'" \
        "Mount d2 at login ($PLIST)"

    launchctl bootout "gui/$(id -u)/$LABEL" &> /dev/null
    execute \
        "launchctl bootstrap gui/$(id -u) '$PLIST'" \
        "Load $LABEL"

}

main

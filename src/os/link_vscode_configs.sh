#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# Symlink `src/vscode/{settings.json,keybindings.json,snippets}` into
# both VS Code's and Cursor's User directories so the two editors stay
# in sync.
#
# Unknown configuration keys (e.g. `cursor.*` in VS Code, `claudeCode.*`
# in Cursor) are silently ignored by the editor that doesn't know
# them, so it's safe to share a single `settings.json`.
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -r SHARED_DIR="$(cd .. && pwd)/vscode"

declare -r -a EDITOR_USER_DIRS=(
    "$HOME/Library/Application Support/Code/User"
    "$HOME/Library/Application Support/Cursor/User"
)

declare -r -a FILES_TO_SYMLINK=(
    "settings.json"
    "keybindings.json"
    "snippets"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

backup_if_real_file() {

    local target="$1"

    [ ! -e "$target" ] && return 0
    [ -L "$target" ] && return 0

    local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"

    execute \
        "mv \"$target\" \"$backup\"" \
        "Backup existing $target → $backup"
}

link_editor_config() {

    local userDir="$1"
    local sourceFile="$2"
    local sourcePath="$SHARED_DIR/$sourceFile"
    local targetPath="$userDir/$sourceFile"

    # If the editor isn't installed (no User directory), skip silently.

    [ ! -d "$userDir" ] && return 0

    backup_if_real_file "$targetPath"

    if [ -L "$targetPath" ] && [ "$(readlink "$targetPath")" == "$sourcePath" ]; then
        print_success "$targetPath → $sourcePath"
        return 0
    fi

    execute \
        "rm -rf \"$targetPath\" && ln -fs \"$sourcePath\" \"$targetPath\"" \
        "$targetPath → $sourcePath"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • Symlink shared VS Code / Cursor configs\n\n"

    local userDir=""
    local file=""

    for userDir in "${EDITOR_USER_DIRS[@]}"; do
        for file in "${FILES_TO_SYMLINK[@]}"; do
            link_editor_config "$userDir" "$file"
        done
    done

}

main "$@"

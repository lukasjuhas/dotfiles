#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Apply the declarative package list from the repo root `Brewfile`.
# See: https://github.com/Homebrew/homebrew-bundle

main() {

    print_in_purple "\n   Brewfile (formulae + casks + MAS)\n\n"

    if ! cmd_exists "brew"; then
        print_error "Homebrew is not installed"
        return 1
    fi

    local brewfile=""
    brewfile="$(cd "../../../.." && pwd)/Brewfile"

    if [ ! -f "$brewfile" ]; then
        print_error "Brewfile not found at $brewfile"
        return 1
    fi

    execute \
        "brew bundle --no-lock --file='$brewfile'" \
        "brew bundle ($brewfile)"
}

main

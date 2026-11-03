#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Apply the Brewfile layers for this machine's profile, in order.
# This is the only place that maps a profile to its Brewfiles.
#
#   brewfile.sh           install everything missing
#   brewfile.sh --check   list what's missing (installs nothing)
#
# See: https://github.com/Homebrew/homebrew-bundle

DOTFILES_DIR="$(cd "../../../.." && pwd)"

brewfiles_for_profile() {

    case "$1" in
        personal) printf "%s\n" Brewfile Brewfile.laptop Brewfile.personal ;;
        work)     printf "%s\n" Brewfile Brewfile.laptop ;;
        server)   printf "%s\n" Brewfile Brewfile.server ;;
        *)        return 1 ;;
    esac

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    local brewfile=""
    local check=false
    local profile=""
    local status=0

    [ "$1" == "--check" ] && check=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    profile="$(get_profile)" \
        || return 1

    print_in_purple "\n   Brewfiles ($profile)\n\n"

    if ! cmd_exists "brew"; then
        print_error "Homebrew is not installed"
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    while read -r brewfile; do

        if [ ! -f "$DOTFILES_DIR/$brewfile" ]; then
            print_error "$brewfile not found in $DOTFILES_DIR"
            status=1
            continue
        fi

        if $check; then
            brew bundle check --verbose --file="$DOTFILES_DIR/$brewfile" \
                || status=1
        else
            execute \
                "brew bundle --file='$DOTFILES_DIR/$brewfile'" \
                "brew bundle ($brewfile)" \
                || status=1
        fi

    done < <(brewfiles_for_profile "$profile")

    return $status

}

main "$@"

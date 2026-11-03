#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install filmscan (https://github.com/lukasjuhas/filmscan) as a uv
# tool from its clone, plus the pinned NegPy it uses for `convert`.
#
# filmscan owns the NegPy version (`filmscan.convert.NEGPY_VERSION`);
# this script reads it from the installed tool instead of repeating it.

declare -r FILMSCAN_DIR="$HOME/projects/filmscan"
declare -r NEGPY_DIR="$HOME/.local/share/filmscan/negpy"
declare -r NEGPY_REPO_URL="https://github.com/marcinz606/NegPy"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_filmscan() {

    execute \
        "uv tool install --editable '$FILMSCAN_DIR'" \
        "filmscan (uv tool, editable)"

}

negpy_version() {

    "$(uv tool dir)/filmscan/bin/python" -I -c \
        "from filmscan.convert import NEGPY_VERSION; print(NEGPY_VERSION)"

}

install_negpy() {

    local version=""

    version="$(negpy_version)" || {
        print_error "NegPy (could not read NEGPY_VERSION from filmscan)"
        return 1
    }

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -d "$NEGPY_DIR/.git" ]; then
        execute \
            "git clone --quiet --branch '$version' --depth 1 '$NEGPY_REPO_URL' '$NEGPY_DIR'" \
            "NegPy $version (clone)" \
            || return 1
    elif [ "$(git -C "$NEGPY_DIR" describe --tags --exact-match 2> /dev/null)" != "$version" ]; then
        execute \
            "git -C '$NEGPY_DIR' fetch --quiet --depth 1 origin tag '$version' \
                && git -C '$NEGPY_DIR' checkout --quiet '$version'" \
            "NegPy $version (update)" \
            || return 1
    fi

    execute \
        "uv sync --quiet --project '$NEGPY_DIR' --frozen" \
        "NegPy $version (uv sync)"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • filmscan\n\n"

    if ! cmd_exists "uv"; then
        print_error "uv is not installed (it comes from the Brewfile)"
        return 1
    fi

    if [ ! -d "$FILMSCAN_DIR" ]; then
        print_warning "filmscan (not cloned at $FILMSCAN_DIR — set up gh/SSH auth and re-run)"
        return 0
    fi

    install_filmscan \
        && install_negpy

    print_warning "The NegPy app itself has no Homebrew cask — install it from https://github.com/marcinz606/NegPy/releases (same version as above)."

}

main

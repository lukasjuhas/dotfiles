#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Python versions are managed by uv (the nvm equivalent for Python):
#
#   uv python install 3.12   install another version
#   uv python pin 3.12       write `.python-version` for a project
#   uv python list           show installed / available versions
#
# `--default` also puts `python` / `python3` into `~/.local/bin`.
#
# https://docs.astral.sh/uv/guides/install-python/

main() {

    print_in_purple "\n   Python (uv)\n\n"

    if ! cmd_exists "uv"; then
        print_error "uv is not installed (it comes from the Brewfile)"
        return 1
    fi

    # `uv python install` with no version is satisfied by any Python
    # uv already has, so ask for the newest stable CPython explicitly
    # (the list is newest-first; pre-releases and variants are skipped).

    local latest=""
    latest="$(uv python list --only-downloads \
        | awk '$1 ~ /^cpython-[0-9]+\.[0-9]+\.[0-9]+-/ { split($1, p, "-"); print p[2]; exit }')"

    if [ -z "$latest" ]; then
        print_error "Python (could not find the latest version with uv)"
        return 1
    fi

    execute \
        "uv python install --default '$latest'" \
        "Python $latest (uv, default)"

}

main

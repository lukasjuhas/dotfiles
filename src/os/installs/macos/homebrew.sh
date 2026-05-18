#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_homebrew() {

    if ! cmd_exists "brew"; then
        ask_for_sudo
        printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &> /dev/null
        #  └─ simulate the ENTER keypress
    fi

    print_result $? "Homebrew"

}

add_to_path() {

    declare -r LOCAL_SHELL_CONFIG_FILE="$HOME/.bash.local"
    declare -r BREW_PREFIX="/opt/homebrew"

    # Apple Silicon only — Homebrew always installs to /opt/homebrew.
    # Make sure it's on PATH in the local shell config (idempotent).

    if ! grep -F "$BREW_PREFIX/bin" < "$LOCAL_SHELL_CONFIG_FILE" &> /dev/null; then
        execute \
            "printf '\n# Homebrew\nexport PATH=\"%s/bin:\$PATH\"\n' '$BREW_PREFIX' >> $LOCAL_SHELL_CONFIG_FILE" \
            "Homebrew (add $BREW_PREFIX/bin to PATH in $LOCAL_SHELL_CONFIG_FILE)"
    fi
}

add_homebrew_env_configs() {

    declare -r LOCAL_SHELL_CONFIG_FILE="$HOME/.bash.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Modern Homebrew honors environment variables for both analytics
    # opt-out and disabling auto-update. Write them once into the
    # local shell config so they apply to every interactive shell.
    #
    # https://docs.brew.sh/Manpage#environment
    # https://docs.brew.sh/Analytics#opting-out

    if ! grep "HOMEBREW_NO_ANALYTICS" < "$LOCAL_SHELL_CONFIG_FILE" &> /dev/null; then

        declare -r CONFIGS="
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Homebrew: opt out of analytics and skip auto-update before
# every brew command (run \`brew update\` manually instead).
#
# https://docs.brew.sh/Manpage#environment

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1
"
        execute \
            "printf '%s' '$CONFIGS' >> $LOCAL_SHELL_CONFIG_FILE" \
            "Homebrew (set HOMEBREW_NO_ANALYTICS / HOMEBREW_NO_AUTO_UPDATE in $LOCAL_SHELL_CONFIG_FILE)"
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n   Homebrew\n\n"

    install_homebrew
    add_to_path

    brew_update
    brew_upgrade

    add_homebrew_env_configs
}

main

#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# PHP, Composer, MySQL and Redis are installed declaratively via the
# top-level `Brewfile`. This script only handles the Composer-PATH
# wiring and Laravel Valet setup.

declare -r LOCAL_SHELL_CONFIG_FILE="$HOME/.bash.local"
declare -r COMPOSER_DIRECTORY="$HOME/.composer/vendor/bin"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_composer_to_path() {

    if grep -F "$COMPOSER_DIRECTORY" < "$LOCAL_SHELL_CONFIG_FILE" &> /dev/null; then
        return
    fi

    declare -r CONFIGS="
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# PHP Composer

export PATH=\"$COMPOSER_DIRECTORY:\$PATH\"
"

    execute \
        "printf '%s' '$CONFIGS' >> $LOCAL_SHELL_CONFIG_FILE" \
        "Composer (add $COMPOSER_DIRECTORY to PATH in $LOCAL_SHELL_CONFIG_FILE)"
}

install_laravel_valet() {

    if [ ! -d "$COMPOSER_DIRECTORY" ] || ! command -v composer &> /dev/null; then
        print_warning "Composer is not installed yet — skipping Valet setup."
        return
    fi

    if command -v valet &> /dev/null; then
        print_success "Laravel Valet (already installed)"
        return
    fi

    execute \
        "composer global require laravel/valet && \
         valet install && \
         valet trust" \
        "Laravel Valet"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n   PHP / Composer / Laravel Valet\n\n"

    add_composer_to_path
    install_laravel_valet
}

main

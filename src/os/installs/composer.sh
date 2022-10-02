#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

declare -r LOCAL_SHELL_CONFIG_FILE="$HOME/.bash.local"
declare -r COMPOSER_DIRECTORY="~/.composer/vendor/bin"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_composer_configs() {

    declare -r CONFIGS="
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# PHP Composer

PATH=\"$COMPOSER_DIRECTORY:\$PATH\"

export PATH

"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    execute \
        "printf '%s' '$CONFIGS' >> $LOCAL_SHELL_CONFIG_FILE \
            && . $LOCAL_SHELL_CONFIG_FILE"

}

install_php() {

    # Install `php` via brew

    execute \
        "brew install php"

}

install_composer() {

    # Install `composer` via brew and add the necessary
    # configs in the local shell config file.

    execute \
        "brew install composer" \
    && add_composer_configs

}

update_composer() {

    execute \
        "brew upgrade composer"

}

install_laravel_valet() {
    # Install laravel valet via composer

    execute \
        "composer global require laravel/valet" \
        "valet install"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n   PHP, Composer & Laravel Valet\n\n"

    install_php

    if [ ! -d ~/.composer/vendor/bin ]; then
        install_composer
    else
        update_composer
    fi

    source $LOCAL_SHELL_CONFIG_FILE

    install_laravel_valet

}

main

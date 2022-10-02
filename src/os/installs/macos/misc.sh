#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Miscellaneous (dev)\n\n"

brew_install "MAS" "mas"

brew_install "PHP" "php"
brew_install "PHP CS" "php-cs-fixer"
brew_install "Composer" "composer"
brew install "Docker" "docker" "--cask"
brew install "Docker Compose" "docker-compose"
brew_install "Python" "python"
brew_install "Table Plus" "tableplus" "--cask"
brew_install "Transmit" "transmit" "--cask"
brew_install "Insomnia" "insomnia" "--cask"
brew_install "Heroku" "heroku/brew/heroku"

print_in_purple "\n   Laravel Valet\n\n"

composer global require laravel/valet
valet install

print_in_purple "\n   Miscellaneous\n\n"

brew_install "Raycast" "raycast" "--cask"
brew_install "Rectangle" "rectangle" "--cask"
brew_install "Unarchiver" "the-unarchiver" "--cask"
brew_install "1password" "1password" "--cask"
brew_install "Flux" "flux" "--cask"
brew_install "Slack" "slack" "--cask"
brew_install "Kap" "kap" "--cask"
brew_install "Proton VPN" "protonvpn" "--cask"
brew_install "Proton Mail Bridge" "protonmail-bridge" "--cask"
brew install "Transmission" "transmission" "--cask"
brew install "Adobe CC" "adobe-creative-cloud" "--cask"

brew_install "Spotify" "spotify" "--cask"
brew_install "Sonos" "sonos" "--cask"
brew_install "VLC" "vlc" "--cask"

brew_install "Fira Code Font" "font-fira-code" "--cask" "homebrew/cask-fonts"

mas install 904280696 # Things 3
mas install 937984704 # Amphetamine
mas install 405772121 # Littleipsum
#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n • Installs\n\n"

"./$(get_os)/main.sh"

# Clone personal repos (OS-agnostic; runs after brew + git are installed).
./repos.sh

# filmscan photo workflow: personal laptop + server only.
case "$(get_profile)" in
    personal|server) ./filmscan.sh ;;
esac

# Immich photo library (shows the film scan archive): server only.
if [ "$(get_profile)" = "server" ]; then
    ./immich.sh
fi

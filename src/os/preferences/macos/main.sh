#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

./init.sh

./app_store.sh
./chrome.sh
./dock.sh
./finder.sh
./firefox.sh
./keyboard.sh
./language_and_region.sh
./maps.sh
./photos.sh
./safari.sh
./security_and_privacy.sh
./textedit.sh
./trackpad.sh
./ui_and_ux.sh

# Machine-specific preferences.

case "$(get_profile)" in
    personal) ./personal.sh ;;
    server)   ./server.sh ;;
esac

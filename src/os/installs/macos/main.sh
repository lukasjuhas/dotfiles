#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Order matters:
#   1. Xcode CLT (prerequisite for almost everything; full Xcode on laptops)
#   2. Homebrew itself
#   3. Bash 5 (changes the user's login shell)
#   4. Brewfile layers for this machine's profile
#   5. Laptops: nvm + Node, global npm updates, Python via uv
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

./xcode.sh
./homebrew.sh
./bash.sh
./brewfile.sh

if is_laptop_profile "$(get_profile)"; then
    ./../nvm.sh
    ./../npm.sh
    ./../python.sh
fi

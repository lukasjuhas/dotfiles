#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Order matters:
#   1. Xcode CLT (prerequisite for almost everything)
#   2. Homebrew itself
#   3. Bash 5 (changes the user's login shell)
#   4. Brewfile (formulae + casks + MAS apps)
#   5. nvm + Node (separate because nvm is not on Homebrew)
#   6. Global npm updates
#   7. Composer / Laravel Valet wiring
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

./xcode.sh
./homebrew.sh
./bash.sh
./brewfile.sh

./../nvm.sh
./../npm.sh
./../composer.sh

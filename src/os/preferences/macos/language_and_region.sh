#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Every machine: British English, UK formats, 24-hour clock, metric.
# Most apps pick these up after logging out and back in.

print_in_purple "\n   Language & Region\n\n"

execute "defaults write -g AppleLanguages -array 'en-GB'" \
    "Language: British English"

# `en_GB` with no `@rg=…` region override (an override such as
# `en_GB@rg=uszzzz` switches to US formats, including the 12-hour clock).

execute "defaults write -g AppleLocale -string 'en_GB'" \
    "Region formats: United Kingdom (dd/mm/yyyy, Monday first)"

execute "defaults write -g AppleICUForce24HourTime -bool true" \
    "24-hour clock"

execute "defaults write -g AppleMeasurementUnits -string 'Centimeters' \
            && defaults write -g AppleMetricUnits -bool true" \
    "Measurement units: metric"

execute "defaults write -g AppleTemperatureUnit -string 'Celsius'" \
    "Temperature: Celsius"

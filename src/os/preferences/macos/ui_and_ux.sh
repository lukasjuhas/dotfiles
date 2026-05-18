#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   UI & UX\n\n"

execute "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true && \
         defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true" \
   "Avoid creating '.DS_Store' files on network or USB volumes"

execute "defaults write com.apple.menuextra.battery ShowPercent -string 'NO'" \
    "Hide battery percentage from the menu bar"

execute "sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true" \
    "Show language menu in the top right corner of the boot screen"

execute "defaults write com.apple.CrashReporter UseUNC 1" \
    "Make crash reports appear as notifications"

execute "defaults write com.apple.LaunchServices LSQuarantine -bool false" \
    "Disable 'Are you sure you want to open this application?' dialog"

execute "defaults write com.apple.print.PrintingPrefs 'Quit When Finished' -bool true" \
    "Automatically quit the printer app once the print jobs are completed"

execute "defaults write com.apple.screencapture disable-shadow -bool true" \
    "Disable shadow in screenshots"

execute "defaults write com.apple.screencapture location -string '$HOME/Desktop'" \
    "Save screenshots to the Desktop"

execute "defaults write com.apple.screencapture show-thumbnail -bool false" \
    "Do not show thumbnail"

execute "defaults write com.apple.screencapture type -string 'png'" \
    "Save screenshots as PNGs"

execute "defaults write com.apple.screensaver askForPassword -int 1 && \
         defaults write com.apple.screensaver askForPasswordDelay -int 0" \
    "Require password immediately after entering sleep or screen saver mode"

execute "defaults write -g AppleFontSmoothing -int 2" \
    "Enable subpixel font rendering on non-Apple LCDs"

execute "defaults write -g AppleShowScrollBars -string 'Always'" \
    "Always show scrollbars"

execute "defaults write -g NSAutomaticWindowAnimationsEnabled -bool false" \
    "Disable window opening and closing animations."

execute "defaults write -g NSDisableAutomaticTermination -bool true" \
    "Disable automatic termination of inactive apps"

execute "defaults write -g NSNavPanelExpandedStateForSaveMode -bool true" \
    "Expand save panel by default"

execute "defaults write -g NSTableViewDefaultSizeMode -int 2" \
    "Set sidebar icon size to medium"

execute "defaults write -g NSUseAnimatedFocusRing -bool false" \
    "Disable the over-the-top focus ring animation"

execute "defaults write -g NSWindowResizeTime -float 0.001" \
    "Accelerate window resize playback"

execute "defaults write -g PMPrintingExpandedStateForPrint -bool true" \
    "Expand print panel by default"

execute "defaults write -g QLPanelAnimationDuration -float 0" \
    "Disable Quick Look window opening animations"

execute "defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false" \
    "Disable resume system-wide"

execute "sudo systemsetup -setrestartfreeze on &> /dev/null" \
    "Restart automatically if the computer freezes"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# macOS Sequoia / Tahoe (15+/26+) additions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

execute "defaults write com.apple.WindowManager GloballyEnabled -bool false" \
    "Disable Stage Manager"

execute "defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false" \
    "Disable click-wallpaper-to-reveal-desktop"

execute "defaults write com.apple.WindowManager StandardHideWidgets -bool true && \
         defaults write com.apple.WindowManager StageManagerHideWidgets -bool true" \
    "Hide desktop widgets"

execute "defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0" \
    "Set trackpad click to 'light'"

killall "SystemUIServer" &> /dev/null

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Opt-in only (commented out) — uncomment if you want these behaviors
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# # Force computer name (annoying if you have multiple machines).
# execute "sudo scutil --set ComputerName 'laptop' && \
#          sudo scutil --set HostName 'laptop' && \
#          sudo scutil --set LocalHostName 'laptop'" \
#     "Set computer name"
#
# # Force Bluetooth off at every setup run (you almost never want this).
# execute "sudo defaults write /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState 0 && \
#          sudo launchctl unload /System/Library/LaunchDaemons/com.apple.blued.plist && \
#          sudo launchctl load /System/Library/LaunchDaemons/com.apple.blued.plist" \
#     "Turn Bluetooth off"


#!/bin/bash


# to maintain cask ....
#     brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup`

brew install homebrew/cask
brew tap homebrew/cask-versions

# daily
brew cask install spectacle
brew cask install alfred
brew cask install dropbox
brew cask install 1password
brew cask install flux
brew cask install slack
brew cask install kap
brew cask install protonvpn
brew cask install protonmail-bridge

# dev
brew cask install iterm2
brew cask install visual-studio-code
brew cask install imagealpha
brew cask install imageoptim
brew cask install postman
brew cask install sequel-pro
brew cask install transmit

# docker
brew cask install docker
brew install docker-compose

# browsers
brew cask install firefox
brew cask install firefox-nightly
brew cask install google-chrome
brew cask install google-chrome-canary

# fonts
brew tap homebrew/cask-fonts
brew cask install font-fira-code

# less often
brew cask install vlc
brew cask install spotify
brew cask install sonos
brew cask install ticktick
brew cask install transmission
brew cask install adobe-creative-cloud
brew cask install homebrew/cask-drivers/logitech-options

### Other not found
# Unsplash
# Microsfot Office - lol
# Littleipsum
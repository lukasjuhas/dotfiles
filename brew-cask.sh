#!/bin/bash


# to maintain cask ....
#     brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup`


# Install native apps

brew install caskroom/cask/brew-cask
# brew tap caskroom/versions

# daily
brew cask install spectacle
brew cask install alfred
brew cask install dropbox
brew cask install 1password
brew cask install flux
brew cask install skype
brew cask install unrarx
brew cask install slack
brew cask install kap
brew cask install arq
brew cask install protonvpn
brew cask install protonmail-bridge
brew cask install authy

# dev
brew cask install iterm2
brew cask install visual-studio-code
brew cask install sublime-text
brew cask install imagealpha
brew cask install imageoptim
brew cask install postman
brew cask install sequel-pro
brew cask install transmit
brew cask install docker
brew cask install docker-compose
brew cask install sketch

# browsers
brew cask install firefox
brew cask install firefoxnightly
brew cask install google-chrome

# less often
brew cask install vlc
brew cask install caffeine
brew cask install spotify
brew tap caskroom/fonts
brew cask install font-fira-code
brew cask install hazel
brew cask install handbrake
brew cask install transmission
brew cask install appcleaner
brew cask install adobe-creative-cloud
brew cask install homebrew/cask-drivers/logitech-options
brew cask install android-sdk

### Other not found
# Unsplash
# Microsfot Office
# Bear
# Littleipsum
# Affinity Designer
# Lightroom
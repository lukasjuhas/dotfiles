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
brew cask install rescuetime
brew cask install flux
brew cask install skype
brew cask install unrarx
brew cask install slack
brew cask install little-snitch
brew cask install cloudapp
brew cask install tunnelblick
brew cask install arq
brew cask install cheatsheet

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
brew cask install virtualbox

# browsers
brew cask install google-chrome
brew cask install firefox
brew cask install firefoxnightly
brew cask install torbrowser

# less often
brew cask install vlc
brew cask install gpgtools
brew cask install utorrent
brew cask install handbrake
brew cask install caffeine
brew cask install duet
brew cask install tunnelbear

brew cask install spotify

brew tap caskroom/fonts
brew cask install font-fira-code

### Other not found
# HeliumLift4
# Microsfot Office
# Dr Cleaner?
# Bear
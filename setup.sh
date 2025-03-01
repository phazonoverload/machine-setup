#!/bin/bash

# Fail immediately if any commands fail.
set -e

# Install xcode devtools
if xcode-select --install 2>&1 | grep installed; then
  echo "xcode already installed";
else
  echo "Installing xcode"
  xcode-select --install
fi

# Install and update Homebrew
if test ! $(which brew); then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$USER/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
brew update

# Install and configure git
echo "Install and configure git"
brew install git
echo -n 'Git username: '
read username
git config --global user.name "$username"
echo -n 'Git email: '
read mail
git config --global user.email $mail
git config --global alias.ac "!git add -A && git commit -m "
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub
open -a Safari https://github.com/settings/keys
read -p "Add public key to GitHub and hit [Enter]."

# Install software with homebrew
echo "Installing software via brew"
brew install homebrew/cask
taps=(
  gh
  wget
  mas
)
brew install ${taps[@]}
casks=(
  1password
  arc
  caffeine
  camo-studio
  cleanshot
  cyberduck
  cyberghost-vpn
  discord
  elgato-camera-hub
  elgato-control-center
  elgato-wave-link
  firefox
  font-geist-mono
  google-chrome
  raycast
  screenflow
  signal
  slack
  todoist
  vanilla
  visual-studio-code
  visual-studio-code@insiders
  whatsapp
  zoom
)
brew install --cask ${casks[@]}
brew cleanup

# Install apps via Mac App Store
mas install 1569813296 # 1Password for Safari
mas install 682658836 # GarageBand
mas install 409201541 # Pages
mas install 409203825 # Numbers
mas install 361285480 # Keynote
mas install 6475002485 # Reeder

# Installing Node
echo "Installing Node via Volta"
brew install volta
volta install node@latest
volta setup

# Configure Oh My Zsh
echo "Install & Configure Oh My Zsh"
curl -L http://install.ohmyz.sh | sh
wget -O ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/common.zsh-theme https://raw.githubusercontent.com/jackharrisonsherlock/common/master/common.zsh-theme
open ~/.zshrc
read -p "Set ZSH_THEME=\"common\" and then [enter]"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
open ~/.zshrc
read -p "Please add zsh-autosuggestions & zsh-syntax-highlighting to your Plugins! e. g. plugins=(... zsh-autosuggestions zsh-syntax-highlighting) (WITHOUT comma) ✍️ and then press Enter!"
chsh -s /usr/local/bin/zshd

# Configure Mac Settings
echo "Configure Mac Settings"
# Dock
defaults write com.apple.dock "orientation" -string "right"
defaults write com.apple.dock "tilesize" -int "24"
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "show-recents" -bool "false"
defaults write com.apple.dock "mineffect" -string "scale"
defaults write com.apple.dock "autohide-delay" -float "2"
killall Dock
# Screenshots
defaults write com.apple.screencapture "type" -string "png"
mkdir -p "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture "location" -string "$HOME/Pictures/screenshots" && killall SystemUIServer
defaults write com.apple.screencapture "disable-shadow" -bool "true"
# Safari
defaults write com.apple.Safari "ShowFullURLInSmartSearchField" -bool "true" && killall Safari
# Finder
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
defaults write com.apple.finder "ShowPathbar" -bool "true"
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
killall Finder
# Menu Bar
defaults write com.apple.menuextra.clock "DateFormat" -string "\"HH:mm\""
# Mission Control
defaults write com.apple.dock "mru-spaces" -bool "false" && killall Dock
# Window Manager
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false && killall WindowManager
# Power
defaults write com.apple.screensaver idleTime 0

# Log rest of steps
echo "Add VS Code to Path from UI"
echo "Handle Raycast & VS Code Configs"

#!/usr/bin/env zsh
set -x

export HOME=/home/sven
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

mkdir -p $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_CACHE_HOME 
chown -R sven:users $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_CACHE_HOME 

# Install Yet Another Yaourt
#cd /opt
#sudo git clone https://aur.archlinux.org/yay-git.git
#sudo chown -R sven:users /opt/yay-git
#sudo -i -u sven sh -c "cd /opt/yay-git && makepkg -si --noconfirm"
#sudo -i -u sven yay -Syu --devel --timeupdate --noconfirm

# Install Fonts
pacman -S --noconfirm ttf-dejavu ttf-roboto ttf-roboto-mono
if [[ ! -d $XDG_CACHE_HOME/nerd-fonts-hack ]]
then
  cd $XDG_CACHE_HOME && git clone https://aur.archlinux.org/nerd-fonts-hack.git
  chown -R sven:users $XDG_CACHE_HOME/nerd-fonts-hack
  cd nerd-fonts-hack && sudo -u sven makepkg -si --noconfirm
fi
if [[ ! -d $XDG_CACHE_HOME/siji-git ]]
then
  cd $XDG_CACHE_HOME && git clone https://aur.archlinux.org/siji-git.git
  chown -R sven:users $XDG_CACHE_HOME/siji-git
  cd siji-git && sudo -u sven makepkg -si --noconfirm
fi

# Install polybar
if [[ ! -d $XDG_CACHE_HOME/polybar-git ]]
then
  cd $XDG_CACHE_HOME && git clone https://aur.archlinux.org/polybar-git.git
  chown -R sven:users $XDG_CACHE_HOME/polybar-git
  cd polybar-git && sudo -u sven makepkg -si --noconfirm
fi
if [[ ! -d $XDG_CACHE_HOME/picom-git ]]
then
  cd $XDG_CACHE_HOME && git clone https://aur.archlinux.org/picom-git.git
  chown -R sven:users $XDG_CACHE_HOME/picom-git
  cd picom-git && sudo -u sven makepkg -si --noconfirm
fi

# Install neovim nightly
if [[ ! -d $XDG_CACHE_HOME/neovim-nightly-bin ]]
then
  cd $XDG_CACHE_HOME && git clone https://aur.archlinux.org/neovim-nightly-bin.git
  chown -R sven:users $XDG_CACHE_HOME/neovim-nightly-bin
  cd neovim-nightly-bin && sudo -u sven makepkg -si --noconfirm
fi

# Install google chrome
if [[ ! -d $XDG_CACHE_HOME/google-chrome ]]
then
  cd $XDG_CACHE_HOME && git clone https://aur.archlinux.org/google-chrome.git
  chown -R sven:users $XDG_CACHE_HOME/google-chrome
  cd google-chrome && sudo -u sven makepkg -si --noconfirm
fi

# Install spotify
if [[ ! -d $XDG_CACHE_HOME/spotify ]]
then
  curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -
  cd $XDG_CACHE_HOME && git clone https://aur.archlinux.org/spotify.git
  chown -R sven:users $XDG_CACHE_HOME/spotify
  cd spotify && sudo -u sven makepkg -si --noconfirm
fi

# Install NVM
if [[ ! -d $XDG_CACHE_HOME/nvm ]]
then
  cd $XDG_CACHE_HOME && git clone https://aur.archlinux.org/nvm.git
  chown -R sven:users $XDG_CACHE_HOME/nvm
  cd nvm && sudo -u sven makepkg -si --noconfirm
fi

# Sddm themes 
if [[ ! -d $XDG_CACHE_HOME/archlinux-themes-sddm ]]
then
  cd $XDG_CACHE_HOME && git clone https://aur.archlinux.org/archlinux-themes-sddm.git
  chown -R sven:users $XDG_CACHE_HOME/archlinux-themes-sddm
  cd archlinux-themes-sddm && sudo -u sven makepkg -si --noconfirm
  sudo sed -i 's/Current=/Current=archlinux-simplyblack/g' /usr/lib/sddm/sddm.conf.d/default.conf
fi

# Install Neovide
if [[ ! -d $XDG_CACHE_HOME/neovide ]]
then
  cd $XDG_CACHE_HOME && git clone https://aur.archlinux.org/neovide.git
  chown -R sven:users $XDG_CACHE_HOME/neovide
  cd neovide && sudo -u sven makepkg -si --noconfirm
fi

# Set i3 and xmonad config
#
curl -o $HOME/.xmonad/xmonad.hs --create-dirs "https://raw.githubusercontent.com/exsinod/dotfiles/exarch/.xmonad/xmonad.hs"
curl -o $HOME/.stalonetrayrc "https://raw.githubusercontent.com/exsinod/dotfiles/exarch/.stalonetrayrc"

# Post Install
curl -o $HOME/post-install.sh "https://raw.githubusercontent.com/exsinod/exarch/main/post-install.sh"
chmod +x $HOME/post-install.sh
chown -R sven:users $HOME

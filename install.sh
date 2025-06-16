#!/bin/bash

#debug 
# set -x 

# fail on error
set -e

#Include 
source "progs.sh"

install="pacman -S --noconfirm -q"

# ####################### #
# Important Starting Deps # 
# ####################### #

# ##### #
# Setup # 
# ##### #

sudo pacman -Syu --noconfirm -q

# install yay | requires manual password input 
sudo pacman -S --needed git base-devel 
cd && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# My Preferred Folders
mkdir -p $HOME/Applications $HOME/Projects $HOME/Documents $HOME/Videos \
         $HOME/Downloads 

# ################ #
# Package Download #
# ################ #

for package in ${programs[@]}; do 
  sudo $install $package
  if [ $? -ne 0 ]; then 
    echo "Package $package Failed"
    exit 1
  fi 
done 

# Install Local Send
yay -S --noconfirm localsend 

# Install tofi
yay -S --noconfirm tofi

# Install obs browser support
yay -S --noconfirm obs-studio-browser

# kew (music player)
yay -S kew

# nerdfonts
curl https://api.github.com/repos/ryanoasis/nerd-fonts/tags | grep "tarball_url" | grep -Eo 'https://[^\"]*' | sed  -n '1p' | xargs wget -O - | tar -xz && \
mkdir -p $HOME/.local/share/fonts && \
find ./ryanoasis-nerd-fonts-* -name '*.ttf' -exec mv {} $HOME/.local/share/fonts \; 
rm -rf ./ryanoasis-nerd-fonts-*

# PxPlus font
git clone https://github.com/Love-Pengy/PxPlus_IBM_VGA8_Nerd.git
mv ./PxPlus_IBM_VGA8_Nerd/PxPlusIBMVGA8NerdFont-Regular.ttf $HOME/.local/share/fonts 
rm -rf PxPlus_IBM_VGA8_Nerd

# obsidian
flatpak install -y md.obsidian.Obsidian/x86_64/stable

# qmk
sudo $install qmk
setup -y -H $HOME/Projects/qmk_firmware

# ############# #
# Configuration # 
# ############# #

# Move dotfiles to their respective places, adopts existing files then overrides them to what they should be 
stow . --adopt
git restore .

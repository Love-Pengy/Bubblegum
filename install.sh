#!/bin/bash

#debug 
# set -x 

# fail on error
set -e

#Include 
source "progs.sh"
source "servers.sh"

UHOME=$(getent passwd $SUDO_USER | cut -d: -f6)
echo $UHOME
nonRootBash="sudo -u $SUDO_USER bash -c"
nonRoot="sudo -u $SUDO_USER"
install="pacman -S --noconfirm -q"

# ####################### #
# Important Starting Deps # 
# ####################### #

# Sudo check
if [[ $EUID > 0 ]]
  then echo "Please run as root"
  exit
fi

# ##### #
# Setup # 
# ##### #

pacman -Syu --noconfirm -q

# install yay | requires manual password input 
pacman -S --needed git base-devel 
$nonRootBash 'cd && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si'

# My Preferred Folders
$nonRoot mkdir -p $UHOME/Applications $UHOME/Projects $UHOME/Documents $UHOME/Videos \
         $UHOME/Downloads 

# Ensure no conflicts between rust and rustup
pacman --remove --noconfirm rust

# ################ #
# Package Download #
# ################ #

for package in ${programs[@]}; do 
  $install $package
  if [ $? -ne 0 ]; then 
    echo "Package $package Failed"
    exit 1
  fi 
done 

# Install Local Send
$nonRoot yay -S --noconfirm localsend 

# Install OBS
$install obs-studio

## Install Rust 
$install rustup

# Install cargo 
$install cargo 

# nerdfonts
$nonRootBash "\
curl https://api.github.com/repos/ryanoasis/nerd-fonts/tags | grep "tarball_url" | grep -Eo 'https://[^\"]*' | sed  -n '1p' | xargs wget -O - | tar -xz && \
mkdir -p $UHOME/.local/share/fonts && \
find ./ryanoasis-nerd-fonts-* -name '*.ttf' -exec mv {} `$UHOME/.local/share/fonts` \;" 
rm -rf ./ryanoasis-nerd-fonts-*

# PxPlus font
$nonRootBash "git clone https://github.com/Love-Pengy/PxPlus_IBM_VGA8_Nerd.git"
$nonRoot mv ./PxPlus_IBM_VGA8_Nerd/PxPlusIBMVGA8NerdFont-Regular.ttf $UHOME/.local/share/fonts 
rm -rf PxPlus_IBM_VGA8_Nerd"

# obsidian
flatpak install -y md.obsidian.Obsidian/x86_64/stable

# vesktop
$nonRoot yay -S --noconfirm vesktop

# qmk
$install qmk
$nonRoot qmk setup -y -H $UHOME/Projects/qmk_firmware

# ############# #
# Configuration # 
# ############# #

# Move dotfiles to their respective places, adopts existing files then overrides them to what they should be 
# NOTE: ignore this for now as I know it works and don't wanna reset until script is done
# $nonRoot stow .
# $nonRoot git restore .

# Make random_bg script executable
chmod +x $UHOME/.config/sway/random_bg

# install neovim servers
for server in ${servers[@]}; do 
  $nonRoot nvim --headless  +'MasonInstall $package' +qa
done 


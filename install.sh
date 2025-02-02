#!/bin/bash

#debug 
set -x 

#Include 
source "progs.sh"
source "servers.sh"

UHOME=$(getent passwd $SUDO_USER | cut -d: -f6)
echo $UHOME
install="pacman -S --noconfirm"

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

pacman -Syu --noconfirm
$install python-pip

# install yay | requires manual password input 
pacman -S --needed git base-devel 
sudo -u $SUDO_USER bash -c 'git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si'
pwd

# My Preferred Folders
mkdir -p $UHOME/Applications $UHOME/Projects $UHOME/Documents $UHOME/Videos \
         $UHOME/Downloads 


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
yay -S --noconfirm localsend 

# Install OBS
$install obs-studio


## Install Rust |  requires user input
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install cargo 
$install cargo 

# Install Wallust 
cargo install wallust

# nerdfonts
curl https://api.github.com/repos/ryanoasis/nerd-fonts/tags | grep "tarball_url" | grep -Eo 'https://[^\"]*' | sed  -n '1p' | xargs wget -O - | tar -xz
mkdir -p $UHOME/.local/share/fonts
find ./ryanoasis-nerd-fonts-* -name '*.ttf' -exec cp {} $UHOME/.local/share/fonts \;
rm -rf ./ryanoasis-nerd-fonts-*

# PxPlus font
git clone https://github.com/Love-Pengy/PxPlus_IBM_VGA8_Nerd.git
mv ./PxPlus_IBM_VGA8_Nerd/PxPlusIBMVGA8NerdFont-Regular.ttf $UHOME/.local/share/fonts 
rm -rf PxPlus_IBM_VGA8_Nerd

# obsidian
flatpak install -y md.obsidian.Obsidian/x86_64/stable

# vesktop
yay -S -noconfirm vesktop

# qmk
$install qmk
qmk setup -y -H $UHOME/Projects/qmk_firmware

exit 1
# ############# #
# Configuration # 
# ############# #

# Move dotfiles to their respective places
stow .

# Allow brightnessctl to work without sudo 
usermod -aG video ${USER} 

# Make random_bg script executable
chmod +x $UHOME/.config/sway/random_bg

# install neovim servers
for server in ${servers[@]}; do 
  nvim --headless  +'MasonInstall $package' +qa
done 


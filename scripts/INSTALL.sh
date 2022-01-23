#!/bin/bash

# ======================
# ====== DOT FILES =====
# ======================
#
# This script installs the configurations
# into the system, and save the old configs
# in a save folder.
#
# Author: Damien MOLINA
# Date : 2022-01-12

source scripts/.env || echo -e "\e[1m\e[31mYou must call this script using the Makefile\e[0m"

BUILD=/tmp/__build

if [ -d $BUILD ] ; then
	rm -rfd $BUILD ;
fi

mkdir $BUILD

# Update the packages.
sudo apt update
sudo apt upgrade

# Install the new packages.
sudo apt install i3status rofi kitty compton git vim feh xss-lock

# Install polybar dependencies.
sudo apt install libjsoncpp-dev build-essential cmake cmake-data pkg-config python3-sphinx python3-packaging libuv1-dev libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev

# Install polybar
git clone --recursive https://github.com/polybar/polybar $BUILD/polybar
cd $BUILD/polybar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install

# Install i3 dependencies.
sudo apt install libxcb-shape0-dev

# Install i3 with i3gaps
git clone https://github.com/resloved/i3.git $BUILD/i3
cd $BUILD/i3
git checkout shape
git pull
autoreconf --force --install
mkdir build
cd build
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install

# Creating the old configs folder.
rm -rfd $CONFIG_SAVE_FOLDER
mkdir $CONFIG_SAVE_FOLDER

conf_install() {
	# Save the current configs.
	if [ -f ~/$1 ] ; then
    cp -r ~/$1 $CONFIG_SAVE_FOLDER/$1
  fi

	# Set my configs.
  if [ -d config/$1 ] ; then
    cp -r config/$1/* ~/$1
  else
    cp config/$1 ~/$1
  fi
}

# Install the configs.
conf_install .bashrc
conf_install .bash_aliases
conf_install .vim
conf_install .vimrc
conf_install .ssh
conf_install .config


# Copy the mdr bin file.
# ln -s ~/.vim/bin/mdr_linux_386 /usr/local/bin/mdr

# Equivalent of PlugInstall
vim +'PlugInstall --sync' +qa

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
# Date : 2022-01-23

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
sudo apt install i3status rofi kitty compton git vim feh xss-lock curl xclip imagemagick-6.q16 light

# Install polybar dependencies.
sudo apt install libjsoncpp-dev build-essential cmake cmake-data pkg-config python3-sphinx python3-packaging libuv1-dev libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev fonts-material-design-icons-iconfont

# Install polybar
git clone --recursive https://github.com/polybar/polybar $BUILD/polybar
cd $BUILD/polybar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install

# Install i3 dependencies.
sudo apt install libxcb-shape0-dev autoconf libxcb-xrm-dev libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool automake

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

# Copy the mdr bin file.
# Copy the mdr bin file.
if [ ! -d ~/.vim ] ; then
  mkdir ~/.vim
fi
if [ ! -d ~/.vim/bin ] ; then
  mkdir ~/.vim/bin
fi

MDR=~/.vim/bin/mdr_linux_386
curl -kL https://github.com/MichaelMure/mdr/releases/download/v0.2.5/mdr_linux_386 --output $MDR
chmod +x $MDR
sudo ln -s $MDR /usr/local/bin/mdr

# Equivalent of PlugInstall
# vim +'PlugInstall --sync' +qa

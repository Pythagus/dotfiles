#!/bin/bash

# ======================
# ====== DOT FILES =====
# ======================
#
# This script copies the current system
# config into the Git repository to
# have a up-to-date configs.
#
# Author: Damien MOLINA
# Date : 2021-11-14

source scripts/.env 2> /dev/null

if [ $? -ne 0 ] ; then
  echo -e "\e[1m\e[31mYou must call this script using the Makefile\e[0m"
  exit
fi

# Preparing the configs folder.
rm -rfd $CONFIG_SAVE_FOLDER

if [[ -d $CONFIG_FOLDER ]] ; then
  mv $CONFIG_FOLDER $CONFIG_SAVE_FOLDER
fi
mkdir $CONFIG_FOLDER

# Bash files.
cp $BASE/.bashrc       $CONFIG_FOLDER
cp $BASE/.bash_aliases $CONFIG_FOLDER

# Vim files.
mkdir $CONFIG_FOLDER/.vim
cp $BASE/.vimrc $CONFIG_FOLDER
cp $BASE/.vim/plugins.vim $CONFIG_FOLDER/.vim/

# Config files.
CONFIGS=$CONFIG_FOLDER/.config
mkdir $CONFIGS

# i3 files.
I3=$CONFIGS/i3
mkdir $I3
cp $BASE_CONFIG/i3/config $I3

# Kitty files.
KITTY=$CONFIGS/kitty
mkdir $KITTY
cp $BASE_CONFIG/kitty/kitty.conf $KITTY
cp $BASE_CONFIG/kitty/theme.conf $KITTY

# Compton files.
COMPTON=$CONFIGS/compton
mkdir $COMPTON
cp $BASE_CONFIG/compton/config $COMPTON

# Polybar files.
POLYBAR=$CONFIGS/polybar
mkdir $POLYBAR
cp $BASE_CONFIG/polybar/color $POLYBAR
cp $BASE_CONFIG/polybar/config $POLYBAR
cp $BASE_CONFIG/polybar/launch.sh $POLYBAR

# Rofi
ROFI=$CONFIGS/rofi
mkdir $ROFI
cp $BASE_CONFIG/rofi/config.rasi $ROFI

# SSH
SSH=$CONFIG_FOLDER/.ssh
mkdir $SSH
cp $BASE/.ssh/config $SSH

# Removing saved configs
rm -rfd $CONFIG_SAVE_FOLDER

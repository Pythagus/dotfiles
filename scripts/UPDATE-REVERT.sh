#!/bin/bash

# ======================
# ====== DOT FILES =====
# ======================
#
# This script reverts the previous UPDATE-GIT
# script if it failed
#
# Author: Damien MOLINA
# Date : 2021-11-14

source scripts/.env 2> /dev/null

if [ $? -ne 0 ] ; then
  echo -e "\e[1m\e[31mYou must call this script using the Makefile\e[0m"
  exit
fi

if [[ -d $CONFIG_SAVE_FOLDER ]] ; then
  rm -rfd $CONFIG_FOLDER
  mv $CONFIG_SAVE_FOLDER $CONFIG_FOLDER
  echo -e "\e[1m\e[93mConfigs reverted!\e[0m"
else
  echo -e "\e[1m\e[31mCannot revert : $CONFIG_SAVE_FOLDER doesn't exist\e[0m"
fi


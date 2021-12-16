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
# Date : 2021-11-14

source scripts/.env || echo -e "\e[1m\e[31mYou must call this script using the Makefile\e[0m" && exit

# Copy the mdr bin file.
# ln -s ~/.vim/bin/mdr_linux_386 /usr/local/bin/mdr

# Equivalent of PlugInstall
# vim +'PlugInstall --sync' +qa


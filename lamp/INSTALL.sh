#!/bin/bash

# ======================
# ====== DOT FILES =====
# ======================
#
# This script installs the LAMP stack
# and set up my default configurations.
#
# Author: Damien MOLINA
# Date : 2022-01-25


LAMP=./lamp

# Copy the config file into the
# save config file only if the save
# doesn't already exist.
save_conf() {
  if [ ! -f $CONF_FILE_SAVE ] ; then
    cp $CONF_FILE $CONF_FILE_SAVE
  fi
}

# Check whether the config is not
# already present into the file.
conf_not_present() {
   if ! grep -q $CHECKPOINT $CONF_FILE ; then
     return 0
   else
     return 1
   fi
}

# Generate the indentation spaces.
# $1 : number of spaces.
generate_indent() {
  if [ $1 -gt 0 ] ; then
    local RANGE=`eval echo {1..$1}`
    echo `printf '\ %.0s' $RANGE`
  else
    echo
  fi
}

# Add config into the file.
# $1 : config to add
# $2 : (optionnal) number of spaces to
#      to indent the config.
add_conf() {
  local _INDENT=""
 
  if [ $# -eq 2 ] ; then
    _INDENT=$(generate_indent $2)
  fi

  sed -i "/$CHECKPOINT/i$_INDENT$1" $CONF_FILE
}

# Add the checkpoint into the
# config file.
# $1 : Specific line in the file where we
#      can add our checkpoint
# $2 : insertion mode.
#      - "a" -> add after  the line
#      - "i" -> add before the line
# $3 : indentation.
add_checkpoint() {
  local _INDENT=$(generate_indent $3)
  sed -i "/$1/$2$_INDENT$CHECKPOINT" $CONF_FILE
}

# Install the LAMP stack.
apt install apache2 mysql-server php libapache2-mod-php php-mysql phpmyadmin php-mbstring php-zip php-gd php-json php-curl

###################
# Configure MySQL #
###################
( 
  sudo mysql < $LAMP/configure.sql || exit 3
)
 
if [ $? = 3 ] ; then
  echo -e "\033[0;31mImpossible to change MySQL password\033[0m"
  echo "Continuing."
fi

########################
# Configure PhpMyAdmin #
########################
BASE_CHECKPOINT="PHPMYADMIN_CHECKPOINT"
CONF_FILE=/etc/phpmyadmin/config.inc.php
CONF_FILE_SAVE=$CONF_FILE.default
CHECKPOINT="//$BASE_CHECKPOINT"
save_conf

if conf_not_present ; then
  INDENT=4

  # Add the checkpoint.
  add_checkpoint "\/\* Advance to next server for rest of config \*\/" "i" $INDENT

  # Add the configs.
  CHECKPOINT="\/\/$BASE_CHECKPOINT"
  add_conf "\$cfg['Servers'][\$i]['auth_type']='config';" $INDENT
  add_conf "\$cfg['Servers'][\$i]['user']='root';" $INDENT
  add_conf "\$cfg['Servers'][\$i]['password']='bdd';" $INDENT
  add_conf "\$cfg['Servers'][\$i]['hide_db']='information_schema|performance_schema|mysql|phpmyadmin|sys';" $INDENT
fi

#####################
# Configure apache2 #
#####################
CONF_FILE=/etc/apache2/apache2.conf
CONF_FILE_SAVE=$CONF_FILE.default
CHECKPOINT="#APACHE2_CHECKPOINT"
save_conf

# Only add the Apache2 configs if
# the config is not already present.
if conf_not_present ; then
  INDENT=8

  # Add the checkpoint.
  add_checkpoint "#<\/Directory>" "a" 0

  # Add the configs.
  add_conf "<Directory\ \/home\/dmolina\/www\/>"
  add_conf "Options\ Indexes\ FollowSymLinks" $INDENT
  add_conf "AllowOverride\ All" $INDENT
  add_conf "Require\ all\ granted" $INDENT
  add_conf "<\/Directory>"
fi

# Restarting apache2.
phpenmod mbstring
systemctl reload apache2
systemctl restart apache2

echo -e "\033[0;32mLAMP installed!\033[0m\n"

#############################
# Installing other binaries #
#############################
source $LAMP/composer.sh


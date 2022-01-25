#!/bin/sh

# ======================
# ====== DOT FILES =====
# ======================
#
# This script installs the PHP library
# manager composer available at
# https://getcomposer.org/
#
# Author: Damien MOLINA
# Date : 2022-01-25

# Raise an error and stop the script.
# $1 : message to print.
# $2 : exit error code.
raise_error() {
  >&2 echo -e "\033[0;31m[Composer] $1\033[0m"
  exit $2
}

COMPOSER_FILE=/usr/local/bin/composer
if [ -f $COMPOSER_FILE ] ; then
  echo -e "\033[0;36m[INFO]Composer binary already globally installed\033[0m"
  exit 0
fi

###############################################
# This part was found on the Composer website #
# and was edited for this repository.         #
###############################################
# see https://getcomposer.org/doc/articles/scripts.md
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
SETUP=composer-setup.php

if [ ! -f $SETUP ] ; then
  raise_error "Cannot download installer" 1
fi

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ] ; then
  rm $SETUP
  raise_error "Invalid install checksum" 2
fi

php $SETUP
rm $SETUP

# Add binary globally.
mv composer.phar $COMPOSER_FILE

echo -e "\033[0;32mComposer installed globally!\033[0m"i


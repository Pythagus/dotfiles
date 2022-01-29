#!/bin/bash

FILE=visualstudio.deb
curl -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" --output $FILE
sudo dpkg -i $FILE
sudo apt-get install -f
rm $FILE


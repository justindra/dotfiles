#!/usr/bin/env bash

# Added the System Fonts
wget -O font.zip https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip
unzip font.zip
cd YosemiteSanFrancisco*
mkdir -p ~/.fonts
mv *.ttf ~/.fonts/
# Cleanup
cd ..
rm font.zip
rm -rf YosemiteSanFrancisco*

# Install Infinality
add-apt-repository ppa:no1wantdthisname/ppa
apt update
apt install fontconfig-infinality


# Link GTK Settings
ln -sfv ~/.dotfiles/i3/.gtkrc-2.0 ~/.gtkrc-2.0
ln -sfv ~/.dotfiles/i3/settings.ini ~/.config/gtk-3.0/settings.ini
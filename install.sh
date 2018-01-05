#!/usr/bin/env bash
# Terminal
# Set colors (https://github.com/Mayccoll/Gogh/blob/master/content/themes.md)
#wget -O xt  http://git.io/v3DBV && chmod +x xt && ./xt && rm xt
ln -sfv ~/.dotfiles/bash/.inputrc ~

# Git
if test ! $(which git); then
    apt install git
    ln -sfv ~/.dotfiles/git/.gitconfig ~
else
    echo "git already installed..."
fi

# NVM (https://github.com/creationix/nvm)
#if [ "$(command -v nvm)" != "nvm" ]; then
#    wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
#else
#    echo "nvm already installed..."
#fi

# Google Chrome
if test ! $(which google-chrome-stable); then
    wget -O chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && dpkg -i chrome.deb && rm chrome.deb
else
    echo "Google Chrome already installed..."
fi

# Slack
if test ! $(which slack); then
    wget -O slack.deb  https://downloads.slack-edge.com/linux_releases/slack-desktop-3.0.0-amd64.deb && dpkg -i slack.deb && rm slack.deb
else
    echo "Slack already installed..."
fi

# VSCode
if test ! $(which code); then
    wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868 && dpkg -i vscode.deb && apt-get install -f && rm vscode.deb
else
    echo "VSCode already installed..."
fi

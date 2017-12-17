#!/usr/bin/env bash
# Terminal
# Set colors (https://github.com/Mayccoll/Gogh/blob/master/content/themes.md)
wget -O xt  http://git.io/v3DBV && chmod +x xt && ./xt && rm xt

# Git
if test ! $(which git); then
    apt install git
    ln -sfv ~/.dotfiles/git/.gitconfig ~
else
    echo "git already installed..."
fi

# NVM (https://github.com/creationix/nvm)
if [ "$(command -v nvm)" = "nvm" ]; then
    wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
else
    echo "nvm already installed..."
fi

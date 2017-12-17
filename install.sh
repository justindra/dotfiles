# Terminal
# Set colors (https://github.com/Mayccoll/Gogh/blob/master/content/themes.md)
wget -O xt  http://git.io/v3DBV && chmod +x xt && ./xt && rm xt

# Git
apt install git
ln -sfv ~/.dotfiles/git/.gitconfig ~

# NVM (https://github.com/creationix/nvm)
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

# Dotfiles

These are my dotfiles-v2, instead of just using bash, I've decided to use ansible to make the configuration a bit nicer to support both MacOS and Ubuntu. Mostly based on [elnappo's](https://github.com/elnappo/dotfiles) dotfiles.

## To run

### macOS

```bash
git clone <repository-url> ~/.dotfiles
cd ~/.dotfiles
./init/setup.sh
```

### Ubuntu

#### Prerequisites

Install required packages:

```bash
sudo apt install zsh i3blocks
```

Install oh-my-zsh:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### Setup

```bash
git clone <repository-url> ~/.dotfiles
cd ~/.dotfiles
./init/setup-ubuntu.sh
```

The Ubuntu setup script will:
- Automatically detect the dotfiles directory location
- Backup any existing dotfiles before linking
- Create symlinks for: vim, VS Code, git, bash/zsh, tmux, i3, opencode, and .xprofile
- Create necessary directories if they don't exist
- Change default shell to zsh (if installed)

## TODO

* Add ansible config for Ubuntu and i3
* Find and add an i3 Alternative for MacOS

## Links

* [https://ss64.com/osx/syntax-defaults.html] List of MacOS Default Settings


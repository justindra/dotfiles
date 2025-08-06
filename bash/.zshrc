# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="avit"

# Which plugins would you like to load?
# See https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins
# plugins=(git git-extra python colored-man)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# History file settings
HISTFILE=~/.zsh_history
setopt NO_HIST_VERIFY
setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

source $HOME/.dotfiles/bash/shellrc

case "$(uname -s)" in
    Linux)
        # Load grc
        [[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh
        [[ -s "/usr/share/doc/pkgfile/command-not-found.zsh" ]] && source /usr/share/doc/pkgfile/command-not-found.zsh
        ;;

    Darwin)
        # Load grc
        [[ -s "`brew --prefix`/etc/grc.zsh" ]] && source "`brew --prefix`/etc/grc.zsh"
        ;;
esac

# Case insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Enable Autosuggestion
# source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

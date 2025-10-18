#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[i] Dotfiles directory detected at: $DOTFILES_DIR"
echo "[i] Starting Ubuntu dotfiles setup"

backup_file() {
    local file="$1"
    if [ -f "$file" ] && [ ! -h "$file" ]; then
        echo "[i] Backing up existing $file to ${file}_backup"
        mv "$file" "${file}_backup"
    elif [ -d "$file" ] && [ ! -h "$file" ]; then
        echo "[i] Backing up existing $file to ${file}_backup"
        mv "$file" "${file}_backup"
    fi
}

create_symlink() {
    local src="$1"
    local dest="$2"
    
    if [ -e "$dest" ] || [ -h "$dest" ]; then
        if [ -h "$dest" ]; then
            local current_target="$(readlink "$dest")"
            if [ "$current_target" = "$src" ]; then
                echo "[✓] $dest already linked correctly"
                return
            fi
        fi
        backup_file "$dest"
    fi
    
    local dest_dir="$(dirname "$dest")"
    if [ ! -d "$dest_dir" ]; then
        echo "[i] Creating directory $dest_dir"
        mkdir -p "$dest_dir"
    fi
    
    echo "[i] Linking $src -> $dest"
    ln -s "$src" "$dest"
}

echo ""
echo "[i] Linking dotfiles..."
echo ""

create_symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
create_symlink "$DOTFILES_DIR/vim/.vim" "$HOME/.vim"

create_symlink "$DOTFILES_DIR/config/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
create_symlink "$DOTFILES_DIR/config/vscode/keybindings.json" "$HOME/.config/Code/User/keybindings.json"

create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

create_symlink "$DOTFILES_DIR/bash/.bash_profile" "$HOME/.bash_profile"
create_symlink "$DOTFILES_DIR/bash/.inputrc" "$HOME/.inputrc"
create_symlink "$DOTFILES_DIR/bash/.zshrc" "$HOME/.zshrc"

create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

create_symlink "$DOTFILES_DIR/i3/config" "$HOME/.config/i3/config"
create_symlink "$DOTFILES_DIR/i3/i3blocks.conf" "$HOME/.config/i3/i3blocks.conf"
create_symlink "$DOTFILES_DIR/i3/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
create_symlink "$DOTFILES_DIR/i3/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"

create_symlink "$DOTFILES_DIR/.xprofile" "$HOME/.xprofile"

echo ""
echo "[✓] Dotfiles linked successfully!"
echo "[i] Done."

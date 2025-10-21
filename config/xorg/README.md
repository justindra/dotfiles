# Xorg Configuration

X11 configuration files for keyboard and input device settings.

## Files

### kbd-caps-escape.conf

Maps the Caps Lock key to function as Escape. This configuration is applied to all keyboards automatically, including when keyboards are hot-plugged (USB keyboards plugged in after boot).

This eliminates the need to manually run `setxkbmap -option caps:escape` each time a keyboard is connected.

The file is symlinked to `~/.config/xorg.conf.d/kbd-caps-escape.conf` during setup.

#!/usr/bin/env bash
set -e

echo "[i] Ask for sudo password"
sudo -v

case "$(uname -s)" in
	Darwin)
		# install Command Line Tools
		if [[ ! -x /usr/bin/gcc ]]; then
			echo "[i] Install macOS Command Line Tools"
			xcode-select --install
		fi

		# Install homebrew
		if [[ ! -x /usr/local/bin/brew ]]; then
			echo "[i] Install Homebrew"
			ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		fi

		# Install ansible
		if [[ ! -x /usr/local/bin/ansible ]]; then
			echo "[i] Install Ansible"
			brew install ansible
		fi

		# Set macOS Defaults
		echo "[i] Setting some specific macOS settings"
		set +e
		./macos.bash
		set -e
		;;
	*)
		echo "[!] Unsupported OS"
		exit 1
		;;
esac


#!/usr/bin/env bash
set -e

source "${HOME}/bin/helpers.sh"

if ! ask "${txtylw}Did you copy/generate SSH/GPG keys?${txtrst}" N; then
	echo "Well, set them up first and then run the install script again"
	exit 1
fi

# Install packages (pacman, AUR, npm etc)
if ask "${txtylw}Install packages?${txtrst}" Y; then
	#echo -e "${undwht}Will${txtrst} ${txtwht}install them sometime in the future${txtrst} ${txtylw}:)${txtrst}";

	# Install pacman packages
	sudo pacman -Syu --noconfirm --needed $(< pacman-deps.txt)

	if ask "${txtylw}Install AUR packages?${txtrst}" Y; then
		if ! hash yay 2>/dev/null; then
			# Install yay for AUR packages
			(cd /tmp && git clone --depth 1 https://aur.archlinux.org/yay.git && cd yay && makepkg -si)
		fi

		yay -Sya --noconfirm --needed $(< aur-deps.txt)
	fi

	# Install zplug
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi


if ask "${txtylw}Setup awesomewm?${txtrst}" Y; then
	# TODO: Use --local and without sudo
	sudo luarocks install --lua-version=5.3 lain

	# grab layout-machi
	git clone --depth 1 git@github.com:xinhaoyuan/layout-machi.git ~/.config/awesome/layout-machi

	# TODO: Copy the icons needed for theme.lua
	# cd "$(dirname "$(luarocks which lain --lua-version=5.3 | head -1)")"
fi

if ask "${txtylw}Symlink dotfiles?${txtrst}" Y; then

	# Check for GNU Stow
	if ! hash stow 2>/dev/null; then
		echo -e "${txtred}ERORR: GNU Stow is required!${txtrst}\nPlease install it in order to continue."
		exit 1;
	fi

	mkdir -p ~/dotfile_conflicts
	echo -e "${undylw}Backing up conflicts to ~/dotfile_conflicts..${txtrst}"
	IFS=$'\n'

	for file in $(stow -n $(ls */ -d | grep -v "root") 2>&1 | grep -oE ":.+" | cut -c3-); do
		if [ -f ~/$file ]; then
			mkdir -p ~/dotfile_conflicts/$(dirname $file)
			mv ~/$file ~/dotfile_conflicts/$file
			echo $file
		fi
	done

	echo -e "${txtylw}Linking dotfiles to home dir...${txtrst}"
	stow $(ls */ -d | grep -v "root")

	if ask "${txtylw}Symlink root dotfiles?${txtrst}" N; then
		sudo stow root -t /
	fi
fi

if ask "${txtylw}Setup Docker?${txtrst}" N; then
	sudo usermod -aG docker $USER
	sudo systemctl enable docker.service
	echo -n "Added user to docker group and enabled systemd service"
fi

if ask "${txtylw}Disable global KDE keymaps?${txtrst}" N; then
	hotkeysRC=~/.config/kglobalshortcutsrc

	# Remove application launching shortcuts.
	sed -i 's/_launch=[^,]*/_launch=none/g' "$hotkeysRC"

	# Remove other global shortcuts.
	sed -i 's/^\([^_].*\)=[^,]*/\1=none/g' "$hotkeysRC"

	# Reload hotkeys.
	kquitapp5 kglobalaccel && sleep 2s && kglobalaccel5 &
fi

if ask "${txtylw}Replace sh with dash?${txtrst}" N; then

	if [[ -f /usr/bin/dash ]]; then
		echo "Replacing /usr/bin/sh by dash. Reinstall core/bash to revert."
		ln -sf --backup /usr/bin/dash /usr/bin/sh && rm "/usr/bin/sh~"
	else
		echo "Dash not installed. Skipping."
	fi
fi

if ask "${txtylw}Set time/date options?${txtrst}" N; then
	timedatectl set-timezone "Europe/Sofia"
	timedatectl set-ntp true
	sudo hwclock --systohc --utc
	echo "NTP has been enabled and hardware clock will be in UTC. More information: https://wiki.archlinux.org/index.php/Time"
fi

if ask "${txtylw}Set system locale to en_US.UTF-8?${txtrst}" N; then
	sudo localectl set-locale LANG=en_GB.UTF-8
	echo "If having weird locale problems, check https://wiki.archlinux.org/index.php/Locale"
	fi

	if ask "${txtylw}Change shell to zsh?${txtrst}" N; then
		chsh -s $(which zsh)
	fi

	echo -e "\n${txtgrn}BYE!${txtrst}"


#TODO: Run TPM (prefix + I) on first load of tmux
#

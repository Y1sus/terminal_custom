#!/bin/bash

set -eu -o pipefail

# ----- declare variable with paths -----
user=`whoami`
home_directory="/home/$user"

config_dir="$home_directory/.config"
nvim_dir="$config_dir/nvim"
kitty_dir="$config_dir/kitty"
# -----------------------------------



function copyAll(){
	echo "Starting copy files ..."
	cp -n ".tmux.conf" $home_directory
	cp -n ".zshrc" $home_directory
	if [ ! -d "$home_directory/.fonts" ]; then 	
		cp -r -n ".fonts" $home_directory
	else
		cp -r -n ".fonts" $home_directory
	fi; wait

	cp -r -n ".config/nvim" $config_dir
	cp -r -n ".config/kitty" $config_dir
}

function dependenciesInstall(){
	
	sudo apt update && sudo apt upgrade -y

	sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates net-tools

    sudo snap install lsd
	
	curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt install neovim python3 python3-pip nodejs git wget zsh tmux kitty bat -y

}


function dependenciesCustomizationInstall(){
	# Install all dependencies for zsh
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim	
	
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	
	# Install dependencies for tmux 
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    [[ -x $(command -v zsh &> /dev/null) ]] && sudo apt install zsh

	# installing powerlevel10k
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

	# Installer to oh my zsh
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

}

dependenciesInstall; wait
if [ -d $config_dir ]; then
	[[ ! -d $nvim_dir ]] && echo "Creating nvim directory" && mkdir $nvim_dir
	[[ ! -d $kitty_dir ]] && echo "Creating kitty directory" && mkdir $kitty_dir
	
	copyAll
	
else 
	mkdir -p "$config_dir"
	mkdir $nvim_dir
	mkdir $kitty_dir

	copyAll
fi

dependenciesCustomizationInstall

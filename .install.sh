#!/bin/bash

# Installing stuff:

cd ~
git clone https://aur.archlinux.gsettings set org/yay.git && cd yay && makepkg -si
git clone https://aur.archlinux.gsettings set org/paru.git && cd paru && makepkg -si
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
sudo pacman -S --noconfirm hyprshot tldr eza oh-my-zsh hyprpicker zsh fzf ghostty zen-browser-bin neovim alacritty dunst eza rofi-wayland waybar yazi btop npm python3 fastfetch obsidian lazygit zoxide fd vlc wev man wakatime wget curl lua luarocks cliphist zsh-syntax-highlighting cmake crush docker brightnessctl figlet tmux imagemagick hyprlock swww spotify imv lolcat bat ripgrep wl-clipboard gnome-calendar gnome-calculator tty-clock
sudo pacman -Rns --noconfirm nano wofi
yay -S --noconfirm wlogout nerd-fonts-cascadia-code nerd-fonts-jetbrains-mono swayosd less crontab zff spicetify-cli spicetify-themes-git tokyonight-gtk-theme github-cli bibata-cursor-themes ttf-font-awesome
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 
git clone https://github.com/Armaghan-Bashir-ch/walls ~/backgrounds/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab/
nvim --headless +Lazy sync +qa
mv ~/.config/.zshrc ~/.zshrc
mv ~/.config/.tmux.conf ~/.tmux.conf
mv ~/.config/.pk10k.zsh ~/.pk10k.zsh
cp -r ~/.config/zff ~/.zff
mkdir -p "home/armaghan/Obsidian Vault/.obsidian/snippets"
cp -r ~/.config/obsidian-snippets "home/armaghan/Obsidian Vault/.obsidian/snippets"
(chsh -s $(which zsh))
swww-daemon &
sudo pacman -Sc --noconfirm
yay -Sc --noconfirm
hyprctl setcursor "Bibata-Modern-Ice" 18

# Setting up

cd ~/.config/hypr/scripts/
chmod +x *.sh
chmod +x rofi/clipboard/launcher.sh
chmod +x rofi/shortcuts/script.sh
chmod +x rofi/wallselect/script.sh
chmod +x rofi/wallselect/wall-cycle.sh
chmod +x rofi/wifi/wifi.sh
swayosd-server  >/dev/null 2>&1 &
systemctl enable docker
systemctl enable NetworkManager 
spicetify backup apply enable-devtools
spicetify config current_theme StarryNight
spicetify config color_scheme Forest
spicetify apply
fc-cache -fv
gsettings set org.gnome.desktop.interface accent-color 'blue'
gsettings set org.gnome.desktop.interface avatar-directories @as []
gsettings set org.gnome.desktop.interface can-change-accels false
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds false
gsettings set org.gnome.desktop.interface clock-show-weekday false
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface cursor-blink true
gsettings set org.gnome.desktop.interface cursor-blink-time 1200
gsettings set org.gnome.desktop.interface cursor-blink-timeout 10
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface cursor-theme 'default'
gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 10'
gsettings set org.gnome.desktop.interface enable-animations true
gsettings set org.gnome.desktop.interface enable-hot-corners true
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
gsettings set org.gnome.desktop.interface font-hinting 'full'
gsettings set org.gnome.desktop.interface font-name 'Cantarell 10'
gsettings set org.gnome.desktop.interface font-rendering 'automatic'
gsettings set org.gnome.desktop.interface font-rgba-order 'rgb'
gsettings set org.gnome.desktop.interface gtk-color-palette 'black:white:gray50:red:purple:blue:light blue:green:yellow:orange:lavender:brown:goldenrod4:dodger blue:pink:light green:gray10:gray30:gray75:gray90'
gsettings set org.gnome.desktop.interface gtk-color-scheme ''
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste true
gsettings set org.gnome.desktop.interface gtk-im-module ''
gsettings set org.gnome.desktop.interface gtk-im-preedit-style 'callback'
gsettings set org.gnome.desktop.interface gtk-im-status-style 'callback'
gsettings set org.gnome.desktop.interface gtk-key-theme 'Default'
gsettings set org.gnome.desktop.interface gtk-theme 'Tokyo-Night'
gsettings set org.gnome.desktop.interface gtk-timeout-initial 200
gsettings set org.gnome.desktop.interface gtk-timeout-repeat 20
gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dracula'
gsettings set org.gnome.desktop.interface locate-pointer false
gsettings set org.gnome.desktop.interface menubar-accel 'F10'
gsettings set org.gnome.desktop.interface menubar-detachable false
gsettings set org.gnome.desktop.interface menus-have-tearoff false
gsettings set org.gnome.desktop.interface monospace-font-name 'CaskaydiaCove Nerd Font Mono 9'
gsettings set org.gnome.desktop.interface overlay-scrolling true
gsettings set org.gnome.desktop.interface scaling-factor 0
gsettings set org.gnome.desktop.interface show-battery-percentage false
gsettings set org.gnome.desktop.interface text-scaling-factor 1.0
gsettings set org.gnome.desktop.interface toolbar-detachable false
gsettings set org.gnome.desktop.interface toolbar-icons-size 'large'
gsettings set org.gnome.desktop.interface toolbar-style 'both-horiz'
gsettings set org.gnome.desktop.interface toolkit-accessibility false
cd ~
mkdir -p media books Downloads armaghan@work
cd media
mkdir -p tvShows Movies Others

# Npm installing

npm install @google/gemini-cli@0.1.11 @github/copilot@0.0.342 @electron/asar@0.0.0-development opencode-ai@0.13.5 node-gyp@11.4.2 @qwen-code/qwen-code@0.0.7 

# Symlinks/Copy and aftermath commands

mkdir -p ~/dotfiles
cd ~/dotfiles
cp -r ~/.config/hypr .
rm -rf ~/.config/hypr
ln -s ~/dotfiles/hypr ~/.config/hypr
cp -r ~/.config/waybar . 
rm -rf ~/.config/waybar 
ln -s ~/dotfiles/waybar ~/.config/waybar
cp -r ~/.config/wlogout . 
rm -rf ~/.config/wlogout 
ln -s ~/dotfiles/wlogout ~/.config/wlogout
cp -r ~/.config/yazi . 
rm -rf ~/.config/yazi 
ln -s ~/dotfiles/yazi ~/.config/yazi
mv ~/.config/zff . 
rm -rf ~/.config/zff 
ln -s ~/dotfiles/zff ~/.zff
cp ~/.zshrc . 
rm ~/.zshrc 
ln -s ~/dotfiles/.zshrc ~/.zshrc
cp ~/.tmux.conf . 
rm ~/.tmux.conf 
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
cp ~/.pk10k.zsh . 
rm ~/.pk10k.zsh 
ln -s ~/dotfiles/.pk10k.zsh ~/.pk10k.zsh
cp ~/.install.sh . 
rm ~/.install.sh 
ln -s ~/dotfiles/.install.sh ~/.install.sh
cp -r ~/.config/lazygit . 
rm -rf ~/.config/lazygit 
ln -s ~/dotfiles/lazygit ~/.config/lazygit
cp -r ~/.config/lsd . 
rm -rf ~/.config/lsd 
ln -s ~/dotfiles/lsd ~/.config/lsd
cp -r ~/.config/obsidian-snippets .
rm -rf ~/.config/obsidian-snippets
rm -rf "/home/armaghan/Obsidian Vault/.obsidian/snippets"
ln -s ~/dotfiles/obsidian-snippets/ "/home/armaghan/Obsidian Vault/.obsidian/snippets"
cp -r ~/.config/nvim . 
rm -rf ~/.config/nvim 
ln -s ~/dotfiles/nvim ~/.config/nvim
cp -r ~/.config/opencode . 
rm -rf ~/.config/opencode 
ln -s ~/dotfiles/opencode ~/.config/opencode
cp -r ~/.config/rofi . 
rm -rf ~/.config/rofi 
ln -s ~/dotfiles/rofi ~/.config/rofi
cp -r ~/.config/swayosd . 
rm -rf ~/.config/swayosd 
ln -s ~/dotfiles/swayosd ~/.config/swayosd
cp -r ~/.config/waybar . 
rm -rf ~/.config/waybar 
ln -s ~/dotfiles/waybar ~/.config/waybar
cp -r ~/.config/alacritty . 
rm -rf ~/.config/alacritty 
ln -s ~/dotfiles/alacritty ~/.config/alacritty
cp -r ~/.config/btop . 
rm -rf ~/.config/btop 
ln -s ~/dotfiles/btop ~/.config/btop
cp -r ~/.config/dunst . 
rm -rf ~/.config/dunst 
ln -s ~/dotfiles/dunst ~/.config/dunst
cp -r ~/.config/ghostty . 
rm -rf ~/.config/ghostty 
ln -s ~/dotfiles/ghostty ~/.config/ghostty
git init

# Reloading hyprland

hyprctl reload

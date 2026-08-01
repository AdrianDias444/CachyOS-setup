#!/bin/bash

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm neovim
sudo pacman -S --needed --noconfirm flatpak
sudo pacman -S --needed --noconfirm blender
sudo pacman -S --needed --noconfirm spotify-launcher
sudo pacman -S --needed --noconfirm lutris
sudo pacman -S --needed --noconfirm freecad
sudo pacman -S --needed --noconfirm obs-studio
sudo pacman -S --needed --noconfirm zig
sudo pacman -S --needed --noconfirm kicad
sudo pacman -S --needed --noconfirm texlive-most
sudo pacman -S --needed --noconfirm okular
sudo pacman -S --needed --noconfirm libreoffice-fresh


if ! command -v yay &> /dev/null; then
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
else
    echo "yay já está instalado"
fi


yay -S --needed --noconfirm visual-studio-code-bin
yay -S --needed --noconfirm vesktop
yay -S --needed --noconfirm brave-bin
yay -S --needed --noconfirm fresh-editor
yay -S --needed --noconfirm pokemmo-bin
yay -S --needed --noconfirm manim
yay -S --needed --noconfirm davinci-resolve




flatpak update
flatpak install flathub org.vinegarhq.Sober
flatpak install flathub com.overwolf.CurseForge




bash <(curl -sSL https://raw.githubusercontent.com/SpotX-Official/SpotX-Bash/main/spotx.sh)
sh neovim.sh

#!/bin/bash

echo "Instalando NvChad..."

sudo pacman -S --needed --noconfirm neovim git ripgrep gcc make cmake unzip nodejs npm

rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

git clone https://github.com/NvChad/starter ~/.config/nvim --depth 1

rm -rf ~/.config/nvim/.git

nvim --headless "+Lazy! sync" +qa

echo ""
echo "✅ NvChad installed!"
echo "Execute 'nvim' para usar"

#!/bin/bash

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; }
info() { echo -e "${BLUE}[i]${NC} $1"; }

install_pkg() {
    local pkg="$1"
    if pacman -Q "$pkg" &>/dev/null; then
        log "$pkg já instalado"
        return 0
    fi
    
    if sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null; then
        log "$pkg instalado"
    else
        warn "Conflito com $pkg, usando --overwrite"
        sudo pacman -S --needed --noconfirm --overwrite='*' "$pkg" 2>/dev/null || {
            warn "Não foi possível instalar $pkg, continuando..."
        }
    fi
}

if [ ! -f /etc/arch-release ]; then
    error "Apenas Arch Linux e derivados!"
fi

if [ "$EUID" -eq 0 ]; then
    error "Não execute como root!"
fi

echo "=========================================="
echo "  Hyprland Rice Installer - NVIDIA"
echo "=========================================="
echo ""


info "Verificando drivers NVIDIA..."

if ! pacman -Q nvidia-dkms &>/dev/null && ! pacman -Q nvidia &>/dev/null; then
    info "Instalando drivers NVIDIA..."
    
    sudo rm -rf /usr/share/doc/libxnvctrl 2>/dev/null || true
    sudo pacman -Rdd --noconfirm libxnvctrl nvidia-settings 2>/dev/null || true
    
    sudo pacman -S --needed --noconfirm --overwrite='*' \
        nvidia-dkms nvidia-utils nvidia-settings \
        egl-wayland libglvnd || warn "Verifique os drivers NVIDIA manualmente"
    
    log "Drivers NVIDIA instalados"
else
    log "Drivers NVIDIA já instalados"
fi


info "Verificando yay..."

if ! command -v yay &> /dev/null; then
    install_pkg "git"
    install_pkg "base-devel"
    
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    log "Yay instalado"
else
    log "Yay já instalado"
fi

info "Verificando Hyprland..."

if pacman -Q hyprland &>/dev/null; then
    log "Hyprland já instalado: $(pacman -Q hyprland | awk '{print $2}')"
    echo -n "Reinstalar/atualizar Hyprland? [s/N]: "
    read -r re
    if [[ "$re" =~ ^[Ss] ]]; then
        sudo pacman -S --noconfirm --overwrite='*' hyprland
        log "Hyprland reinstalado"
    fi
else
    sudo pacman -S --noconfirm --overwrite='*' hyprland || error "Falha ao instalar Hyprland"
    log "Hyprland instalado"
fi

info "Configurando Zsh..."

install_pkg "zsh"

if ! command -v wget &> /dev/null; then
    sudo pacman -S --noconfirm --overwrite='*' wget 2>/dev/null || warn "wget não instalado"
fi

if [ "$SHELL" != "/usr/bin/zsh" ] && [ "$SHELL" != "/bin/zsh" ]; then
    chsh -s $(which zsh) 2>/dev/null || warn "Use: chsh -s \$(which zsh)"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 2>/dev/null || warn "Oh-My-Zsh não instalado"
    [ -d "$HOME/.oh-my-zsh" ] && log "Oh-My-Zsh instalado"
else
    log "Oh-My-Zsh já instalado"
fi

# Plugins zsh
yay -S --noconfirm \
    zsh-autosuggestions-git \
    zsh-autocomplete-git \
    zsh-syntax-highlighting-git \
    fast-syntax-highlighting 2>/dev/null || true

log "Zsh configurado"

info "Instalando componentes principais..."

for pkg in kitty waybar hyprlock wofi btop pavucontrol blueman networkmanager nm-connection-editor imagemagick; do
    install_pkg "$pkg"
done

for pkg in python-pywal wlogout swww grimblast-git; do
    if ! pacman -Q "$pkg" &>/dev/null; then
        yay -S --noconfirm "$pkg" 2>/dev/null || warn "Não instalou: $pkg"
    fi
done

log "Componentes instalados"

echo -n "Instalar pacotes opcionais (fastfetch, neofetch, etc)? [S/n]: "
read -r opt
if [[ ! "$opt" =~ ^[Nn] ]]; then
    for pkg in fastfetch neofetch zathura zoxide; do
        install_pkg "$pkg"
    done
    
    for pkg in cava tty-clock snake 2048.c; do
        yay -S --noconfirm "$pkg" 2>/dev/null || true
    done
    log "Opcionais instalados"
fi


echo -n "Instalar fontes? [S/n]: "
read -r f
if [[ ! "$f" =~ ^[Nn] ]]; then
    for pkg in ttf-font-awesome ttf-jetbrains-mono ttf-jetbrains-mono-nerd noto-fonts-emoji; do
        install_pkg "$pkg"
    done
    log "Fontes instaladas"
fi

info "Configurando NVIDIA..."

sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup 2>/dev/null || true

if grep -q "^MODULES=()" /etc/mkinitcpio.conf; then
    sudo sed -i 's/^MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
elif ! grep -q "nvidia" /etc/mkinitcpio.conf; then
    sudo sed -i 's/^MODULES=(\(.*\))/MODULES=(\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
fi

sudo mkinitcpio -P 2>/dev/null || warn "initramfs não atualizado"

# GRUB
if [ -f /etc/default/grub ] && ! grep -q "nvidia_drm.modeset=1" /etc/default/grub; then
    sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nvidia_drm.modeset=1"/' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg 2>/dev/null || true
fi

log "NVIDIA configurado"

echo -n "Clonar dotfiles do LierB? [S/n]: "
read -r d
if [[ ! "$d" =~ ^[Nn] ]]; then
    cd ~
    [ -d "dotfiles" ] && mv dotfiles "dotfiles.backup.$(date +%Y%m%d_%H%M%S)"
    
    git clone https://github.com/LierB/dotfiles.git 2>/dev/null || warn "Falha ao clonar"
    
    [ -d ~/.config ] && cp -r ~/.config ~/.config.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null
    
    mkdir -p ~/.config
    cp -R dotfiles/.config/* ~/.config/ 2>/dev/null || true
    
    [ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
    cp dotfiles/.zshrc ~/ 2>/dev/null || true
    
    mkdir -p ~/wallpapers
    cp -R dotfiles/wallpapers/* ~/wallpapers/ 2>/dev/null || true
    
    log "Dotfiles configurados"
fi

HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"

if [ -f "$HYPR_CONFIG" ] && ! grep -q "LIBVA_DRIVER_NAME,nvidia" "$HYPR_CONFIG"; then
    cp "$HYPR_CONFIG" "$HYPR_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
    sed -i '1i\
env = LIBVA_DRIVER_NAME,nvidia\
env = XDG_SESSION_TYPE,wayland\
env = GBM_BACKEND,nvidia-drm\
env = __GLX_VENDOR_LIBRARY_NAME,nvidia' "$HYPR_CONFIG"
    log "Variáveis NVIDIA adicionadas ao Hyprland"
fi

echo ""
echo "=========================================="
echo "  ✅ INSTALAÇÃO CONCLUÍDA!"
echo "=========================================="
echo ""
echo "Próximos passos:"
echo "  1. Reinicie o sistema: sudo reboot"
echo "  2. Selecione 'Hyprland' no login"
echo ""

echo -n "Reiniciar agora? [s/N]: "
read -r rb
[[ "$rb" =~ ^[Ss] ]] && { echo "Reiniciando..."; sleep 3; sudo reboot; }

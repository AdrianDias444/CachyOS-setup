# Dotfiles Installer

> ⚠️ **Under development and not fully tested** — This script was designed for my personal setup.

## Requirements

Before running, ensure you have:

- **Arch Linux** or an Arch-based distribution (EndeavourOS, Manjaro, CachyOS, ArcoLinux, etc.)
- **Hyprland** as your tiling window manager
- **NVIDIA GPU** (the script installs specific drivers for it)
- And a bit of faith that this will work 🙏

> If you don't have an NVIDIA GPU, you'll need to modify the driver installation parts manually. GOOD LUCK MY BOY.

---

## What this does

This repository contains a collection of shell scripts to fully automate the installation and configuration of the tools I use.

The dotfiles are based on the excellent work by **LierB**:
👉 [github.com/LierB/dotfiles](https://github.com/LierB/dotfiles)

I created the main installer script that applies everything in a single executable.

Wallpapers are manually added and stored in a separate folder — I'll clone my own collection, not the original one.

---

## Scripts breakdown

### `install.sh`

Performs the installation of official packages using `pacman`:

| Package      | Description            |
|--------------|------------------------|
| neovim       | Text editor            |
| flatpak      | Package manager        |
| blender      | 3D modeling            |
| spotify      | Music streaming        |
| lutris       | Game manager           |
| freecad      | CAD software           |
| obs-studio   | Recording/streaming    |
| zig          | Programming language   |
| kicad        | PCB design             |
| texlive      | LaTex package          |
| okular       | Pdf reader             |
| LibreOffice  | Open Source Office     |
| Pipx         | Py Application manager |


Then, it checks if **yay** (AUR helper) is installed.

If available, it installs via `yay`:

| Package  | Description                  |
|----------|------------------------------|
| vscode   | Code editor                  |
| vesktop  | Discord client for Arch      |
| brave    | Web browser                  |
| fresh    | IDE made in Rust             |
| pokemmo  | Online Pokémon game          |
| manim    | PyLib for maths animations   |
| davince  | Fusion for visual effects    |

Using **flatpak**, it installs:

| Package    | Description         |
|------------|---------------------|
| sober      | Roblox for Linux    |
| curseforge | Minecraft Launcher  |


Using **pipx**, it installs:
| Package     | Description           |
|-------------|-----------------------|
| norminette  | 42 code norms checker |


After that, it runs **SpotX-Bash**, an ad blocker for the Spotify client installed earlier.

Finally, it executes the Neovim setup script.

---

### `neovim.sh`

Sets up Neovim with the **NvChad** starter configuration:

👉 [github.com/NvChad/starter](https://github.com/NvChad/starter)

Credits to the NvChad — amazing work. I'll probably change a few things manually later, however thx bro.

---

## License / Credits

- Dotfiles base: [LierB](https://github.com/LierB/dotfiles)
- Neovim config: [NvChad](https://github.com/NvChad/starter)
- Spotify ad blocker: [SpotX-Bash](https://github.com/SpotX-Official/SpotX-Bash)
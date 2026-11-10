### `install.sh`

Performs the installation of official packages using `pacman`:

| Package     | Description            |
| ----------- | ---------------------- |
| neovim      | Text editor            |
| flatpak     | Package manager        |
| blender     | 3D modeling            |
| spotify     | Music streaming        |
| lutris      | Game manager           |
| freecad     | CAD software           |
| obs-studio  | Recording/streaming    |
| zig         | Programming language   |
| kicad       | PCB design             |
| texlive     | LaTex package          |
| okular      | Pdf reader             |
| LibreOffice | Open Source Office     |
| Pipx        | Py Application manager |

Then, it checks if **yay** (AUR helper) is installed.

If available, it installs via `yay`:

| Package | Description                |
| ------- | -------------------------- |
| vscode  | Code editor                |
| vesktop | Discord client for Arch    |
| brave   | Web browser                |
| fresh   | IDE made in Rust           |
| pokemmo | Online Pokémon game        |
| manim   | PyLib for maths animations |
| davince | Fusion for visual effects  |

Using **flatpak**, it installs:

| Package    | Description        |
| ---------- | ------------------ |
| sober      | Roblox for Linux   |
| curseforge | Minecraft Launcher |

Using **pipx**, it installs:

| Package        | Description           |
| -------------- | --------------------- |
| norminette     | 42 code norms checker |
| c-formatter-42 | 42 file formatter     |

After that, it runs **SpotX-Bash**, an ad blocker for the Spotify client installed earlier.

## License / Credits

- Dotfiles base: [LierB](https://github.com/LierB/dotfiles)
- Neovim config: [NvChad](https://github.com/NvChad/starter)
- Spotify ad blocker: [SpotX-Bash](https://github.com/SpotX-Official/SpotX-Bash)

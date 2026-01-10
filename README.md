# dotfiles

Some of my dotfiles and other assets + resources I use. Configs and other resources should be compatible across common linux distros.

## Layout

- `zsh/`
  Zsh config

- `git/`
  Git config

- `config/`
  App configs usually under `~/.config/`

- `assets/wallpapers/`
  Some wallpapers I've used

- `docs/`
  Some key references and lists:
    - `themes-and-icons.md` themes and icons used and where to find them 
    - `vscode-extensions.txt` vscode extensions list

- `bootstrap/`
  Help install and set up important system packages and flatpack apps (e.g., docker, stow, npm, a browset etc.)

## Bootstrap 

This is mostly for me to maintain a list of packages that I would like on any system, as well as a method to install all of it easily. 
Mostly just software that I would like to be available immediately or that I would be using frequently. Should be a fairly light list. 

 Within `bootstrap` there is a simple bootstrap script that installs:
- System packages from `bootstrap/packages/apt.txt` (Debian/Ubuntu/Mint)
- Flatpak apps from `bootstrap/packages/flatpak.txt` (via Flathub)

Run:
```bash
cd ~/dotfiles
chmod +x bootstrap/install.sh
./bootstrap/install.sh
```
Currently I only have a list for apt packages, but the script supports apt and pacman package managers. More lists and support in the future perhaps

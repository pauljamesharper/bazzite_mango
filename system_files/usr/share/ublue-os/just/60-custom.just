# Clone the dotfiles repo to ~/dotfiles (or update it) and stow every package
dotfiles:
    #!/usr/bin/bash
    set -euo pipefail
    dir="$HOME/dotfiles"
    if [ ! -d "$dir/.git" ]; then
        # HTTPS works before an SSH key is set up; pushes go over SSH
        git clone https://github.com/pauljamesharper/dotfiles.git "$dir"
        git -C "$dir" remote set-url --push origin git@github.com:pauljamesharper/dotfiles.git
    else
        git -C "$dir" pull --ff-only
    fi
    cd "$dir"
    mapfile -t pkgs < <(find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -printf '%P\n' | sort)
    # .stowrc in the repo sets --target=~ and --no-folding
    stow --restow "${pkgs[@]}"
    echo "Stowed: ${pkgs[*]}"

# Copy the Mango dotfiles, themes and wallpapers into ~/.config/mango
mango-setup:
    /usr/bin/bazzite-mango-setup

# Install the Flatpak apps: the ones the Mango keybindings launch (Firefox, Brave,
# GIMP, OBS, Discord) plus Telegram
mango-apps:
    flatpak install --user -y flathub org.mozilla.firefox com.brave.Browser org.gimp.GIMP com.obsproject.Studio com.discordapp.Discord org.telegram.desktop

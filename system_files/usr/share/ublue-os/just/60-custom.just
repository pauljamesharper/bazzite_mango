# Copy the Mango dotfiles, themes and wallpapers into ~/.config/mango
mango-setup:
    /usr/bin/bazzite-mango-setup

# Install the Flatpak apps the Mango keybindings launch (Firefox, Brave, GIMP, OBS, Discord)
mango-apps:
    flatpak install --user -y flathub org.mozilla.firefox com.brave.Browser org.gimp.GIMP com.obsproject.Studio com.discordapp.Discord

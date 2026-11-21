#!/usr/bin/env bash
# Post-checkout setup for a fresh machine (Arch + Hyprland + Caelestia already installed).
# Safe to re-run.
set -uo pipefail
D="$HOME/.config/dots"

# Machine-specific files that aren't tracked (nwg-displays writes these)
[[ -f ~/.config/hypr/monitors.lua ]] || echo "-- per-machine monitor layout (nwg-displays writes this)" > ~/.config/hypr/monitors.lua

read -rp "Install missing packages from the package lists? [y/N] " a
if [[ $a == [yY] ]]; then
    # --needed skips what's installed; packages that don't exist are skipped by pacman's error
    sudo pacman -S --needed - < "$D/pkglist-repo.txt"
    yay -S --needed - < "$D/pkglist-aur.txt"
fi

read -rp "Apply Caelestia shell patches to /etc/xdg (needs sudo)? [y/N] " a
[[ $a == [yY] ]] && ~/.local/bin/caelestia-apply-patches

# Colour scheme + wallpaper
caelestia scheme set -n everblush -f medium -m dark -v tonalspot
caelestia wallpaper -f ~/Pictures/Wallpapers/wallhaven-w5xdzx_2560x1440.png -N

hyprctl reload >/dev/null && echo "Done. Hyprland reloaded."

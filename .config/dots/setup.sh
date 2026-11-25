#!/usr/bin/env bash
# Post-checkout setup for a fresh machine (Arch + Hyprland + Caelestia already installed).
# Safe to re-run.
set -uo pipefail
D="$HOME/.config/dots"

# `dots` alias for zsh (fish/bash get it from tracked files)
if [[ -f ~/.zshrc ]] && ! grep -q "alias dots=" ~/.zshrc; then
    printf "\n# dotfiles bare repo (see ~/.github/README.md)\nalias dots='git --git-dir=\$HOME/.dots --work-tree=\$HOME'\n" >> ~/.zshrc
fi

# Machine-specific files that aren't tracked (nwg-displays writes these)
[[ -f ~/.config/hypr/monitors.lua ]] || echo "-- per-machine monitor layout (nwg-displays writes this)" > ~/.config/hypr/monitors.lua

read -rp "Install missing packages from the package lists? [y/N] " a
if [[ $a == [yY] ]]; then
    # pacman/yay abort the whole install on a single unknown name, so only pass
    # the ones that exist (e.g. steam/lib32-* need [multilib] enabled).
    repo_ok=$(comm -12 <(sort -u "$D/pkglist-repo.txt") <(pacman -Slq | sort -u))
    repo_skip=$(comm -23 <(sort -u "$D/pkglist-repo.txt") <(pacman -Slq | sort -u))
    [[ -n $repo_skip ]] && echo "Skipping (not in your enabled repos): $(echo $repo_skip)"
    [[ -n $repo_ok ]] && sudo pacman -S --needed - <<< "$repo_ok"

    if command -v yay >/dev/null; then
        aur_ok=$(yay -Sia $(cat "$D/pkglist-aur.txt") 2>/dev/null | awk '/^Name/ {print $3}')
        aur_skip=$(comm -23 <(sort -u "$D/pkglist-aur.txt") <(sort -u <<< "$aur_ok"))
        [[ -n $aur_skip ]] && echo "Skipping (not in the AUR): $(echo $aur_skip)"
        [[ -n $aur_ok ]] && yay -S --needed - <<< "$aur_ok"
    else
        echo "yay not found - skipping AUR packages ($D/pkglist-aur.txt)"
    fi
fi

# zsh: oh-my-zsh (~/.zshrc is tracked and sources it) and login shell
if command -v zsh >/dev/null; then
    [[ -d ~/.oh-my-zsh ]] || git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    if [[ $(getent passwd "$USER" | cut -d: -f7) != */zsh ]]; then
        read -rp "Make zsh your login shell? [y/N] " a
        [[ $a == [yY] ]] && chsh -s "$(command -v zsh)"
    fi
fi

read -rp "Apply Caelestia shell patches to /etc/xdg (needs sudo)? [y/N] " a
[[ $a == [yY] ]] && ~/.local/bin/caelestia-apply-patches

# Colour scheme + wallpaper
caelestia scheme set -n everblush -f medium -m dark -v tonalspot
caelestia wallpaper -f ~/Pictures/Wallpapers/wallhaven-w5xdzx_2560x1440.png -N

hyprctl reload >/dev/null && echo "Done. Hyprland reloaded."

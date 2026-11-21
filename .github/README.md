# dots

Arch + Hyprland (Lua config) + Caelestia shell.

This is a **bare repo** whose work tree is `$HOME` — files live in their normal
places, no symlinks. Use the `dots` alias exactly like `git`:

```bash
dots status            # only shows tracked files
dots add ~/.config/foo # start tracking something new
dots commit -am "msg" && dots push
dots pull              # on the other machine
```

## Setting up a new machine

Requires Arch with Hyprland + Caelestia already installed.

```bash
git clone --bare https://github.com/Eebebeebe/dots.git ~/.dots
alias dots='git --git-dir=$HOME/.dots --work-tree=$HOME'
dots config status.showUntrackedFiles no

# back up any existing files that would be overwritten, then check out
mkdir -p ~/.dots-backup
dots checkout 2>&1 | grep -E '^\s+\S' | awk '{print $1}' | \
  xargs -r -I{} sh -c 'mkdir -p ~/.dots-backup/$(dirname "{}") && mv ~/"{}" ~/.dots-backup/"{}"'
dots checkout

~/.config/dots/setup.sh
```

`setup.sh` optionally installs the package lists, applies the Caelestia patches,
sets the colour scheme and wallpaper, and reloads Hyprland.

## Notes

- **Not tracked (per machine):** `~/.config/hypr/monitors.lua` — set it with `nwg-displays`.
- **Desktop-only bits** in `hypr-user.lua` (workspace→`DP-1`/`DP-2` rules, Super+B
  left-monitor blackout) are harmless on machines without those outputs.
- **Caelestia patches:** `~/.config/caelestia/patches-backup/` holds modified copies of
  root-owned QML files. After a `caelestia-shell` update run `caelestia-apply-patches`.

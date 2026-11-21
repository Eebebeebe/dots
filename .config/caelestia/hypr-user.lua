hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("xdg-terminal-exec"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("gtk-launch $(xdg-settings get default-web-browser)"))
hl.bind("SUPER + D", hl.dsp.global("caelestia:launcher"))


hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 7,
    },
    render = {
        cm_auto_hdr = 0,
    },
})


hl.window_rule({
    name = "no-auto-fullscreen",
    match = { class = "^(kitty|steam|discord)$" },
    suppress_event = "fullscreen maximize",
})


-- hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))

-- disable color picker
hl.unbind("SUPER + SHIFT + C")

-- CTRL + ALT + Left/Right: move focused window to prev/next workspace number,
-- crossing monitors (1 = left, 2+ = right); you stay where you are
hl.bind("CTRL + ALT + left",  hl.dsp.window.move({ workspace = "-1", follow = false }), { repeating = true })
hl.bind("CTRL + ALT + right", hl.dsp.window.move({ workspace = "+1", follow = false }), { repeating = true })
hl.bind("CTRL + ALT + up",    hl.dsp.window.move({ workspace = "r-1", follow = false }))
hl.bind("CTRL + ALT + down",  hl.dsp.window.move({ workspace = "r+1", follow = false }))

-- SUPER + SHIFT + X/C: focus prev/next workspace number, crossing monitors (1 = left, 2+ = right)
hl.bind("SUPER + SHIFT + X", hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + SHIFT + C", hl.dsp.focus({ workspace = "+1" }), { repeating = true })
-- no transparency for any window
hl.window_rule({ match = { fullscreen = false }, opacity = "1.0 override" })

-- except the terminal
hl.window_rule({ match = { class = "^(foot)$" }, opacity = "0.9 override" })

-- Japanese keybind tool autostart
hl.on("hyprland.start", function()
  hl.exec_cmd("fcitx5 -d")
end)

hl.bind("SUPER + SHIFT + J", hl.dsp.exec_cmd("fcitx5-remote -t"))

-- gsimplecal: small popup calendar opened by clicking the bar clock
hl.window_rule({
    name = "gsimplecal-popup",
    match = { class = "^(gsimplecal)$" },
    float = true,
    pin = true,
    move = "(cursor_x+20) (cursor_y-window_h*0.5)",
})

-- Workspaces laid out left-to-right across monitors:
-- 1 = left monitor (DP-1), 2 = right monitor (DP-2), 3+ continue on the right monitor
hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-2", default = true, persistent = true })
for i = 3, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-2" })
end

-- SUPER + ALT + Left/Right: same as above, but your view follows the window
hl.bind("SUPER + ALT + Left",  hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + ALT + Right", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })

-- >>> MINIMAL RIGHT MONITOR (revert: delete this block, or restore hypr-user.lua.pre-minimal)
-- Smaller gaps between windows on DP-2 only (global defaults: gaps_in 3, gaps_out 7)
hl.workspace_rule({ workspace = "m[DP-2]", gaps_in = 1, gaps_out = 6 })
-- <<< MINIMAL RIGHT MONITOR

-- SUPER + B: black out the left monitor (DP-1) for immersive gaming.
-- Wakes when the cursor moves onto it, or press SUPER + B again.
hl.bind("SUPER + B", hl.dsp.exec_cmd("~/.local/bin/blackout-left"))

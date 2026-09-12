-- ============================================================================
-- Hyprland Lua configuration
-- Ported from: ~/.config/hypr.bak/hyprland.conf
-- Reference: https://wiki.hypr.land/Configuring/
-- ============================================================================


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "dms ipc call spotlight toggle"
local browser     = "zen-browser"


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "highres",
    position = "auto",
    scale    = 1.25,
})


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("AQ_DRM_DEVICES", "/dev/dri/card2:/dev/dri/card1")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_MENU_PREFIX", "arch-") -- arch- (not plasma-) = correct menu for non-Plasma sessions; fixes Dolphin's empty "Open With" (https://bbs.archlinux.org/viewtopic.php?id=295236)
-- Tell Qt apps to use the KDE theme engine
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "kde")

hl.env("GDK_BACKEND", "wayland,x11,*")
-- hl.env("GDK_SCALE", "2")
hl.env("SDL_VIDEODRIVER", "wayland")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

hl.env("NM_WVP_USE_SYSTEM_CONNECTION", "true")
hl.env("LANG", "en_US.UTF-8")
hl.env("LC_ALL", "en_US.UTF-8")


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- (equivalent of the old exec-once lines)
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_MENU_PREFIIX")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("/usr/lib/pam_kwallet_init")
    hl.exec_cmd("/usr/bin/kwalletd6")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("dms run")
    -- Rebuild KDE's service cache so Dolphin's "Open With" menu is correct at every login
    -- (XDG_MENU_PREFIX=arch- must match the env above; see https://www.lorenzobettini.it/2024/05/fixing-the-empty-open-with-in-dolphin-in-hyprland/)
    hl.exec_cmd("XDG_MENU_PREFIX=arch- kbuildsycoca6 --noincremental")
end)


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in     = 8,
        gaps_out    = 8,
        border_size = 1,

        -- See "variable types" for info about colors
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 0.95,
        inactive_opacity = 0.9,

        shadow = {
            enabled      = true,
            range        = 12,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        -- Colored halo around focused windows (swept by `glowangle` animation)
        glow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(89b4fa66)",
            color_inactive = "rgba(45475a44)",
        },

        -- See https://wiki.hypr.land/Configuring/Basics/Variables/#blur
        blur = {
            enabled  = true,
            size     = 8,
            passes   = 3,
            vibrancy = 0.1696,
            contrast = 1.25,
            brightness = 1.1,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Curves, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- Beziers (overshoot = goes past 100%, very flashy)
hl.curve("linear",       { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",        { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("overshoot",    { type = "bezier", points = { {0.5, 0.9},   {0.1, 1.1}   } }) -- spring past the end
hl.curve("backOut",      { type = "bezier", points = { {0.34, 1.56}, {0.64, 1}    } }) -- dramatic easeOutBack

-- Springs (Apple-style physics: mass 1, higher stiffness = faster, higher dampening = less bounce)
hl.curve("snappy", { type = "spring", mass = 1, stiffness = 400, dampening = 30 })
hl.curve("easy",   { type = "spring", mass = 1, stiffness = 238, dampening = 24 })
hl.curve("bouncy", { type = "spring", mass = 1, stiffness = 150, dampening = 14 })
hl.curve("rubber", { type = "spring", mass = 1, stiffness = 80,  dampening = 10 })

-- Animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.animation({ leaf = "global",         enabled = true, speed = 10,  bezier = "default" })

-- Border color switch, with an overshoot curve
hl.animation({ leaf = "border",         enabled = true, speed = 5,   bezier = "overshoot" })
-- One-shot gradient-angle sweep on focus change (flashy, but NOT `loop` style, so no constant rendering/battery drain)
hl.animation({ leaf = "borderangle",    enabled = true, speed = 10,  bezier = "default" })
hl.animation({ leaf = "glowangle",      enabled = true, speed = 10,  bezier = "default" })

-- Windows: subtle popin with bezier curves (springs overshoot past 100% and cause
-- rectangular artifacts during open; beziers stay <= 100% and don't glitch)
hl.animation({ leaf = "windows",        enabled = true, speed = 6,   bezier = "quick",   style = "popin 60%" })
hl.animation({ leaf = "windowsIn",      enabled = true, speed = 5,   bezier = "quick",   style = "popin 60%" })
hl.animation({ leaf = "windowsOut",     enabled = true, speed = 1.5, bezier = "linear", style = "popin 85%" })
-- Fast bezier instead of a spring: resizes/moves settle immediately, no bounce-lag
hl.animation({ leaf = "windowsMove",    enabled = true, speed = 3,   bezier = "quick" })

-- Fades: fast and silky, with crossfade on focus switch
hl.animation({ leaf = "fade",           enabled = true, speed = 3,   bezier = "almostLinear" })
hl.animation({ leaf = "fadeIn",         enabled = true, speed = 2,   bezier = "quick" })
hl.animation({ leaf = "fadeOut",        enabled = true, speed = 1.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeSwitch",     enabled = true, speed = 4,   bezier = "almostLinear" })
hl.animation({ leaf = "fadeShadow",     enabled = true, speed = 3,   bezier = "almostLinear" })
hl.animation({ leaf = "fadeGlow",       enabled = true, speed = 3,   bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersIn",   enabled = true, speed = 2,   bezier = "quick" })
hl.animation({ leaf = "fadeLayersOut",  enabled = true, speed = 1.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadePopups",     enabled = true, speed = 2.5, spring = "easy" })
hl.animation({ leaf = "fadePopupsIn",   enabled = true, speed = 2,   spring = "easy" })
hl.animation({ leaf = "fadePopupsOut",  enabled = true, speed = 1.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeDpms",       enabled = true, speed = 4,   bezier = "quick" })

-- Layers (DMS menus/bars etc.): fade only, no slide — DMS has its own Material
-- animations; sliding the layer surface makes a rectangular box overlay (see session notes)
hl.animation({ leaf = "layers",         enabled = true, speed = 3.5, spring = "easy" })
hl.animation({ leaf = "layersIn",       enabled = true, speed = 3.5, spring = "easy", style = "fade" })
hl.animation({ leaf = "layersOut",      enabled = true, speed = 1.5, bezier = "linear", style = "fade" })

-- Workspaces: modern slide+fade, springy special workspace
hl.animation({ leaf = "workspaces",         enabled = true, speed = 4, spring = "easy",   style = "slidefade 30%" })
hl.animation({ leaf = "workspacesIn",       enabled = true, speed = 4, spring = "easy",   style = "slidefade 30%" })
hl.animation({ leaf = "workspacesOut",      enabled = true, speed = 4, spring = "easy",   style = "slidefade 30%" })
hl.animation({ leaf = "specialWorkspace",   enabled = true, speed = 5, spring = "rubber", style = "slidefade 20%" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 5, spring = "rubber", style = "slidefade 20%" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 4, spring = "easy",   style = "slidefade 20%" })

hl.animation({ leaf = "zoomFactor",         enabled = true, speed = 7, bezier = "quick" })
hl.animation({ leaf = "monitorAdded",       enabled = true, speed = 4, spring = "bouncy" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        -- pseudotile = true -- Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Basics/Variables/#misc
hl.config({
    misc = {
        force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        middle_click_paste      = false,
        vrr                     = 2, -- Variable refresh rate: 0=off, 1=fullscreen only, 2=always on (saves power on battery)
    },
})


---------------
---- INPUT ----
---------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        repeat_rate = 60,
        repeat_delay = 200,
        numlock_by_default = true,

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.config({
    cursor = {
        no_hardware_cursors = 0,
    },
    -- Triple buffering: smoother/less laggy re-renders when windows resize
    render = {
        new_render_scheduling = true,
    },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    scale     = 3.5,
    action    = "workspace",
})
hl.gesture({
    fingers   = 3,
    direction = "up",
    scale     = 1.5,
    action    = "fullscreen",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -1.0, -- original -1.5; clamped to the new -1.0..1.0 range in 0.56
})


---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",          hl.dsp.window.close())
hl.bind(mainMod .. " + M",          hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B",          hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + V",          hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Space",      hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",          hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + J",          hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mainMod .. " + SHIFT + L",  hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + F",          hl.dsp.window.fullscreen_state({ internal = 2, client = 0, action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ workspace = "-1" }))

-- Screenshot region to clipboard
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp -o -r -c '##ff0000ff')" -t ppm - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png]]))

-- Move focus with alt + arrow keys (hjkl)
hl.bind("ALT + h", hl.dsp.focus({ direction = "l" }))
hl.bind("ALT + l", hl.dsp.focus({ direction = "r" }))
hl.bind("ALT + k", hl.dsp.focus({ direction = "u" }))
hl.bind("ALT + j", hl.dsp.focus({ direction = "d" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
    name  = "disable-blur-on-browser",
    match = { class = "(zen)" },
    opacity = "1.0 override",
})

hl.window_rule({
    name  = "exclude-mpv-transparency",
    match = { class = "(mpv)" },
    opacity = "1.0 override",
})

hl.window_rule({
    name  = "exclude-zed-transparency",
    match = { class = "(dev.zed.Zed)" },
    opacity = "1.0 override",
})

hl.window_rule({
    name  = "exclude-vlc-transparency",
    match = { class = "(vlc)" },
    opacity = "1.0 override",
})

-- Slightly transparent when kitty is the focused window
hl.window_rule({
    name  = "kitty-active-transparency",
    match = { class = "(kitty)" },
    opacity = "0.9",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})


-----------------------------------------
---- SOURCED FILES (port of `source`) ----
-----------------------------------------

-- The old config had: source = ./dms/cursor.conf
-- In Lua configs, sourced files are Lua modules (see
-- https://wiki.hypr.land/Configuring/Start/#using-multiple-configuration-files),
-- so the hyprlang env vars from that file are inlined here instead:
hl.env("HYPRCURSOR_THEME", "default")
hl.env("XCURSOR_THEME", "default")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")

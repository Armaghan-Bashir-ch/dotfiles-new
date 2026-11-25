local mainMod = "SUPER"

local browser = "zen-browser"
local terminal = "ghostty"
local backupTerminal = "alacritty"
local statusbar = "pkill -SIGUSR2 waybar"
local musicPlayer = "spotify --ozone-platform=wayland"
local obsidian = "obsidian"
local screenshot = "hyprshot -m region -o ~/screenshots"
local lockscreen = "hyprlock"
local menu = "rofi -show drun -theme ~/.config/rofi/launcher/style.rasi"
local emoji = "rofi -show emoji -theme ~/.config/rofi/clipboard/clipboard.rasi"
local clipboard = "~/.config/rofi/clipboard/launcher.sh"
local wallselect = "~/.config/rofi/wallselect/script.sh"
local colorpicker = "hyprpicker -a"
local powermenu = "wlogout --buttons-per-row 6"
local systeminfo = "ghostty -e btop"
local reload = "hyprctl reload"

hl.on("hyprland.start", function()
    hl.exec_cmd("G_MESSAGES_DEBUG=none G_LOG_LEVEL=0 exec qs -n -p ~/.config/quickshell-osd >/dev/null 2>&1")
    hl.exec_cmd("G_MESSAGES_DEBUG=none G_LOG_LEVEL=0 exec qs -n -p ~/.config/quickshell-notify >/dev/null 2>&1")
    hl.exec_cmd("G_MESSAGES_DEBUG=none G_LOG_LEVEL=0 hypridle >/dev/null 2>&1")
    hl.exec_cmd("G_MESSAGES_DEBUG=none G_LOG_LEVEL=0 hyprsunset >/dev/null 2>&1")
    hl.exec_cmd("G_MESSAGES_DEBUG=none G_LOG_LEVEL=0 elephant >/dev/null 2>&1")
    hl.exec_cmd('notify-send -a Hyprland "Welcome My Lord" "Hyprland Has Started."')
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprctl dispatch splash true")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("wl-paste --watch cliphist store &")
    hl.exec_cmd('hyprctl setcursor "Bibata-Modern-Ice" 18')
end)

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

hl.curve("smoothOut", { type = "bezier", points = { { 0.36, 0 }, { 0.66, -0.56 } } })
hl.curve("smoothIn", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("softSnap", { type = "bezier", points = { { 0.4, 0 }, { 0.2, 1 } } })
hl.curve("fluent", { type = "bezier", points = { { 0, 0 }, { 0.2, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "overshot", style = "popin 80%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "overshot", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "smoothOut", style = "popin 95%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "softSnap" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "smoothIn", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "softSnap", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "overshot" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 4, bezier = "overshot" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 4, bezier = "overshot" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 4, bezier = "overshot" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 4, bezier = "overshot" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 4, bezier = "overshot" })
hl.animation({ leaf = "fadeDpms", enabled = true, speed = 4, bezier = "overshot" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot", style = "slide" })

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 4,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(6b84b4aa)", "rgba(b36a86aa)" }, angle = 45 },
            inactive_border = "rgba(00565f89)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 25,
        rounding_power = 10,
        blur = {
            enabled = true,
            ignore_opacity = true,
            size = 8,
            passes = 2,
            new_optimizations = true,
            xray = false,
            noise = 0,
            contrast = 1.8,
            brightness = 0.4,
            vibrancy = 0.1696,
        },
        shadow = {
            enabled = false,
            range = 25,
            render_power = 3,
            color = "rgba(1a1b2699)",
        },
    },
    input = {
        sensitivity = 0.3,
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "caps:swapescape",
        numlock_by_default = true,
    },
    dwindle = { preserve_split = true },
    master = { new_status = "master" },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = true,
    },
})

hl.device({ name = "epic-mouse-v1", sensitivity = 0.6 })

hl.window_rule({ name = "windowrule-1", match = { initial_class = "zen" }, workspace = "1" })
hl.window_rule({ name = "windowrule-2", match = { class = "com.mitchellh.ghostty" }, workspace = "2" })
hl.window_rule({ name = "windowrule-3", match = { class = "spotify" }, workspace = "3", tile = true })
hl.window_rule({ name = "windowrule-4", match = { class = "t3code" }, workspace = "4", tile = true })
hl.window_rule({ name = "windowrule-5", match = { class = "org.gnome.Evince" }, workspace = "5", tile = true })
hl.window_rule({ name = "windowrule-6", match = { class = "obsidian" }, workspace = "6", tile = true })
hl.window_rule({ name = "windowrule-7", match = { class = "^(Waybar)$" }, float = true, pin = true })
hl.window_rule({ name = "windowrule-8", match = { class = ".*" }, tile = true })
hl.window_rule({ name = "windowrule-9", match = { class = "^(.*)$" }, center = true })
hl.window_rule({
    name = "windowrule-10",
    match = { class = "^(org.gnome.Calculator)$" },
    float = true,
    size = { 385, 616 },
    center = true,
})
hl.window_rule({
    name = "windowrule-11",
    match = { class = "^(localsend)$" },
    float = true,
    center = true,
    size = { 589, 646 },
})
hl.window_rule({
    name = "windowrule-12",
    match = { class = "^(org.gnome.clocks)$" },
    float = true,
    size = { 621, 428 },
    center = true,
})
hl.window_rule({
    name = "windowrule-13",
    match = { class = "^(com.network.manager)$" },
    float = true,
    size = { 600, 466 },
    center = true,
})

hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true })
hl.layer_rule({ match = { namespace = "rofi" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "walker" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "quickshell:network" }, blur = true, ignore_alpha = 0.15 })
hl.layer_rule({ match = { namespace = "quickshell:bluetooth" }, blur = true, ignore_alpha = 0.15 })
hl.layer_rule({ match = { namespace = "quickshell:controlcenter" }, blur = true, ignore_alpha = 0.15 })
hl.layer_rule({ match = { namespace = "quickshell:notifpopup" }, blur = true, ignore_alpha = 0.15 })
hl.layer_rule({ match = { namespace = "quickshell:powerprofile" }, blur = true, ignore_alpha = 0.15 })
hl.layer_rule({ match = { namespace = "quickshell:osd" }, blur = true, ignore_alpha = 0.15 })

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(musicPlayer))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(obsidian))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(backupTerminal))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(statusbar))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(lockscreen))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(screenshot))
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd(colorpicker))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd(wallselect))
hl.bind(mainMod .. " + CTRL + SHIFT + V", hl.dsp.exec_cmd(emoji))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(powermenu))
hl.bind(mainMod .. " + SHIFT + ESCAPE", hl.dsp.exec_cmd(systeminfo))
hl.bind("CTRL + SPACE", hl.dsp.exec_cmd("walker"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(reload))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("t3code"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/setup-start.sh"))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + W", hl.dsp.window.kill())
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprlock --grace 0"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprlock --grace 0"), { locked = true })
hl.bind("F3", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+"), { repeating = true })
hl.bind("F2", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), { repeating = true })
hl.bind("F1", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("F6", hl.dsp.exec_cmd("brightnessctl set 10%+"), { repeating = true })
hl.bind("F5", hl.dsp.exec_cmd("brightnessctl set 10%-"), { repeating = true })

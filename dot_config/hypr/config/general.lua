-- monitor stuff
hl.monitor({
  output = MAIN_DISPLAY,
  mode = "2560x1440@240",
  position = "auto",
  scale = "auto",
  vrr = 2,
})

hl.monitor({
  output = SECONDARY_DISPLAY,
  mode = "preferred",
  position = "auto-left",
  scale = "auto",
  transform = 1,
})

-- backup monitor
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "1"
})

-- general
hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 20,

    border_size = 1,

    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },

    resize_on_border = false,
    layout = "dwindle",
    allow_tearing = false,
  },

  decoration = {
    rounding = 10,
    rounding_power = 2,

    active_opacity = 1.0,
    fullscreen_opacity = 1.0,

    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    }
  },

  animations = {
    enabled = true,
  },

  cursor = {
    no_hardware_cursors = true,
    -- no_warps = true,
    hide_on_key_press = true,
    inactive_timeout = 20,
    default_monitor = MAIN_DISPLAY
  },

  render = {
    direct_scanout = 2
  }
})

-- Animation stuff copied straight from docs
-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 500, dampening = 41 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })


-- Layout stuff and misc
hl.config({
  dwindle = {
    preserve_split = true
  }
})

hl.config({
  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = false,
    focus_on_activate = false,
  }
})

-- Input
hl.config({
  input = {
    kb_layout = "de",
    kb_variant = "nodeadkeys",

    follow_mouse = 1,
    sensitivity = 0,
    -- force_no_accel = 1,
    accel_profile = "flat",
  }
})

-- Device specific
hl.device({
  name = "kinesis-kinesis-adv360-1",
  kb_layout = "us",
  kb_variant = "",
})

hl.device({
  name = "kanata-adv360",
  kb_layout = "us",
  kb_variant = "",
})

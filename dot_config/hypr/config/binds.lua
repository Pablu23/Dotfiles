local mainMod = "SUPER"

-- Quit Keys
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exit())

-- Program keys
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(TERMINAL))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(MENU))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(BROWSER))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(HYPRLOCK))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(STEAM))
hl.bind(mainMod .. " + S",
  hl.dsp.exec_cmd("grim -o" .. MAIN_DISPLAY .. " \"${HOME}/screenshots/screenshot-$(date +%F-%T).png\""))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))

local synth = {
  left = false,
  right = false,
  up = false,
  down = false,
}

local function smart_nav(direction)
  return function()
    if synth[direction] then
      return
    end

    local win = hl.get_active_window()

    if not win or win.class ~= "com.mitchellh.ghostty" or win.title ~= "vim" then
      hl.dispatch(hl.dsp.focus({ direction = direction }))
      return
    end

    hl.dispatch(hl.dsp.pass({ window = "activewindow" }))
    synth[direction] = true
  end
end

local function smart_nav_release(direction)
  return function()
    synth[direction] = false
  end
end

local movement_keys = {
  H = "left",
  L = "right",
  J = "down",
  K = "up"
}

for key, dir in pairs(movement_keys) do
  hl.bind(mainMod .. " + " .. key, smart_nav(dir))
  hl.bind(mainMod .. " + " .. key, smart_nav_release(dir), { release = true })
end

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))

hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Resize Keys
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + v", hl.dsp.window.float())
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- hl.bind("code:51", hl.dsp.pass({ window = "class:^([Dd]iscord)$" }), { non_consuming = true })

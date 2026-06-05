-- No gaps when only window
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
  name        = "no-gaps-wtv1",
  match       = { float = false, workspace = "w[tv1]" },
  border_size = 0,
  rounding    = 0,
})
hl.window_rule({
  name        = "no-gaps-f1",
  match       = { float = false, workspace = "f[1]" },
  border_size = 0,
  rounding    = 0,
})


-- Workspaces to monitors
for i = 1, 6 do
  hl.workspace_rule({ workspace = tostring(i), monitor = MAIN_DISPLAY, persistent = true })
end
for i = 6, 10 do
  hl.workspace_rule({ workspace = tostring(i), monitor = SECONDARY_DISPLAY, persistent = true })
end


hl.window_rule({
  name = "steam",
  match = {
    class = "steam"
  },
  monitor = SECONDARY_DISPLAY,
  workspace = "7 silent",
  no_initial_focus = true,
  focus_on_activate = false,
  suppress_event = "activatefocus"
})

hl.window_rule({
  name = "steam_notifications",
  match = {
    class = "^(steam)$",
    title = "^(notificationtoasts_.*)$"
  },
  no_focus = true,
  no_initial_focus = true
})

hl.window_rule({
  name = "discord",
  match = {
    class = "discord"
  },
  monitor = SECONDARY_DISPLAY,
  workspace = "6 silent",
  no_initial_focus = true,
  focus_on_activate = false,
  suppress_event = "activatefocus"
})

local direction_map = {
  left = "h",
  right = "l",
  up = "k",
  down = "j"
}

local runtime_dir = os.getenv("XDG_RUNTIME_DIR") or "/tmp"
local function get_stable_id()
  local handle = io.popen("hyprctl activewindow -j 2>/dev/null")
  local data = handle:read("*a")
  handle:close()
  local ok, json = pcall(vim.json.decode, data)
  if ok and json and json.stableId then
    return tostring(json.stableId)
  end
  return "unknown"
end

local stable_id = get_stable_id()

local socket_path = string.format("%s/nvim-hypr-nav-%s.sock", runtime_dir, stable_id)

local server = vim.uv.new_pipe(false)
server:bind(socket_path)
server:listen(128, function(err)
  if err then vim.notify("hypr-nav: " .. err, vim.log.levels.ERROR) end

  local conn = vim.uv.new_pipe(false)
  server:accept(conn)

  conn:read_start(function(err, data)
    if not data then
      pcall(function() conn:close() end)
      return
    end
    local direction = data:match("nav:(%a+)")
    if not direction then
      pcall(function() conn:write("invalid\n") end)

      pcall(function() conn:close() end)
      return
    end

    vim.schedule(function()
      local before = vim.api.nvim_get_current_win()
      local wincmd_dir = direction_map[direction] or direction:sub(1, 1)
      vim.cmd("wincmd " .. wincmd_dir)
      local after = vim.api.nvim_get_current_win()
      local response = (before == after) and "failed\n" or "success\n"

      pcall(function() conn:write(response) end)
      pcall(function() conn:close() end)
    end)
  end)
end)

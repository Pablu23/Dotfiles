local direction_map = {
  left = "h",
  right = "l",
  up = "k",
  down = "j",
}

local runtime_dir = os.getenv("XDG_RUNTIME_DIR") or "/tmp"

local function sanitize(value)
  return value:gsub("[^%w_.-]", "_")
end

local function get_hyprland_stable_id()
  local handle = io.popen("hyprctl activewindow -j 2>/dev/null")

  if not handle then
    return "unknown"
  end

  local data = handle:read("*a")
  handle:close()

  local ok, json = pcall(vim.json.decode, data)

  if ok and json and json.stableId then
    return tostring(json.stableId)
  end

  return "unknown"
end

local function get_socket_path()
  local pane_id = vim.env.HERDR_PANE_ID

  if pane_id and pane_id ~= "" then
    return string.format(
      "%s/nvim-hypr-nav-pane-%s.sock",
      runtime_dir,
      sanitize(pane_id)
    )
  end

  return string.format(
    "%s/nvim-hypr-nav-%s.sock",
    runtime_dir,
    get_hyprland_stable_id()
  )
end

local socket_path = get_socket_path()
local server = vim.uv.new_pipe(false)

local function reply(connection, response)
  local ok = pcall(function()
    connection:write(response, function()
      pcall(function()
        connection:close()
      end)
    end)
  end)

  if not ok then
    pcall(function()
      connection:close()
    end)
  end
end

-- Normally unnecessary because Herdr sockets contain the process ID, but it
-- also cleans up an ungracefully terminated direct-Neovim instance if the PID
-- happened to be reused.
vim.uv.fs_unlink(socket_path)

server:bind(socket_path)

server:listen(128, function(err)
  if err then
    vim.schedule(function()
      vim.notify("hypr-nav: " .. err, vim.log.levels.ERROR)
    end)
    return
  end

  local connection = vim.uv.new_pipe(false)
  server:accept(connection)

  connection:read_start(function(read_err, data)
    if read_err or not data then
      pcall(function()
        connection:close()
      end)
      return
    end

    local direction = data:match("nav:(%a+)")

    if not direction or not direction_map[direction] then
      reply(connection, "invalid\n")
      return
    end

    vim.schedule(function()
      local before = vim.api.nvim_get_current_win()

      vim.cmd("wincmd " .. direction_map[direction])

      local after = vim.api.nvim_get_current_win()
      local response = before == after and "failed\n" or "success\n"

      reply(connection, response)
    end)
  end)
end)

vim.api.nvim_create_autocmd("VimLeavePre", {
  once = true,
  callback = function()
    pcall(function()
      server:close()
    end)

    vim.uv.fs_unlink(socket_path)
  end,
})

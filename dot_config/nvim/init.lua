local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("lazy").setup("plugins")

vim.o.number = true
vim.o.relativenumber = true

vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
  },
  pattern = {
    [".*%.gohtml"] = "gotmpl",
    [".*%.gotmpl"] = "gotmpl"
  }
})

-- Panes
vim.cmd.set("splitright")
vim.keymap.set("n", "<leader>/", function()
  vim.cmd.vnew()
end, { desc = "Pane split right" })

vim.cmd.set("splitbelow")
vim.keymap.set("n", "<leader>-", function()
  vim.cmd.new()
end, { desc = "Pane split down" })

-- vim.api.nvim_set_keymap('n', '<c-k>', ':wincmd k<CR>', { noremap = true, silent = true, desc = "Move to up windows" });
-- vim.api.nvim_set_keymap('n', '<c-h>', ':wincmd h<CR>', { noremap = true, silent = true, desc = "Move to left windows" });
-- vim.api.nvim_set_keymap('n', '<c-j>', ':wincmd j<CR>', { noremap = true, silent = true, desc = "Move to down windows" });
-- vim.api.nvim_set_keymap('n', '<c-l>', ':wincmd l<CR>', { noremap = true, silent = true, desc = "Move to right windows" });

vim.api.nvim_set_keymap('n', 'gb', ':bnext<CR>', { noremap = true, silent = true, desc = "Go back last buffer" });

vim.api.nvim_set_keymap('t', '<c-[><c-[>', '<C-\\><C-n>', { noremap = true, silent = true, desc = "Escape Terminal" });
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
});


-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>fg', function() builtin.live_grep({ glob_pattern = "!*_templ.go" }) end,
  { desc = "Telescope live grep" })
vim.keymap.set('n', 'gl', builtin.lsp_references, { desc = "Telescope show references" })
vim.keymap.set('n', '<leader>fx', builtin.diagnostics, { desc = "Telescope open diagnostics" })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Telescope open buffers" })

-- Formating
vim.keymap.set("n", "<leader>gf", function()
  require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- Filesystem
vim.keymap.set("n", "<leader>e", ":Oil<CR>", { desc = "Open file explorer: OIL" })

-- Neotest
local neotest = require("neotest")
vim.keymap.set("n", "<leader>ts", function()
  neotest.summary.toggle()
end, { desc = "Neotest open summary" })
vim.keymap.set("n", "<leader>to", neotest.output.open, { desc = "Neotest open output" })
vim.keymap.set("n", "<leader>td", function() neotest.run.run({ suite = false, strategy = "dap" }) end,
  { desc = "Neotest debug closest test" })
vim.keymap.set("n", "<leader>tr", function() neotest.run.run({ suite = false }) end,
  { desc = "Neotest run closest test" })

-- Debugging
local dap = require("dap")
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint,
  { nowait = true, remap = false, desc = "Debug toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { nowait = true, remap = false, desc = "Debug continue" })
vim.keymap.set("n", "<leader>di", dap.step_into, { nowait = true, remap = false, desc = "Debug step into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { nowait = true, remap = false, desc = "Debug step over" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { nowait = true, remap = false, desc = "Debug open repl" })
vim.keymap.set("n", "<leader>dq", function()
  dap.terminate()
  require("dapui").close()
  require("nvim-dap-virtual-text").toggle()
end, { nowait = true, remap = false, desc = "Debug close" })
vim.keymap.set("n", "<leader>dl", dap.list_breakpoints, { nowait = true, remap = false, desc = "Debug list breakpoints" })

local function read_pyproject()
  local results = vim.fs.find("pyproject.toml", { upward = true, stop = vim.loop.os_homedir() })
  local path = results[1]
  if not path then
    return nil
  end

  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end

  return table.concat(lines, "\n")
end

local function get_scripts_from_pyproject()
  local pyproject = read_pyproject()
  if not pyproject then
    return {}
  end

  local scripts = {}

  -- Match [tool.poetry.scripts]
  for script_line in pyproject:gmatch("%[tool%.poetry%.scripts%][^\n]*\n([^%[]*)") do
    for name, module in script_line:gmatch('([%w_%-]+)%s*=%s*"([^"]+)"') do
      scripts[name] = module
    end
  end

  -- Match [project.scripts]
  for script_line in pyproject:gmatch("%[project%.scripts%][^\n]*\n([^%[]*)") do
    for name, module in script_line:gmatch('([%w_%-]+)%s*=%s*"([^"]+)"') do
      scripts[name] = module
    end
  end

  return scripts
end

local function get_python_path()
  local cwd = vim.fn.getcwd()
  if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
    return cwd .. "/venv/bin/python"
  elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
    return cwd .. "/.venv/bin/python"
  else
    return vim.fn.exepath("python")
  end
end

-- Store last used parameters for quick reuse
local last_params = {}

vim.keymap.set("n", "<leader>dps", function()
  local scripts = get_scripts_from_pyproject()

  if vim.tbl_isempty(scripts) then
    vim.notify("No scripts found in pyproject.toml", vim.log.levels.WARN)
    return
  end

  local script_names = vim.tbl_keys(scripts)
  table.sort(script_names)

  local function start_debug(script_name, module, args_str)
    local package = module:match("^([^:]+)")
    
    -- Parse arguments string into table
    local args = {}
    if args_str and args_str ~= "" then
      for arg in args_str:gmatch("%S+") do
        table.insert(args, arg)
      end
    end

    -- Store for quick reuse
    last_params[script_name] = args_str or ""

    vim.notify(
      "Debugging: " .. script_name .. (args_str and (" with args: " .. args_str) or ""),
      vim.log.levels.INFO
    )

    local dap = require("dap")
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Debug: " .. script_name,
        module = package,
        args = args,
        pythonPath = get_python_path(),
        justMyCode = false,
        console = "integratedTerminal",
      },
    }
    dap.continue()
  end

  local function show_param_input(script_name, module)
    -- Show input dialog for parameters
    vim.ui.input({
      prompt = "Arguments for " .. script_name .. ": ",
      default = last_params[script_name] or "",
      completion = "file",
    }, function(args_str)
      if args_str ~= nil then  -- nil = cancelled, "" = empty input is OK
        start_debug(script_name, module, args_str)
      end
    end)
  end

  local function select_script()
    if #script_names == 1 then
      show_param_input(script_names[1], scripts[script_names[1]])
    else
      vim.ui.select(script_names, {
        prompt = "Select script to debug: ",
        format_item = function(item)
          return item .. " → " .. scripts[item]
        end,
      }, function(selected)
        if selected then
          show_param_input(selected, scripts[selected])
        end
      end)
    end
  end

  select_script()
end, { desc = "Debug Python script from pyproject.toml" })
-- Lsp Config
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP rename" })

-- Motions
vim.keymap.set("n", "<C-d>", "<C-d>zz", {})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {})

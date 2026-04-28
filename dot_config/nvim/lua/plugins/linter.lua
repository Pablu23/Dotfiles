return {
  'mfussenegger/nvim-lint',
  config = function()
    local lint = require("lint")
    -- lint.linters_by_ft = {
    --   python = { 'mypy' }
    -- }

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

    local function python_linters()
      local linters = {}
      local pyproject = read_pyproject()

      if pyproject then
        if pyproject:match("%[tool%.ruff%]") then
          table.insert(linters, "ruff")
        end
        if pyproject:match("%[tool%.mypy%]") then
          table.insert(linters, "mypy")
        end
      end

      return linters
    end

    lint.linters_by_ft.python = python_linters()

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint(nil, { ignore_errors = true })
      end,
    })
  end
}

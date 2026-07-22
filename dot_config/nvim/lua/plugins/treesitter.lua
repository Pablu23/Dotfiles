return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.install({ "python", "go", "zig", "markdown", "json", "yaml", "javascript", "typescript", "bash", "python",
      "lua" })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
      callback = function()
        pcall(vim.treesitter.start)
      end
    })
  end
}

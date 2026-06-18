return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.install({ "python", "go", "zig", "markdown", "json", "yaml", "javascript", "typescript", "bash", "python", "lua" })
  end
}

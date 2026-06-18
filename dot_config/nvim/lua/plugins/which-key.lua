return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>d", group = "Debug" },
      { "<leader>f", group = "Telescope" },
      { "<leader>t", group = "Test" },
      { "<leader>c", group = "Code" },
    })
  end
}

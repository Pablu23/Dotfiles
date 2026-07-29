return {
  "lmilojevicc/herdr-splits.nvim",
  cond = vim.env.HERDR_ENV == "1",
  event = "VeryLazy",

  -- Keep the Neovim and Herdr halves on the same commit.
  build = function()
    require("herdr-splits").sync_herdr()
  end,

  opts = {
    auto_sync_herdr = true,

    -- Spatial navigation should stop at the outside edge.
    -- Wrapping would make Ctrl+HJKL less predictable.
    at_edge = "stop",

    -- Neovim split resizing is measured in cells.
    neovim_amount = 3,

    -- Herdr pane resizing is a fraction of the terminal.
    default_amount = 0.03,

    nav_keys = {
      left = "<C-h>",
      down = "<C-j>",
      up = "<C-k>",
      right = "<C-l>",
    },

    resize_keys = {
      left = "<M-h>",
      down = "<M-j>",
      up = "<M-k>",
      right = "<M-l>",
    },
  },

  keys = {
    {
      "<C-h>",
      function()
        require("herdr-splits").move_cursor_left()
      end,
      desc = "Move left",
    },
    {
      "<C-j>",
      function()
        require("herdr-splits").move_cursor_down()
      end,
      desc = "Move down",
    },
    {
      "<C-k>",
      function()
        require("herdr-splits").move_cursor_up()
      end,
      desc = "Move up",
    },
    {
      "<C-l>",
      function()
        require("herdr-splits").move_cursor_right()
      end,
      desc = "Move right",
    },

    {
      "<M-h>",
      function()
        require("herdr-splits").resize_left()
      end,
      desc = "Resize left",
    },
    {
      "<M-j>",
      function()
        require("herdr-splits").resize_down()
      end,
      desc = "Resize down",
    },
    {
      "<M-k>",
      function()
        require("herdr-splits").resize_up()
      end,
      desc = "Resize up",
    },
    {
      "<M-l>",
      function()
        require("herdr-splits").resize_right()
      end,
      desc = "Resize right",
    },
  },
}

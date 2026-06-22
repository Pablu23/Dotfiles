return
{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      transparent_background = false,

      custom_highlights = function(colors)
        return {
          Normal = { bg = colors.base },
          NormalNC = { bg = colors.mantle },

          WinSeparator = { fg = colors.surface1, bg = colors.mantle },

          StatusLine = { fg = colors.text, bg = colors.surface0 },
          StatusLineNC = { fg = colors.overlay0, bg = colors.mantle },

          CursorLine = { bg = colors.surface0 },
        }
      end
    })

    vim.cmd.colorscheme "catppuccin"
  end
}
-- {
--   "nyoom-engineering/oxocarbon.nvim",
--   config = function()
--     vim.opt.background = "dark"
--     vim.cmd.colorscheme "oxocarbon"
--
--     -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--     -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--   end
-- }

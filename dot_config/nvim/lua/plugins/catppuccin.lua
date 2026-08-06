return
{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      transparent_background = true,

      custom_highlights = function(colors)
        return {
          WinSeparator = { fg = colors.surface1 },

          StatusLine = { fg = colors.text, bg = colors.surface0 },
          StatusLineNC = { fg = colors.overlay0 },

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

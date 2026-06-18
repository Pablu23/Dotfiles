return
{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      transparent_background = true,
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

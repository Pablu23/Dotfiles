return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require('tiny-inline-diagnostic').setup({
      preset = "modern",
      transparent_bg = true,

      options = {
        multilines = {
          enabled = true,
          always_show = true,
        }
      }
    })
    vim.diagnostic.config({ virtual_text = false })     -- Disable Neovim's default virtual text diagnostics
  end,
}

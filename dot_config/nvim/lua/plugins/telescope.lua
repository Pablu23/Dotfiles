return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'BurntSushi/ripgrep',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--glob", "!**/vendor/*", "--glob", "!*_templ.go" }
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      })

      telescope.load_extension("ui-select")
      telescope.load_extension("fzf")
    end
  }
}

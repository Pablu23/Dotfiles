return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "enter",
      ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
    appearance = {
      nerd_font_variant = "mono"
    },
    signature = {
      enabled = true
    },
    completion = {
      menu = {
        draw = {
          padding = { 0, 1 }, -- padding only on right side
          components = {
            kind_icon = {
              text = function(ctx) return ' ' .. ctx.kind_icon .. ctx.icon_gap .. ' ' end
            }
          }
        }
      }
    }
  }
}

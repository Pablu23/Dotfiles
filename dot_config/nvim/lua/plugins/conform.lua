return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require("conform")

    conform.setup {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black", lsp_format = "fallback" },
        gotmpl = { "djlint" }
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback"
      }
    }

    conform.formatters.djlint = {
      append_args = { "--max-blank-lines", "5" }
    }
  end
}

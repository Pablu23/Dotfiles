return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.enable({ "lua_ls",
      "basedpyright",
      "gopls",
      "html",
      "yamlls",
      "svelte-language-server",
      "clangd",
      "ansiblels",
      "vtsls",
      "zls",
      "glsl_analyzer",
      "rust_analyzer",
      "templ",
      "tailwindcss",
      "nil_ls"
    })


    -- Testing basedpyright atm, change to jedi idk
    vim.lsp.config("basedpyright", {
      settings = {
        ['basedpyright'] = {
          analysis = {
            typeCheckingMode = "basic",
            inlayHints = {
              variableTypes = true,
              genericTypes = true,
            },
            autoFormatStrings = true,
          }
        }
      }
    })
  end
}

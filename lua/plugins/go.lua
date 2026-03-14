return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod", "gowork", "gotmpl" },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      -- LazyVim's lang.go extra handles LSP (gopls), formatting (conform + goimports), and diagnostics
      lsp_cfg = false,
      lsp_gofumpt = false,
      lsp_on_attach = false,
      lsp_keymaps = false,
      lsp_document_formatting = false,
      diagnostic = false,
    },
  },
}

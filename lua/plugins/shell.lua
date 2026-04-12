return {
  -- Add bash filetype to shfmt (LazyVim covers sh but not bash)
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.bash = { "shfmt" }
      return opts
    end,
  },

  -- Enable fish-lsp (must be installed manually: npm install -g fish-lsp)
  -- nvim-lspconfig ships a complete fish_lsp definition; hook it into LazyVim's normal LSP path.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.fish_lsp = vim.tbl_deep_extend("force", opts.servers.fish_lsp or {}, {
        enabled = vim.fn.executable("fish-lsp") == 1,
        mason = false,
      })
      return opts
    end,
  },
}

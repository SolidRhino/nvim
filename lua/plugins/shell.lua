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
  -- nvim-lspconfig ships a complete fish_lsp definition (cmd, filetypes, root_dir)
  -- Guard against missing binary to avoid noisy errors
  {
    "neovim/nvim-lspconfig",
    init = function()
      if vim.fn.executable("fish-lsp") == 1 then
        vim.lsp.enable("fish_lsp")
      end
    end,
  },
}

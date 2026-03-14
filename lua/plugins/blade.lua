return {
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      -- Detect .blade.php files as blade filetype before treesitter attaches
      vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })
    end,
    opts = function(_, opts)
      -- Register external blade parser before ensure_installed is processed
      -- (get_parser_configs() was removed in nvim-treesitter main; direct table assignment is correct)
      require("nvim-treesitter.parsers").blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "blade" })
      return opts
    end,
  },
}

return {
  -- Laravel workflow helpers
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
    },
    event = "BufEnter composer.json",
    cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    ft = { "php", "blade" },
    keys = {
      {
        "<leader>la",
        function()
          require("laravel").artisan()
        end,
        desc = "Laravel Artisan",
      },
      {
        "<leader>lr",
        function()
          require("laravel").routes()
        end,
        desc = "Laravel Routes",
      },
      {
        "<leader>lm",
        function()
          require("laravel").related()
        end,
        desc = "Laravel Related",
      },
    },
    opts = {
      pickers = {
        provider = "snacks",
      },
    },
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>l", group = "Laravel" },
      },
    },
  },
}

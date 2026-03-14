return {
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
    },
    ft = { "php", "blade" },
    event = "BufEnter composer.json",
    cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
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
}

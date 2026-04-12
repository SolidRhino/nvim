return {
  -- Catppuccin as the main colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      term_colors = true,
      integrations = {
        blink_cmp = { style = "bordered" },
        diffview = true,
        gitsigns = true,
        mini = { enabled = true },
        render_markdown = true,
        snacks = { enabled = true },
        ufo = true,
        which_key = true,
      },
    },
  },

  -- Tell LazyVim which colorscheme to load
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}

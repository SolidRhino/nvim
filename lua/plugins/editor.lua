return {
  -- Better code folding with LSP/treesitter awareness
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open All Folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close All Folds",
      },
    },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = "eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸"
    end,
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
  },

  -- Enhanced git diff and file history UI
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>gD",
        function()
          vim.cmd.DiffviewOpen()
        end,
        desc = "Diffview Open",
      },
      {
        "<leader>gH",
        function()
          vim.cmd.DiffviewFileHistory("%")
        end,
        desc = "File History",
      },
    },
    opts = {},
  },
}

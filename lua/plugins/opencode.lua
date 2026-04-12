return {
  -- OpenCode terminal + prompt workflows
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    keys = {
      {
        "<leader>aa",
        function()
          require("opencode").toggle()
        end,
        mode = { "n", "t" },
        desc = "Toggle",
      },
      {
        "<leader>as",
        function()
          require("opencode").select()
        end,
        mode = { "n", "x" },
        desc = "Select Action",
      },
      {
        "<leader>ai",
        function()
          require("opencode").ask("", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Ask",
      },
      {
        "<leader>aI",
        function()
          require("opencode").ask("@this: ", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Ask with Context",
      },
      {
        "<leader>ab",
        function()
          require("opencode").ask("@buffer: ", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Ask about Buffer",
      },
      {
        "<leader>apd",
        function()
          require("opencode").prompt("diagnostics", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Diagnostics",
      },
      {
        "<leader>ape",
        function()
          require("opencode").prompt("explain", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Explain",
      },
      {
        "<leader>apf",
        function()
          require("opencode").prompt("fix", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Fix",
      },
      {
        "<leader>apo",
        function()
          require("opencode").prompt("optimize", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Optimize",
      },
      {
        "<leader>apr",
        function()
          require("opencode").prompt("review", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Review",
      },
      {
        "<leader>apt",
        function()
          require("opencode").prompt("test", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Test",
      },
      {
        "<leader>ao",
        function()
          return require("opencode").operator("@this ")
        end,
        expr = true,
        mode = { "n", "x" },
        desc = "Add Range to OpenCode",
      },
      {
        "<leader>aO",
        function()
          return require("opencode").operator("@this ") .. "_"
        end,
        expr = true,
        mode = { "n" },
        desc = "Add Line to OpenCode",
      },
    },
    init = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {}

      -- Required for opencode.nvim event-driven buffer reloads.
      vim.o.autoread = true
    end,
  },

  -- Optional snacks integrations for ask/select/terminal UX
  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      opts.input = opts.input or {}
      opts.terminal = opts.terminal or {}

      opts.picker = vim.tbl_deep_extend("force", opts.picker or {}, {
        actions = {
          opencode_send = function(...)
            return require("opencode").snacks_picker_send(...)
          end,
        },
        win = {
          input = {
            keys = {
              ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
            },
          },
        },
      })
    end,
  },

  -- Optional which-key group labels for OpenCode mappings
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", mode = { "n", "x" }, group = "OpenCode" },
        { "<leader>ap", mode = { "n", "x" }, group = "Prompt" },
      },
    },
  },
}

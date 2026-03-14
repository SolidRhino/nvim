# Style and Conventions

## Lua Formatting (stylua.toml)
- Indent: 2 spaces
- Column width: 120

## LazyVim Plugin Spec Merging Rules
- `cmd`, `event`, `ft`, `keys`, `dependencies` → **appended** to defaults
- `opts` → **deep-merged** with defaults (use a function to fully replace)
- All other properties → **override** defaults

## Common Patterns
```lua
-- Disable a plugin
{ "plugin/name", enabled = false }

-- Add options on top of defaults
{ "plugin/name", opts = { my_option = true } }

-- Replace all opts
{ "plugin/name", opts = function() return { my_option = true } end }

-- Disable a keymap
{ "plugin/name", keys = { { "<leader>x", false } } }

-- Lazy-load on filetype + command
{ "plugin/name", ft = { "go" }, cmd = { "GoCmd" }, opts = {} }
```

## Key Conventions
- Each `lua/plugins/*.lua` file returns a list of plugin specs
- Use `init` (not `config`) for setting vim options that must be set before plugin loads
- Use `opts = {}` (not `config = function() require(...).setup({}) end`) when possible
- When adding plugins that overlap with LazyVim extras, explicitly disable conflicting features
  (e.g. go.nvim: `lsp_cfg=false, lsp_on_attach=false, lsp_keymaps=false, lsp_document_formatting=false`)
- LazyVim uses snacks.nvim as picker (not telescope) — use `provider = "snacks"` for plugins that support it
- Keymaps: use Lua function style `function() require("x").fn() end`, not `:cmd<cr>` strings

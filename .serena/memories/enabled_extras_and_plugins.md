# Enabled Extras and Custom Plugins

## LazyVim Extras (lazyvim.json — edit via :LazyExtras)
- **AI**: claudecode, copilot
- **Coding**: mini-surround, yanky
- **Editor**: dial, harpoon2, inc-rename, mini-files, overseer
- **Languages**: ansible, docker, git, go, json, markdown, nix, php, python, rust, sql, svelte, tailwind, typescript, vue, yaml
- **Testing**: test.core
- **UI**: mini-animate
- **Utilities**: chezmoi, dot, gh, mini-hipatterns, vscode

## Custom Plugin Specs (lua/plugins/)

### colorscheme.lua
Catppuccin Mocha as default colorscheme.

### go.lua — ray-x/go.nvim
Adds Go extras: struct tag generation (`:GoAddTag`), `:GoFillStruct`, `:GoIfErr`, `:GoModTidy`, etc.
- `ft = { "go", "gomod", "gowork", "gotmpl" }`
- LSP/formatting disabled to avoid conflicts with `lang.go` extra:
  `lsp_cfg=false, lsp_gofumpt=false, lsp_on_attach=false, lsp_keymaps=false, lsp_document_formatting=false, diagnostic=false`

### laravel.lua — adalessa/laravel.nvim
PHP/Laravel: artisan commands, route navigation, related files.
- Picker: snacks (`pickers = { provider = "snacks" }`)
- `ft = { "php", "blade" }`, `event = "BufEnter composer.json"`
- Keymaps: `<leader>la` artisan, `<leader>lr` routes, `<leader>lm` related

### editor.lua
**nvim-ufo** (`kevinhwang91/nvim-ufo`): treesitter/indent-aware folding
- Sets foldcolumn=1, foldlevel=99, foldenable=true
- fillchars: `foldopen:▾, foldclose:▸, foldsep: ` (space — avoids nested fold gutter bug)
- Keymaps: `zR` open all folds, `zM` close all folds

**diffview.nvim** (`sindrets/diffview.nvim`): enhanced git diff UI
- Keymaps: `<leader>gD` open diff, `<leader>gH` file history

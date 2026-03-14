# Nvim Config Improvements Design

**Date:** 2026-03-14
**Status:** Approved

## Overview

Improve the LazyVim-based Neovim config by: removing unused language extras, adding shell script support (bash + fish), enabling the built-in HTTP client, and adding Blade template syntax highlighting.

Primary workflow: shell scripts, Docker/Docker Compose, PHP/Laravel.

---

## 1. Remove Unused LazyVim Extras

Remove from `lazyvim.json` (via `:LazyExtras`):

- `lang.nix`
- `lang.rust`
- `lang.svelte`
- `lang.ansible`

**Why:** Not part of the primary workflow. Reduces Mason installs and startup overhead.

**Kept intentionally:** `lang.python`, `lang.sql` — used occasionally even if not primary.

---

## 2. Enable `util.rest` Extra

Enable `util.rest` in `lazyvim.json` (via `:LazyExtras`).

Provides `kulala.nvim` — an HTTP client for sending requests from `.http`/`.rest` files. Useful for testing Laravel APIs. LazyVim defaults are sufficient; no custom config needed.

---

## 3. Shell Script Support — `lua/plugins/shell.lua`

### What `util.dot` already provides (already enabled)

The `util.dot` extra (currently in `lazyvim.json`) already sets up:
- **bashls** — configured via lspconfig
- **shellcheck** — installed via Mason
- **Fish treesitter parser** — added conditionally

`shell.lua` must only add what is missing on top of this, without duplicating lspconfig registrations.

### What `shell.lua` adds

**Bash / sh:**
- **Formatter:** `shfmt` — installed via Mason, configured in `conform.nvim` for `sh` and `bash` filetypes:
  ```lua
  formatters_by_ft = { sh = { "shfmt" }, bash = { "shfmt" } }
  ```

**Fish:**
- **LSP:** `fish-lsp` — NOT available in Mason (open issue/PR in mason-lspconfig.nvim as of March 2026). Must be installed manually:
  ```sh
  npm install -g fish-lsp
  ```
  nvim-lspconfig already ships a complete `fish_lsp` definition (cmd, filetypes, root_dir). No `vim.lsp.config(...)` override needed. Enable with:
  ```lua
  vim.lsp.enable("fish_lsp")
  ```
- **Formatter:** `fish_indent` — built into Fish shell, available in PATH. Configured in `conform.nvim`:
  ```lua
  formatters_by_ft = { fish = { "fish_indent" } }
  ```
- **Treesitter:** Fish parser already handled by `util.dot`; no duplication needed.

### Implementation

`lua/plugins/shell.lua` returns three specs:
1. `mason.nvim` with `ensure_installed = { "shfmt" }` (shellcheck already in util.dot)
2. `conform.nvim` with `opts = function(_, opts)` (extending form — must not replace existing formatters set by other extras) adding `sh`, `bash`, `fish` filetypes
3. A bare `init = function() vim.lsp.enable("fish_lsp") end` call — relies entirely on nvim-lspconfig's bundled fish_lsp definition (cmd, filetypes, root_dir already defined there)

---

## 4. Blade Template Syntax — `lua/plugins/blade.lua`

Adds Blade template support for PHP/Laravel using `EmranMR/tree-sitter-blade`.

### Treesitter parser

Register the external parser via nvim-treesitter's parser config mechanism:
```lua
vim.treesitter.language.register("blade", "blade")
```
Parser installed via `ensure_installed = { "blade" }` with a custom `parser_config` pointing to the `tree-sitter-blade` GitHub repo.

### Filetype detection

`.blade.php` files are not automatically detected as `blade` filetype by Neovim. Add:
```lua
vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })
```
This must run before treesitter attaches, so it goes in the plugin's `init` function.

### Query files (highlights + injections)

`tree-sitter-blade` does not bundle Neovim query files. Two query files must be committed to the repo and placed where Neovim's runtime can find them:

- `queries/blade/highlights.scm` — syntax highlighting
- `queries/blade/injections.scm` — PHP/HTML injection inside Blade directives

These are sourced from the `tree-sitter-blade` community repo (`EmranMR/tree-sitter-blade`, `discussions/19`) and committed as-is.

### Implementation

`lua/plugins/blade.lua` returns:
1. `nvim-treesitter` spec with `opts` deep-merge adding `blade` to `ensure_installed`. The custom parser repo is registered via the `TSUpdate` autocmd pattern (nvim-treesitter's `get_parser_configs()` API has been removed):
   ```lua
   vim.api.nvim_create_autocmd("User", {
     pattern = "TSUpdate",
     callback = function()
       require("nvim-treesitter.parsers").blade = {
         install_info = {
           url = "https://github.com/EmranMR/tree-sitter-blade",
           files = { "src/parser.c" },
           branch = "main",
         },
         filetype = "blade",
       }
     end,
   })
   ```
2. `init` function calling `vim.filetype.add` for `.blade.php` pattern
3. Note: requires `php` and `html` treesitter parsers. `lang.php` extra provides `php`; `html` must be confirmed present (LazyVim installs it by default)

---

## 5. Update Serena Memory

Update `suggested_commands` memory to add:
- Manual fish-lsp install: `npm install -g fish-lsp`
- Note that `util.dot` is the source of bashls + shellcheck (so it's not forgotten when debugging)

---

## Files Changed

| File | Change |
|------|--------|
| `lazyvim.json` | Remove 4 extras, add `util.rest` |
| `lazy-lock.json` | Updated after `:Lazy update` |
| `lua/plugins/shell.lua` | New — shfmt formatter + fish-lsp + fish_indent |
| `lua/plugins/blade.lua` | New — Blade treesitter parser + filetype detection |
| `queries/blade/highlights.scm` | New — Blade syntax highlighting queries |
| `queries/blade/injections.scm` | New — Blade PHP/HTML injection queries |
| `.serena/memories/suggested_commands.md` | Add fish-lsp install + util.dot note |

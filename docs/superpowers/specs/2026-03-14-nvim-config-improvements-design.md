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

**Why:** These are not part of the primary workflow. Removing them reduces Mason installs and startup overhead.

---

## 2. Enable `util.rest` Extra

Enable `util.rest` in `lazyvim.json` (via `:LazyExtras`).

Provides `kulala.nvim` — an HTTP client for sending requests from `.http`/`.rest` files directly in Neovim. Useful for testing Laravel APIs.

No custom configuration needed; LazyVim defaults are sufficient.

---

## 3. Shell Script Support — `lua/plugins/shell.lua`

New file covering both bash/sh and fish.

### Bash / sh / zsh

- **LSP:** `bash-language-server` — installed via Mason
- **Linter:** `shellcheck` — installed via Mason, integrated via `nvim-lint` (already provided by LazyVim)
- **Formatter:** `shfmt` — installed via Mason, integrated via `conform.nvim` (already provided by LazyVim)

### Fish

- **LSP:** `fish-lsp` — NOT in Mason; must be installed manually via npm:
  ```sh
  npm install -g fish-lsp
  ```
  Configured via `lspconfig` directly (not mason-lspconfig).
- **Formatter:** `fish_indent` — built into Fish shell, available in PATH via mise shims. Configured via `conform.nvim`.
- **Syntax:** Fish tree-sitter grammar is bundled with nvim-treesitter. Add `"fish"` to `ensure_installed`.

### Implementation

Single plugin spec file `lua/plugins/shell.lua` returning:
1. `mason.nvim` spec with `ensure_installed` for `bash-language-server`, `shellcheck`, `shfmt`
2. `nvim-lspconfig` spec to configure `fish_lsp` via `vim.lsp.enable` / lspconfig setup for `fish` filetype
3. `conform.nvim` spec adding `fish_indent` formatter for `fish` filetype
4. `nvim-treesitter` spec adding `"fish"` to `ensure_installed`

---

## 4. Blade Template Syntax — `lua/plugins/blade.lua`

New file adding Blade template support for PHP/Laravel.

- **Parser:** `tree-sitter-blade` (community grammar, not bundled with nvim-treesitter)
- **Filetype:** `.blade.php` files — Neovim detects these as `blade` filetype via an autocmd or filetype detection rule

### Implementation

Plugin spec using `nvim-treesitter` parser config to register the external `tree-sitter-blade` grammar and associate it with the `blade` filetype. LazyVim's treesitter setup is extended (not replaced) via `opts` deep-merge.

---

## 5. Update Serena Memory

Add `npm install -g fish-lsp` to the suggested commands memory so the manual install step is not forgotten.

---

## Files Changed

| File | Change |
|------|--------|
| `lazyvim.json` | Remove 4 extras, add `util.rest` |
| `lazy-lock.json` | Updated after `:Lazy update` |
| `lua/plugins/shell.lua` | New — bash + fish LSP/lint/format/treesitter |
| `lua/plugins/blade.lua` | New — Blade treesitter grammar |
| `.serena/memories/suggested_commands.md` | Add fish-lsp install note |

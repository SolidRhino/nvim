# Project Overview

Personal Neovim configuration built on [LazyVim](https://www.lazyvim.org) with lazy.nvim as the plugin manager.

## Tech Stack
- **Language**: Lua
- **Framework**: LazyVim (opinionated Neovim config framework)
- **Plugin manager**: lazy.nvim
- **Colorscheme**: Catppuccin Mocha
- **Font** (Neovide): JetBrainsMono Nerd Font h16

## Entry Point
`init.lua` → `lua/config/lazy.lua` (bootstraps lazy.nvim, loads LazyVim + `lua/plugins/`)

## Structure
```
init.lua                  # bootstraps lazy.nvim
lua/config/
  lazy.lua                # plugin manager setup
  options.lua             # vim options (scrolloff, PATH, Neovide settings)
  keymaps.lua             # custom keymaps
  autocmds.lua            # custom autocommands
lua/plugins/              # custom plugin specs (auto-loaded by lazy.nvim)
  colorscheme.lua         # Catppuccin Mocha
  go.lua                  # ray-x/go.nvim (Go extras)
  laravel.lua             # adalessa/laravel.nvim (PHP/Laravel)
  editor.lua              # nvim-ufo (folding) + diffview.nvim
  example.lua             # disabled reference template
lazyvim.json              # enabled LazyVim extras (edit via :LazyExtras)
lazy-lock.json            # plugin lockfile
stylua.toml               # formatter config
```

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built on [LazyVim](https://lazyvim.org) with lazy.nvim as the plugin manager.

## Commands

Format Lua files (uses `stylua.toml`: 2-space indent, 120 column width):
```sh
stylua lua/
```

Check formatting without writing:
```sh
stylua --check lua/
```

## Architecture

### Entry point
`init.lua` bootstraps lazy.nvim, which loads `lua/config/lazy.lua`.

### Configuration files (`lua/config/`)
- `lazy.lua` — plugin manager setup; defines the plugin spec (LazyVim base + `lua/plugins/`)
- `options.lua` — custom vim options (loaded before lazy.nvim startup)
- `keymaps.lua` — custom keymaps (loaded on `VeryLazy` event)
- `autocmds.lua` — custom autocommands (loaded on `VeryLazy` event)

### Plugin overrides (`lua/plugins/`)
Every `.lua` file here is auto-loaded by lazy.nvim. Files return a list of plugin specs that add, disable, or override LazyVim defaults. `example.lua` is disabled via `if true then return {} end` at the top — it's a reference template only.

### LazyVim extras (`lazyvim.json`)
Enabled extras (managed via `:LazyExtras` UI):
- **AI**: copilot
- **Coding**: yanky
- **Editor**: dial, inc-rename
- **Languages**: ansible, docker, git, go, php
- **Testing**: test.core
- **Utilities**: chezmoi, dot, mini-hipatterns

To add/remove extras, use `:LazyExtras` inside Neovim — this updates `lazyvim.json` automatically.

### Plugin lock file
`lazy-lock.json` pins exact plugin commits. Update plugins with `:Lazy update` in Neovim, then commit the updated lock file.

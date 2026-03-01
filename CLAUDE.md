# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built on [LazyVim](https://www.lazyvim.org) with lazy.nvim as the plugin manager. LazyVim docs: https://www.lazyvim.org/

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

**Merging rules** (LazyVim applies these when merging with defaults):
- `cmd`, `event`, `ft`, `keys`, `dependencies` — **appended** to existing values
- `opts` — **deep-merged** with defaults (use a function to replace entirely)
- All other spec properties — **override** the default

**Common patterns:**
```lua
-- Disable a plugin
{ "plugin/name", enabled = false }

-- Add options on top of defaults
{ "plugin/name", opts = { my_option = true } }

-- Replace all opts
{ "plugin/name", opts = function() return { my_option = true } end }

-- Disable a keymap
{ "plugin/name", keys = { { "<leader>x", false } } }
```

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

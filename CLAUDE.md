# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.
For detailed conventions, plugin specs, and workflows, read Serena project memories.

## Overview

Personal Neovim configuration built on [LazyVim](https://www.lazyvim.org) with lazy.nvim as the plugin manager.

## Commands

```sh
~/.local/share/nvim/mason/bin/stylua lua/          # format Lua files
~/.local/share/nvim/mason/bin/stylua --check lua/  # check without writing (2-space indent, 120 col width)
```

## Architecture

- `init.lua` → `lua/config/lazy.lua` (bootstraps lazy.nvim)
- `lua/config/` — options, keymaps, autocmds, lazy setup
- `lua/plugins/` — custom plugin specs (auto-loaded); `example.lua` is a disabled reference
- `lazyvim.json` — enabled LazyVim extras (edit via `:LazyExtras`)
- `lazy-lock.json` — plugin lockfile (commit after `:Lazy update`)

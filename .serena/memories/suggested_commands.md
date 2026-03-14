# Suggested Commands

## Formatting
```sh
# Format all Lua files
~/.local/share/nvim/mason/bin/stylua lua/

# Check formatting without writing
~/.local/share/nvim/mason/bin/stylua --check lua/
```
Note: `stylua` is installed via Mason at `~/.local/share/nvim/mason/bin/stylua` (not in PATH by default).

## In Neovim
- `:Lazy` — plugin manager UI
- `:Lazy update` — update all plugins (then commit `lazy-lock.json`)
- `:LazyExtras` — add/remove LazyVim extras (updates `lazyvim.json`)
- `:GoInstallBinaries` — install go.nvim tools (run after first install)

## Git
```sh
git status
git diff
git add lua/ lazyvim.json lazy-lock.json
git commit -m "..."
```

## Task Completion Checklist
1. Run `stylua --check lua/` to verify formatting
2. If formatting fails, run `stylua lua/` to fix
3. Commit changed files (never include Co-Authored-By lines)

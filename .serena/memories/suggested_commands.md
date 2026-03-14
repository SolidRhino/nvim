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

## Changelog
```sh
# Regenerate CHANGELOG.md manually (CI does this automatically on push)
git-cliff -o CHANGELOG.md
```
Note: `git-cliff` is installed via Cargo. CI auto-updates CHANGELOG.md on every push to main.
Tagging is automatic: weekly (Mondays) or on breaking change commits (`feat!:`, `fix!:`, etc.).

## Task Completion Checklist
1. Run `stylua --check lua/` to verify formatting
2. If formatting fails, run `stylua lua/` to fix
3. Commit changed files (never include Co-Authored-By lines)

## Manual Tool Installs

### fish-lsp (not in Mason as of March 2026)

```sh
npm install -g fish-lsp
```

Required for Fish shell LSP support. Check https://github.com/mason-org/mason-lspconfig.nvim/issues/435 for Mason availability updates.

## Notes

- `util.dot` extra provides: bashls (LSP), shellcheck (Mason), fish treesitter parser
  → Do not duplicate these in custom plugin specs

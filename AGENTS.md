# AGENTS.md

## What this repo actually is
- Personal Neovim config on LazyVim + `lazy.nvim`.
- Entry flow: `init.lua` → `lua/config/lazy.lua` → LazyVim defaults + `lua/plugins/*.lua`.
- Most real changes belong in `lua/plugins/*.lua`; each file returns a list of lazy.nvim specs and is auto-imported.
- `lua/plugins/example.lua` is a disabled reference template, not a live plugin spec.
- `queries/blade/` contains custom Treesitter queries that pair with `lua/plugins/blade.lua`.

## Verification
- There is no repo test suite or typecheck step wired in CI.
- The only verified automated check is:
  - `~/.local/share/nvim/mason/bin/stylua --check lua/`
- To fix formatting:
  - `~/.local/share/nvim/mason/bin/stylua lua/`
- `stylua` is expected at the Mason path above; do not assume it is on `PATH`.

## Repo-specific workflow gotchas
- `lua/config/lazy.lua` sets `defaults.lazy = false`, so custom plugin specs are startup-loaded unless you add `event`, `cmd`, or `ft` yourself.
- `lua/config/options.lua` prepends `~/.local/share/mise/shims` to Neovim's `PATH`; editor-launched tools may resolve differently than shell-launched ones.
- Edit LazyVim extras via `:LazyExtras`; that updates `lazyvim.json`.
- After `:Lazy update`, commit `lazy-lock.json`.
- `CHANGELOG.md` is generated from `cliff.toml` by CI; do not hand-edit it unless you are intentionally regenerating it with `git-cliff -o CHANGELOG.md`.
- Pushes to `main` regenerate `CHANGELOG.md`; breaking conventional commits (`feat!:` / `fix!:` etc.) also trigger date tags.

## Plugin conventions that matter here
- Prefer `opts = {}` / `opts = function(_, opts) ... end` over ad hoc `config = function()` when extending plugin setup.
- Use `init` for settings that must exist before a plugin loads.
- Follow LazyVim extras structure for custom plugins: keep the main plugin spec declarative, put mappings in `keys = {}`, use separate optional specs for integrations like `which-key.nvim` / `snacks.nvim`, and only fall back to `config = function()` for logic that cannot live in `opts`, `init`, or `keys`.
- Inside `keys = {}`, prefer Lua functions over `"<cmd>...<cr>"` strings so mappings stay composable and consistent with LazyVim extras.
- When ordering fields inside a plugin spec, prefer: `dependencies` → lazy-loading triggers (`event` / `cmd` / `ft`) → `keys` → `init` → `opts`.
- This config already relies on LazyVim extras for major language support; avoid duplicating features those extras already own.
  - Example: `lua/plugins/go.lua` disables `go.nvim` LSP/formatting/diagnostics because `lazyvim.plugins.extras.lang.go` owns them.
- This repo uses `snacks` as the picker where supported (for example in `lua/plugins/laravel.lua`).

## Known custom integrations
- Blade support is custom: `lua/plugins/blade.lua` registers `*.blade.php` filetypes and the external `tree-sitter-blade` parser.
- Shell support is split:
  - `lua/plugins/shell.lua` maps `bash` to `shfmt`.
  - `fish_lsp` is enabled only if `fish-lsp` exists on the system.
  - `fish-lsp` is a manual install (`npm install -g fish-lsp`), not a Mason-managed dependency here.

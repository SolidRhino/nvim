# AGENTS.md

## What this repo actually is
- Personal Neovim config on LazyVim + `lazy.nvim`.
- Entry flow: `init.lua` → `lua/config/lazy.lua` → LazyVim defaults + `lua/plugins/*.lua`.
- Most real changes belong in `lua/plugins/*.lua`; each file returns a list of lazy.nvim specs and is auto-imported.
- `queries/blade/` contains custom Treesitter queries that pair with `lua/plugins/blade.lua`.

## Verification
- There is no repo test suite or typecheck step wired in CI.
- Verified automated checks are:
  - `~/.local/share/nvim/mason/bin/stylua --check init.lua lua/`
  - `selene ./init.lua ./lua/`
- To fix formatting:
  - `~/.local/share/nvim/mason/bin/stylua init.lua lua/`
- `stylua` is expected at the Mason path above; do not assume it is on `PATH`.
- `:checkhealth nvim_config` covers the manual integrations in this repo (`opencode`, `fish-lsp`, Blade queries/parser).

## Repo-specific workflow gotchas
- `lua/config/lazy.lua` sets `defaults.lazy = false`, so custom plugin specs are startup-loaded unless you add `event`, `cmd`, or `ft` yourself.
- `lua/config/options.lua` prepends `~/.local/share/mise/shims` to Neovim's `PATH`; editor-launched tools may resolve differently than shell-launched ones.
- Edit LazyVim extras via `:LazyExtras`; that updates `lazyvim.json`.
- After `:Lazy update`, commit `lazy-lock.json`.
- `CHANGELOG.md` is generated from `cliff.toml` by CI; do not hand-edit it unless you are intentionally regenerating it with `git-cliff -o CHANGELOG.md`.
- Pushes to `main` regenerate `CHANGELOG.md`; breaking conventional commits (`feat!:` / `fix!:` etc.) also trigger date tags.

## AI tool split
- The enabled LazyVim AI extras and `opencode.nvim` are intentionally both present.
- Treat them as different lanes:
  - Copilot extras (`ai.copilot-native`, `ai.copilot-chat`, `ai.sidekick`) handle inline completion / next-edit suggestions / Copilot chat.
  - `opencode.nvim` is for OpenCode CLI workflows.
- Do not remove one as "duplicate AI" without checking actual workflow overlap first.
- Namespace split: Copilot-related extras keep `<leader>a`; `opencode.nvim` uses `<leader>o`.
- Before adding more AI mappings, audit the imported extras and avoid assuming `<leader>a` or `<leader>o` is free.

## Plugin conventions that matter here
- Prefer `opts = {}` / `opts = function(_, opts) ... end` over ad hoc `config = function()` when extending plugin setup.
- Use `init` for settings that must exist before a plugin loads.
- Follow LazyVim extras structure for custom plugins: keep the main plugin spec declarative, put mappings in `keys = {}`, use separate optional specs for integrations like `which-key.nvim` / `snacks.nvim`, and only fall back to `config = function()` for logic that cannot live in `opts`, `init`, or `keys`.
- Inside `keys = {}`, prefer Lua functions over `"<cmd>...<cr>"` strings so mappings stay composable and consistent with LazyVim extras.
- When ordering fields inside a plugin spec, prefer: `dependencies` → lazy-loading triggers (`event` / `cmd` / `ft`) → `keys` → `init` → `opts`.
- This config already relies on LazyVim extras for major language support; avoid duplicating features those extras already own.
  - Example: keep shell support additive in `lua/plugins/shell.lua` because `lazyvim.plugins.extras.util.dot` and core LazyVim LSP/formatting already own most of that stack.
- This repo uses `snacks` as the picker where supported (for example in `lua/plugins/laravel.lua`).

## Known custom integrations
- Blade support is custom: `lua/plugins/blade.lua` registers `*.blade.php` filetypes and the external `tree-sitter-blade` parser.
- Shell support is split:
  - `lua/plugins/shell.lua` maps `bash` to `shfmt`.
  - `fish_lsp` is wired through LazyVim's normal `nvim-lspconfig` server setup and is enabled only if `fish-lsp` exists on the system.
  - `fish-lsp` is a manual install (`npm install -g fish-lsp`), not a Mason-managed dependency here.

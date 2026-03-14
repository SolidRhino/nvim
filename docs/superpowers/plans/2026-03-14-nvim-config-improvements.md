# Nvim Config Improvements Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove unused LazyVim extras, add shell script support (bash + fish), enable an HTTP client, and add Blade template syntax highlighting.

**Architecture:** All changes are isolated to `lazyvim.json` (extras toggle), new plugin spec files under `lua/plugins/`, and query files under `queries/blade/`. No existing plugin files are modified. The `util.dot` extra (already enabled) provides bashls + shellcheck + fish treesitter — `shell.lua` only adds what is missing on top of it.

**Tech Stack:** Lua, lazy.nvim, LazyVim, mason.nvim, conform.nvim, nvim-treesitter, nvim-lspconfig (Neovim 0.11+)

> **Note on testing:** This is a Neovim configuration — there is no unit test framework. Each task ends with a manual verification step: open Neovim and confirm the feature works as described.

**Spec:** `docs/superpowers/specs/2026-03-14-nvim-config-improvements-design.md`

---

## Chunk 1: Extras + Memory

### Task 1: Update LazyVim extras

**Files:**
- Modify: `lazyvim.json`

- [ ] **Step 1: Edit `lazyvim.json`**

  Remove the four unused extras and add `util.rest`. Replace the `"extras"` array with:

  ```json
  {
    "extras": [
      "lazyvim.plugins.extras.ai.claudecode",
      "lazyvim.plugins.extras.ai.copilot",
      "lazyvim.plugins.extras.coding.mini-surround",
      "lazyvim.plugins.extras.coding.yanky",
      "lazyvim.plugins.extras.editor.dial",
      "lazyvim.plugins.extras.editor.harpoon2",
      "lazyvim.plugins.extras.editor.inc-rename",
      "lazyvim.plugins.extras.editor.mini-files",
      "lazyvim.plugins.extras.editor.overseer",
      "lazyvim.plugins.extras.lang.docker",
      "lazyvim.plugins.extras.lang.git",
      "lazyvim.plugins.extras.lang.go",
      "lazyvim.plugins.extras.lang.json",
      "lazyvim.plugins.extras.lang.markdown",
      "lazyvim.plugins.extras.lang.php",
      "lazyvim.plugins.extras.lang.python",
      "lazyvim.plugins.extras.lang.sql",
      "lazyvim.plugins.extras.lang.tailwind",
      "lazyvim.plugins.extras.lang.typescript",
      "lazyvim.plugins.extras.lang.vue",
      "lazyvim.plugins.extras.lang.yaml",
      "lazyvim.plugins.extras.test.core",
      "lazyvim.plugins.extras.ui.mini-animate",
      "lazyvim.plugins.extras.util.chezmoi",
      "lazyvim.plugins.extras.util.dot",
      "lazyvim.plugins.extras.util.gh",
      "lazyvim.plugins.extras.util.mini-hipatterns",
      "lazyvim.plugins.extras.util.rest",
      "lazyvim.plugins.extras.vscode"
    ],
    "install_version": 8,
    "news": {
      "NEWS.md": "11866"
    },
    "version": 8
  }
  ```

  Removed: `lang.nix`, `lang.rust`, `lang.svelte`, `lang.ansible`
  Added: `util.rest`

- [ ] **Step 2: Verify in Neovim**

  Open Neovim and run `:LazyExtras`. Confirm:
  - `util.rest` shows as enabled
  - `lang.nix`, `lang.rust`, `lang.svelte`, `lang.ansible` show as disabled
  - No startup errors

  Then run `:Lazy sync` to remove unneeded plugins and install kulala.nvim.

- [ ] **Step 3: Update lazy-lock.json**

  After `:Lazy sync` completes, `lazy-lock.json` will be updated. Stage it.

- [ ] **Step 4: Commit**

  ```bash
  git add lazyvim.json lazy-lock.json
  git commit -m "feat: enable util.rest, remove unused language extras"
  ```

---

### Task 2: Update Serena memory

**Files:**
- Modify: `.serena/memories/suggested_commands.md`

- [ ] **Step 1: Update the memory file**

  In `.serena/memories/suggested_commands.md`, add a new section after the existing content:

  ```markdown
  ## Manual Tool Installs

  ### fish-lsp (not in Mason as of March 2026)
  ```sh
  npm install -g fish-lsp
  ```
  Required for Fish shell LSP support. Check https://github.com/mason-org/mason-lspconfig.nvim/issues/435
  for Mason availability updates.

  ## Notes
  - `util.dot` extra provides: bashls (LSP), shellcheck (Mason), fish treesitter parser
    → Do not duplicate these in custom plugin specs
  ```

- [ ] **Step 2: Commit**

  ```bash
  git add .serena/memories/suggested_commands.md
  git commit -m "chore: update Serena memory with fish-lsp install and util.dot notes"
  ```

---

## Chunk 2: Shell Support

### Task 3: Add shell script support

**Files:**
- Create: `lua/plugins/shell.lua`

`util.dot` already handles: bashls LSP, shellcheck linter, fish treesitter.
This file adds only: `shfmt` formatter (bash/sh), `fish-lsp`, `fish_indent` formatter (fish).

**Prerequisite:** `fish-lsp` must be installed before Neovim can attach it:
```sh
npm install -g fish-lsp
```

- [ ] **Step 1: Create `lua/plugins/shell.lua`**

  > Note: LazyVim already ships `sh = { "shfmt" }` and `fish = { "fish_indent" }` in `formatters_by_ft`,
  > and installs `shfmt` via Mason. This file only adds what is genuinely missing.

  ```lua
  return {
    -- Add bash filetype to shfmt (LazyVim covers sh but not bash)
    {
      "stevearc/conform.nvim",
      opts = function(_, opts)
        opts.formatters_by_ft = opts.formatters_by_ft or {}
        opts.formatters_by_ft.bash = { "shfmt" }
        return opts
      end,
    },

    -- Enable fish-lsp (must be installed manually: npm install -g fish-lsp)
    -- nvim-lspconfig ships a complete fish_lsp definition (cmd, filetypes, root_dir)
    -- Guard against missing binary to avoid noisy errors
    {
      "neovim/nvim-lspconfig",
      init = function()
        if vim.fn.executable("fish-lsp") == 1 then
          vim.lsp.enable("fish_lsp")
        end
      end,
    },
  }
  ```

- [ ] **Step 2: Format**

  ```sh
  ~/.local/share/nvim/mason/bin/stylua --check lua/plugins/shell.lua
  ```

  If it fails:
  ```sh
  ~/.local/share/nvim/mason/bin/stylua lua/plugins/shell.lua
  ```

- [ ] **Step 3: Verify bash formatting**

  - Open a `.bash` or `bash`-filetype file in Neovim
  - Run `:ConformInfo` — confirm `shfmt` is listed for `bash` filetype
  - Save the file — confirm it formats without error

- [ ] **Step 4: Verify fish LSP (only if fish-lsp is installed)**

  If `fish-lsp` is installed (`npm install -g fish-lsp`):
  - Open a `.fish` file in Neovim
  - Run `:LspInfo` — confirm `fish_lsp` is attached
  - Hover over a built-in function — confirm documentation appears

  If not yet installed: confirm no error is thrown when opening a fish file.

- [ ] **Step 5: Verify fish formatting**

  - With a `.fish` file open, run `:ConformInfo` — confirm `fish_indent` is listed (provided by LazyVim core)
  - Save — confirm it formats without error

- [ ] **Step 6: Commit**

  ```bash
  git add lua/plugins/shell.lua
  git commit -m "feat: add shell script support (shfmt, fish-lsp, fish_indent)"
  ```

---

## Chunk 3: Blade Support

### Task 4: Add Blade template syntax highlighting

**Files:**
- Create: `lua/plugins/blade.lua`
- Create: `queries/blade/highlights.scm`
- Create: `queries/blade/injections.scm`

**Prerequisites:** `lang.php` extra (already enabled) provides the `php` treesitter parser. LazyVim installs `html` parser by default.

- [ ] **Step 1: Create `queries/blade/highlights.scm`**

  ```scheme
  ; inherits: html

  [
    (directive)
    (directive_start)
    (directive_end)
  ] @tag

  [
    (php_tag)
    (php_end_tag)
    "{{"
    "}}"
    "{!!"
    "!!}"
    "("
    ")"
  ] @punctuation.bracket
  ```

- [ ] **Step 2: Create `queries/blade/injections.scm`**

  ```scheme
  ; inherits: html

  ((php_only) @injection.content
    (#set! injection.language "php_only"))

  ((parameter) @injection.content
      (#set! injection.include-children)
      (#set! injection.language "php_only"))

  ((text) @injection.content
      (#has-ancestor? @injection.content "envoy")
      (#set! injection.combined)
      (#set! injection.language bash))

  ; Livewire attributes
  (attribute
    (attribute_name) @_attr
      (#any-of? @_attr "wire:model"
        "wire:click"
        "wire:stream"
        "wire:text"
        "wire:show")
    (quoted_attribute_value
      (attribute_value) @injection.content)
    (#set! injection.language "javascript"))

  ; AlpineJS attributes
  (attribute
    (attribute_name) @_attr
      (#match? @_attr "^x-[a-z]+")
      (#not-any-of? @_attr "x-teleport" "x-ref" "x-transition")
    (quoted_attribute_value
      (attribute_value) @injection.content)
    (#set! injection.language "javascript"))

  (attribute
    (attribute_name) @_attr
      (#match? @_attr "^[:@][a-z]+")
    (quoted_attribute_value
      (attribute_value) @injection.content)
    (#set! injection.language "javascript"))

  ; Blade escaped JS attributes
  (element
    (_
      (tag_name) @_tag
        (#match? @_tag "^x-[a-z]+")
    (attribute
      (attribute_name) @_attr
        (#match? @_attr "^::[a-z]+")
      (quoted_attribute_value
        (attribute_value) @injection.content)
      (#set! injection.language "javascript"))))

  ; Blade PHP attributes
  (element
    (_
      (tag_name) @_tag
        (#match? @_tag "^x-[a-z]+")
      (attribute
        (attribute_name) @_attr
          (#match? @_attr "^:[a-z]+")
        (quoted_attribute_value
          (attribute_value) @injection.content)
        (#set! injection.language "php_only"))))
  ```

- [ ] **Step 3: Create `lua/plugins/blade.lua`**

  ```lua
  return {
    {
      "nvim-treesitter/nvim-treesitter",
      init = function()
        -- Detect .blade.php files as blade filetype before treesitter attaches
        vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })
      end,
      opts = function(_, opts)
        -- Register external blade parser before ensure_installed is processed
        -- (get_parser_configs() was removed in nvim-treesitter main; direct table assignment is correct)
        require("nvim-treesitter.parsers").blade = {
          install_info = {
            url = "https://github.com/EmranMR/tree-sitter-blade",
            files = { "src/parser.c" },
            branch = "main",
          },
          filetype = "blade",
        }
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "blade" })
        return opts
      end,
    },
  }
  ```

- [ ] **Step 4: Format**

  ```sh
  ~/.local/share/nvim/mason/bin/stylua --check lua/plugins/blade.lua
  ```

  If it fails:
  ```sh
  ~/.local/share/nvim/mason/bin/stylua lua/plugins/blade.lua
  ```

- [ ] **Step 5: Install the blade parser**

  Open Neovim and run:
  ```
  :TSInstall blade
  ```

  Wait for the install to complete. If it errors, check `:TSInstallInfo` for the blade parser status.

- [ ] **Step 6: Verify Blade highlighting**

  - Open any `.blade.php` file in a Laravel project
  - Run `:set filetype?` — should return `filetype=blade`
  - Run `:TSBufInfo` — confirm `blade` parser is active
  - Confirm Blade directives (`@if`, `@foreach`, `{{ }}`) are highlighted differently from plain HTML

- [ ] **Step 7: Commit**

  ```bash
  git add lua/plugins/blade.lua queries/
  git commit -m "feat: add Blade template treesitter support"
  ```

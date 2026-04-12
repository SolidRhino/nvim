local M = {}

local uv = vim.uv or vim.loop
local config_root = vim.fn.stdpath("config")

local function executable(bin)
  return vim.fn.executable(bin) == 1
end

local function exists(path)
  return uv.fs_stat(path) ~= nil
end

local function config_file(path)
  return string.format("%s/%s", config_root, path)
end

local function report_binary(bin, ok_msg, warn_msg, advice)
  if executable(bin) then
    vim.health.ok(ok_msg)
  else
    vim.health.warn(warn_msg, advice)
  end
end

M.check = function()
  vim.health.start("nvim_config manual integrations")

  report_binary(
    "opencode",
    "OpenCode CLI executable found in PATH",
    "OpenCode CLI executable not found in PATH",
    "Install the OpenCode CLI and ensure `opencode` resolves in your shell before using `opencode.nvim`."
  )

  report_binary(
    "fish-lsp",
    "fish-lsp executable found in PATH",
    "fish-lsp executable not found in PATH",
    "Install it with `npm install -g fish-lsp` if you want Fish LSP support in Neovim."
  )

  if exists(config_file("queries/blade/highlights.scm")) and exists(config_file("queries/blade/injections.scm")) then
    vim.health.ok("Blade Treesitter query files are present")
  else
    vim.health.error(
      "Blade Treesitter query files are missing",
      "Ensure `queries/blade/highlights.scm` and `queries/blade/injections.scm` are committed."
    )
  end

  if #vim.api.nvim_get_runtime_file("parser/blade.*", true) > 0 then
    vim.health.ok("Blade Treesitter parser is installed")
  else
    vim.health.warn(
      "Blade Treesitter parser is not installed",
      "Run `:TSInstall blade` in Neovim after first setup or when the parser is missing."
    )
  end
end

return M

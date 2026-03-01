-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.scrolloff = 8

-- Make mise-managed tools available to Neovim (LSPs, formatters, linters, etc.)
-- https://mise.jdx.dev/ide-integration.html#neovim
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

-- Neovide settings
if vim.g.neovide then
  vim.g.neovide_fullscreen = true
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_padding_top = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_left = 8
  vim.g.neovide_padding_right = 8
  vim.opt.guifont = "JetBrainsMono Nerd Font:h16"
end

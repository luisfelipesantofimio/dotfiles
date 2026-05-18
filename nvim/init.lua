-- Minimal IDE-like Neovim config (targets Neovim 0.12)
-- Uses vim.pack (built-in package manager), vim.lsp.config and native treesitter.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.plugins")

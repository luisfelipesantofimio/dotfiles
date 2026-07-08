-- Plugin bootstrap via vim.pack (Neovim 0.12+).
-- vim.pack.add() is synchronous: it clones missing plugins and packadds them
-- before returning, so subsequent require() calls Just Work.

vim.pack.add({
  -- Theme
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },

  -- Core libs
  { src = "https://github.com/nvim-lua/plenary.nvim" },

  -- Treesitter parser installer + queries (main branch, works with native vim.treesitter)
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

  -- UX / motion / icons (all from mini.nvim)
  { src = "https://github.com/echasnovski/mini.nvim" },

  -- Statusline
  { src = "https://github.com/nvim-lualine/lualine.nvim" },

  -- Symbol outline / lateral panel
  { src = "https://github.com/stevearc/aerial.nvim" },

  -- Keymap discoverability
  { src = "https://github.com/folke/which-key.nvim" },

  -- Fuzzy finder
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },

  -- File explorer
  { src = "https://github.com/nvim-tree/nvim-tree.lua" },

  -- Git signs in the gutter
  { src = "https://github.com/lewis6991/gitsigns.nvim" },

  -- Terminals
  { src = "https://github.com/akinsho/toggleterm.nvim" },

  -- Completion (prebuilt binaries fetched automatically when on a release tag)
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },

  -- Flutter / Dart tooling (manages dartls itself)
  { src = "https://github.com/nvim-flutter/flutter-tools.nvim" },

  { src = 'https://github.com/saghen/blink.lib' },

  { src = 'https://github.com/mistweaverco/kulala.nvim' }
})

-- Build native bits after install or update.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local data = ev.data
    if not (data and data.spec) or data.kind == "delete" then return end

    if data.spec.name == "telescope-fzf-native.nvim" then
      vim.notify("Building telescope-fzf-native…", vim.log.levels.INFO)
      vim.system({ "make" }, { cwd = data.path }):wait()
      return
    end

  end,
})

-- Plugin configs (load order matters: theme, then mini, then everything else).
require("plugins.colorscheme")
require("plugins.treesitter")
require("plugins.mini")
require("plugins.statusline")
require("plugins.whichkey")
require("plugins.telescope")
require("plugins.tree")
require("plugins.git")
require("plugins.terminal")
require("plugins.completion")
require("plugins.lsp")
require("plugins.aerial")
require("plugins.flutter")
require("plugins.sessions")

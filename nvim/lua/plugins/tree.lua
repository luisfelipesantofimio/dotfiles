-- Disable netrw — nvim-tree replaces it.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  view = {
    width = 32,
    side = "left",
    signcolumn = "yes",
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    indent_markers = { enable = true },
    icons = {
      git_placement = "after",
      show = { file = true, folder = true, folder_arrow = true, git = true },
    },
  },
  filters = {
    dotfiles = false,
    git_ignored = false,
    custom = { "^\\.git$" },
  },
  git = { enable = true, ignore = false },
  diagnostics = { enable = true, show_on_dirs = true },
  modified = { enable = true },
  update_focused_file = { enable = true, update_root = false },
  actions = {
    open_file = {
      quit_on_open = false,
      window_picker = { enable = false },
    },
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    -- Keep all default explorer keymaps…
    api.config.mappings.default_on_attach(bufnr)
    -- …then override `s` / `S` for split-open.
    -- nowait is OFF here on purpose: with nowait, pressing <leader> (space)
    -- followed by S inside the tree fires this map immediately and breaks
    -- the <leader>S* session keys.
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set("n", "s", api.node.open.vertical,
      vim.tbl_extend("force", opts, { desc = "Open: vertical split" }))
    vim.keymap.set("n", "S", api.node.open.horizontal,
      vim.tbl_extend("force", opts, { desc = "Open: horizontal split" }))
  end,
})

local api = require("nvim-tree.api")
local map = vim.keymap.set

-- <leader>e — toggle the explorer.
map("n", "<leader>e", function() api.tree.toggle({ find_file = true }) end, { desc = "Explorer toggle" })

-- <leader>o — switch focus between editor and explorer (open if needed).
map("n", "<leader>o", function()
  if vim.bo.filetype == "NvimTree" then
    vim.cmd("wincmd p")
  elseif api.tree.is_visible() then
    api.tree.focus()
  else
    api.tree.open({ find_file = true, focus = true })
  end
end, { desc = "Focus explorer / editor" })

-- Quit Neovim entirely when the tree is the last window — but only after the
-- user has actually opened a real buffer in this session. This avoids the
-- startup foot-gun where `nvim .` (or any path that brings up the tree as the
-- only window) would otherwise trip the autocmd before the user typed anything.
local opened_real_buffer = false

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("nvim_tree_track_real_buf", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].buftype == "" and vim.bo[args.buf].filetype ~= "NvimTree" then
      opened_real_buffer = true
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("nvim_tree_last_window", { clear = true }),
  nested = true,
  callback = function()
    if not opened_real_buffer then return end
    if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == "NvimTree" then
      vim.cmd("quit")
    end
  end,
})

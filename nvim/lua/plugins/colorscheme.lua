require("gruvbox").setup({
  terminal_colors = true,
  contrast = "medium",
  italic = {
    strings = false,
    operators = false,
    comments = true,
    folds = true,
  },
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  bold = true,
  dim_inactive = false,
  transparent_mode = false,
})

vim.cmd.colorscheme("gruvbox")

-- Vivid diff highlights so telescope git previews, :diffsplit, fugitive
-- and gitsigns all use add=green / remove=red / change=yellow.
-- Two problems with the defaults:
--   1. gruvbox.nvim leaves Diff{Add,Delete,Change} undefined, so they're empty.
--   2. Vim's syntax/diff.vim links diffAdded *and* diffRemoved both to `Special`.
-- Fix both: define the Diff* base groups, then point diff* (filetype) at them.
local diff_hls = {
  DiffAdd    = { fg = "#b8bb26", bg = "#32361a" },
  DiffDelete = { fg = "#fb4934", bg = "#3c1f1e" },
  DiffChange = { fg = "#fabd2f", bg = "#3c3328" },
  DiffText   = { fg = "#fe8019", bg = "#3c1f1e", bold = true },
}
local diff_ft_links = {
  diffAdded     = "DiffAdd",
  diffRemoved   = "DiffDelete",
  diffChanged   = "DiffChange",
  diffOldFile   = "DiffDelete",
  diffNewFile   = "DiffAdd",
  diffFile      = "Title",
  diffLine      = "Function",
  diffIndexLine = "Identifier",
  diffSubname   = "Comment",
}
local function apply_overrides()
  for group, spec in pairs(diff_hls) do
    vim.api.nvim_set_hl(0, group, spec)
  end
  for group, target in pairs(diff_ft_links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end
  -- Drop the horizontal bar across the cursor line — CursorLineNr still
  -- highlights the active line number so the cursor is easy to find.
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
end
apply_overrides()
-- Re-apply if the colorscheme is reloaded.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("hl_overrides", { clear = true }),
  callback = apply_overrides,
})

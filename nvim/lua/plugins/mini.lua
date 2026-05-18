-- mini.nvim modules — one icon source, plus the usual editing niceties.

require("mini.icons").setup()
-- Make every plugin that asks for nvim-web-devicons resolve to mini.icons.
MiniIcons.mock_nvim_web_devicons()

require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.comment").setup()
-- <leader>/ toggles comments. Uses remap=true so it dispatches to mini.comment's
-- own gcc/gc mappings (which are themselves user-defined).
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("x", "<leader>/", "gc",  { remap = true, desc = "Toggle comment" })
require("mini.ai").setup()
require("mini.bufremove").setup()
require("mini.trailspace").setup()

require("mini.indentscope").setup({
  symbol = "│",
  options = { try_as_border = true },
  draw = { animation = require("mini.indentscope").gen_animation.none() },
})

require("mini.notify").setup()
vim.notify = require("mini.notify").make_notify()

-- Disable indentscope in noisy filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help", "alpha", "dashboard", "neo-tree", "NvimTree",
    "Trouble", "trouble", "notify", "toggleterm", "lspinfo",
  },
  callback = function() vim.b.miniindentscope_disable = true end,
})

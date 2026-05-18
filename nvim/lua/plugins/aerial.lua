require("aerial").setup({
  backends = { "lsp", "treesitter", "markdown", "man" },
  layout = {
    default_direction = "right",
    placement = "edge",
    min_width = 30,
    max_width = { 40, 0.3 },
    preserve_equality = false,
  },
  attach_mode = "global",      -- one outline shared across windows
  close_automatic_events = {}, -- never auto-close on its own
  filter_kind = false,         -- show all symbol kinds (variables, fields, etc.)
  highlight_on_hover = true,
  show_guides = true,
  autojump = false,            -- press <CR> to jump; cursor moves don't teleport
  guides = {
    mid_item   = "├ ",
    last_item  = "└ ",
    nested_top = "│ ",
    whitespace = "  ",
  },
  on_attach = function(bufnr)
    vim.keymap.set("n", "{", "<cmd>AerialPrev<cr>", { buffer = bufnr, desc = "Prev symbol" })
    vim.keymap.set("n", "}", "<cmd>AerialNext<cr>", { buffer = bufnr, desc = "Next symbol" })
  end,
  lsp = {
    diagnostics_trigger_update = true,
    update_when_errors = true,
  },
})

local map = vim.keymap.set
map("n", "<leader>lo", "<cmd>AerialToggle!<cr>",   { desc = "Toggle outline (aerial)" })
map("n", "<leader>lN", "<cmd>AerialNavToggle<cr>", { desc = "Symbol navigator" })

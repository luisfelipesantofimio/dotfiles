require("treesitter-context").setup({
  max_lines = 4,
  min_window_height = 10,
  multiline_threshold = 1,
  mode = "cursor",
})

vim.keymap.set("n", "<leader>lx", "<cmd>TSContext toggle<cr>", { desc = "Toggle sticky context" })

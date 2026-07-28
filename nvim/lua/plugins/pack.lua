-- vim.pack management keymaps.

vim.keymap.set("n", "<leader>Pu", function() vim.pack.update() end, { desc = "Update plugins" })
vim.keymap.set("n", "<leader>PU", function() vim.pack.update(nil, { force = true }) end, { desc = "Update plugins (no confirm)" })

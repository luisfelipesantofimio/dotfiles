vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    if next(vim.lsp.get_clients({ bufnr = 0, name = "elixirls" })) then
      vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
    end
  end,
})

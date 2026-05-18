vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true
vim.bo.commentstring = "// %s"

-- Format on save when clangd attached.
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    if next(vim.lsp.get_clients({ bufnr = 0, name = "clangd" })) then
      vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
    end
  end,
})

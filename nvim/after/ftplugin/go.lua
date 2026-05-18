vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = false -- Go uses tabs.

-- Organize imports + format on save (gopls).
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    local clients = vim.lsp.get_clients({ bufnr = 0, name = "gopls" })
    if not next(clients) then return end

    local params = vim.lsp.util.make_range_params(0, "utf-8")
    params.context = { only = { "source.organizeImports" }, diagnostics = {} }
    local results = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1500) or {}
    for _, res in pairs(results) do
      for _, action in ipairs(res.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
        end
      end
    end

    vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
  end,
})

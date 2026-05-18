-- Diagnostic UI.
vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 2 },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = " ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
})

-- Globals — useful even when no server is attached (helps debug "why didn't it attach?").
vim.keymap.set("n", "<leader>lI", "<cmd>checkhealth vim.lsp<cr>",                      { desc = "LSP info (checkhealth)" })
vim.keymap.set("n", "<leader>lR", "<cmd>LspRestart<cr>",                               { desc = "LSP restart" })
vim.keymap.set("n", "<leader>lL", function() vim.cmd("edit " .. vim.lsp.log.get_filename()) end, { desc = "Open LSP log" })

-- LSP keymaps and per-buffer features attach via LspAttach.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local function bmap(keys, fn, desc, mode)
      vim.keymap.set(mode or "n", keys, fn, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    -- Bounded float opts so hover/signature don't sprawl across the screen.
    local float_opts = { border = "rounded", max_width = 80, max_height = 25, wrap = true }
    local function hover()     vim.lsp.buf.hover(float_opts)          end
    local function signature() vim.lsp.buf.signature_help(float_opts) end

    -- Navigation (vim conventions on `g`)
    bmap("gd", vim.lsp.buf.definition,      "Goto definition")
    bmap("gD", vim.lsp.buf.declaration,     "Goto declaration")
    bmap("gr", vim.lsp.buf.references,      "References")
    bmap("gi", vim.lsp.buf.implementation,  "Goto implementation")
    bmap("gy", vim.lsp.buf.type_definition, "Goto type definition")
    bmap("K",  hover,                       "Hover")

    -- Code actions (under `<leader>c`)
    bmap("<leader>cr", vim.lsp.buf.rename,                                      "Rename")
    bmap("<leader>ca", vim.lsp.buf.code_action,                                 "Code action", { "n", "v" })
    bmap("<leader>cf", function() vim.lsp.buf.format({ async = true }) end,     "Format")

    -- Full LSP menu under `<leader>l` — duplicates of the above for discoverability,
    -- plus extras (workspace folders, call hierarchy, telescope-backed symbol pickers).
    bmap("<leader>lh", hover,                                                   "Hover")
    bmap("<leader>ls", signature,                                               "Signature help")
    bmap("<leader>ld", vim.lsp.buf.definition,                                  "Definition")
    bmap("<leader>lD", vim.lsp.buf.declaration,                                 "Declaration")
    bmap("<leader>lr", vim.lsp.buf.references,                                  "References")
    bmap("<leader>lm", vim.lsp.buf.implementation,                              "Implementation")
    bmap("<leader>lt", vim.lsp.buf.type_definition,                             "Type definition")
    bmap("<leader>la", vim.lsp.buf.code_action,                                 "Code action", { "n", "v" })
    bmap("<leader>ln", vim.lsp.buf.rename,                                      "Rename")
    bmap("<leader>lf", function() vim.lsp.buf.format({ async = true }) end,     "Format")
    -- <leader>lo is owned by aerial.nvim (lateral outline panel).
    bmap("<leader>lO", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",      "Workspace symbols")

    -- Workspace folders (sub-group `<leader>lw*`)
    bmap("<leader>lwa", vim.lsp.buf.add_workspace_folder,                       "Add workspace folder")
    bmap("<leader>lwr", vim.lsp.buf.remove_workspace_folder,                    "Remove workspace folder")
    bmap("<leader>lwl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List workspace folders")

    -- Call hierarchy (sub-group `<leader>lc*`)
    bmap("<leader>lci", vim.lsp.buf.incoming_calls,                             "Incoming calls")
    bmap("<leader>lco", vim.lsp.buf.outgoing_calls,                             "Outgoing calls")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then return end

    -- Inlay hints (toggle + initial enable).
    if client:supports_method("textDocument/inlayHint") and vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      bmap("<leader>li", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, "Toggle inlay hints")
    end

    -- Code lens (run + manual refresh). Neovim's LSP client auto-refreshes
    -- on document changes via workspace/codeLens/refresh, so no autocmd here.
    if client:supports_method("textDocument/codeLens") then
      bmap("<leader>ll", vim.lsp.codelens.run, "Run code lens")
      bmap("<leader>lT", function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end, "Refresh code lens")
    end

    -- Document highlight (CursorHold).
    if client:supports_method("textDocument/documentHighlight") then
      local hl_group = vim.api.nvim_create_augroup("lsp_doc_highlight_" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = hl_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = hl_group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- Capabilities from blink.cmp (so server advertises what blink supports).
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, "blink.cmp")
if ok then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

-- Apply capabilities globally and enable each server.
-- flutter-tools manages dartls itself — don't list it here.
vim.lsp.config("*", { capabilities = capabilities })

local servers = {
  "lua_ls", "clangd", "gopls",
  "rust_analyzer", "zls", "ols",
  "ts_ls", "html", "css", "fortls", "bashls", "fish_lsp",
  "lemminx", "jsonls", "yamlls", "marksman",
  "pyright", "taplo",
  "elixirls", "erlang_ls",
  "astro", "asm",
}
for _, name in ipairs(servers) do
  local server_ok, cfg = pcall(require, "lsp." .. name)
  if server_ok then
    vim.lsp.config(name, cfg)
  end
end

vim.lsp.enable(servers)

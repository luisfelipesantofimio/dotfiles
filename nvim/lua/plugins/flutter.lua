require("flutter-tools").setup({
  ui = { border = "rounded", notification_style = "native" },
  decorations = {
    statusline = { app_version = false, device = true, project_config = false },
  },
  widget_guides = { enabled = true },
  closing_tags = { enabled = true, highlight = "Comment", prefix = "// " },
  dev_log = { enabled = true, open_cmd = "tabedit" },
  dev_tools = { autostart = false, auto_open_browser = false },
  outline = { open_cmd = "30vnew" },
  debugger = { enabled = false },
  lsp = {
    document = {
      color = { enabled = true, background = false, foreground = false, virtual_text = true },
    },
    on_attach = function(_, _) end, -- LspAttach handles the rest.
    capabilities = (function()
      local ok, blink = pcall(require, "blink.cmp")
      if ok then return blink.get_lsp_capabilities() end
      return vim.lsp.protocol.make_client_capabilities()
    end)(),
    settings = {
      showTodos = true,
      completeFunctionCalls = true,
      analysisExcludedFolders = { ".dart_tool", "build", ".pub-cache" },
      renameFilesWithClasses = "prompt",
      enableSnippets = true,
      updateImportsOnRename = true,
    },
  },
})

local map = vim.keymap.set
map("n", "<leader>Fr", "<cmd>FlutterRun<cr>",            { desc = "Run" })
map("n", "<leader>FR", "<cmd>FlutterRestart<cr>",        { desc = "Restart" })
map("n", "<leader>Fq", "<cmd>FlutterQuit<cr>",           { desc = "Quit" })
map("n", "<leader>Fd", "<cmd>FlutterDevices<cr>",        { desc = "Devices" })
map("n", "<leader>Fe", "<cmd>FlutterEmulators<cr>",      { desc = "Emulators" })
map("n", "<leader>Fl", "<cmd>FlutterLogClear<cr>",       { desc = "Log clear" })
map("n", "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>",  { desc = "Outline" })
map("n", "<leader>Fp", "<cmd>FlutterPubGet<cr>",         { desc = "Pub get" })
map("n", "<leader>Fu", "<cmd>FlutterPubUpgrade<cr>",     { desc = "Pub upgrade" })
map("n", "<leader>Fv", "<cmd>FlutterDevTools<cr>",       { desc = "DevTools" })

local dap = require("dap")
local dapui = require("dapui")

require("dap-go").setup()

dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes",      size = 0.35 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks",      size = 0.25 },
        { id = "watches",     size = 0.15 },
      },
      position = "left",
      size = 40,
    },
    {
      elements = {
        { id = "repl",    size = 0.6 },
        { id = "console", size = 0.4 },
      },
      position = "bottom",
      size = 12,
    },
  },
})

require("nvim-dap-virtual-text").setup()

-- Open/close dapui alongside the debug session lifecycle.
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

-- Signs reuse the diagnostic highlight groups already defined for the gutter.
vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DapLogPoint",            { text = "◆", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DiagnosticSignHint" })

local map = vim.keymap.set

map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function()
  vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
    if cond and cond ~= "" then dap.set_breakpoint(cond) end
  end)
end, { desc = "Conditional breakpoint" })

map("n", "<leader>dc", dap.continue,   { desc = "Continue / start" })
map("n", "<leader>di", dap.step_into,  { desc = "Step into" })
map("n", "<leader>do", dap.step_over,  { desc = "Step over" })
map("n", "<leader>dO", dap.step_out,   { desc = "Step out" })
map("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
map("n", "<leader>du", dapui.toggle,   { desc = "Toggle debug UI" })
map("n", "<leader>dl", dap.run_last,   { desc = "Run last" })
map("n", "<leader>dx", dap.terminate,  { desc = "Terminate" })

map("n", "<leader>dgt", function() require("dap-go").debug_test() end,      { desc = "Debug nearest test" })
map("n", "<leader>dgl", function() require("dap-go").debug_last_test() end, { desc = "Debug last test" })

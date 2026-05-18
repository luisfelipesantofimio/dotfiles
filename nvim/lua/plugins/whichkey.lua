local wk = require("which-key")

wk.setup({
  preset = "modern",
  delay = 300,
  icons = { mappings = false },
})

wk.add({
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code" },
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>gh", group = "hunk" },
  { "<leader>l", group = "lsp" },
  { "<leader>lw", group = "workspace folders" },
  { "<leader>lc", group = "call hierarchy" },
  { "<leader>t", group = "terminal" },
  { "<leader>x", group = "diagnostics" },
  { "<leader>F", group = "flutter" },
  { "<leader>S", group = "session" },
})

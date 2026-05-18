return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
      procMacro = { enable = true },
      inlayHints = {
        bindingModeHints       = { enable = true },
        chainingHints          = { enable = true },
        closingBraceHints      = { enable = true, minLines = 25 },
        parameterHints         = { enable = true },
        typeHints              = { enable = true },
        lifetimeElisionHints   = { enable = "never" },
      },
    },
  },
}

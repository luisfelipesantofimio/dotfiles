return {
  cmd = { "zls" },
  filetypes = { "zig", "zon" },
  root_markers = { "build.zig", "zls.json", ".git" },
  settings = {
    zls = {
      enable_autofix = false,
      enable_inlay_hints = true,
      enable_snippets = true,
      enable_argument_placeholders = true,
      warn_style = true,
    },
  },
}

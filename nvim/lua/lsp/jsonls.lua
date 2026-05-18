return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { ".git", "package.json" },
  init_options = { provideFormatter = true },
  settings = {
    json = {
      validate = { enable = true },
      schemas = {
        { fileMatch = { "package.json" },              url = "https://json.schemastore.org/package.json" },
        { fileMatch = { "tsconfig*.json" },            url = "https://json.schemastore.org/tsconfig.json" },
        { fileMatch = { ".eslintrc", ".eslintrc.json" }, url = "https://json.schemastore.org/eslintrc.json" },
        { fileMatch = { ".prettierrc", ".prettierrc.json" }, url = "https://json.schemastore.org/prettierrc.json" },
        { fileMatch = { "*.code-workspace" },          url = "https://json.schemastore.org/codeworkspace.json" },
      },
    },
  },
}

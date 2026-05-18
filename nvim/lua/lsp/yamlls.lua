return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
  root_markers = { ".git" },
  settings = {
    yaml = {
      hover = true,
      completion = true,
      validate = true,
      schemaStore = {
        enable = true,
      },
      schemas = {
        { fileMatch = { "*.yml", "*.yaml" }, url = "https://json.schemastore.org/github-workflow.json" },
        { fileMatch = { ".github/workflows/*.{yml,yaml}" }, url = "https://json.schemastore.org/github-workflow.json" },
        { fileMatch = { "helm/**/values.yaml", "values.yaml" }, url = "https://json.schemastore.org/helm.json" },
      },
    },
  },
}

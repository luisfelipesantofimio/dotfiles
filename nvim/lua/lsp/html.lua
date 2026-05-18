return {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_markers = { ".git", "package.json", "index.html" },
  settings = {
    html = {
      format = { enable = true }
    }
  }
}

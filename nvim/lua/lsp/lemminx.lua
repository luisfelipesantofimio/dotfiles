return {
  cmd = { "lemminx" },
  filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
  root_markers = { ".git" },
  settings = {
    xml = {
      format = { enabled = true, splitAttributes = false },
      validation = { enabled = true },
    },
  },
}

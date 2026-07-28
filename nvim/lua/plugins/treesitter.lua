local ok, ts = pcall(require, "nvim-treesitter")
if not ok then return end

local ensure = { "go", "gomod", "gowork", "gotmpl", "templ" }

ts.install(ensure)

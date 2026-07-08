local ok, ts = pcall(require, "nvim-treesitter")
if not ok then return end

local ensure = { "go", "gomod", "gowork", "gotmpl" }

ts.install(ensure)

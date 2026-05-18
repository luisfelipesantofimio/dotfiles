local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.background = "dark"

opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

opt.splitbelow = true
opt.splitright = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.undofile = true
opt.swapfile = false
opt.backup = false

opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.completeopt = { "menu", "menuone", "noselect", "fuzzy" }
opt.pumheight = 12

opt.timeoutlen = 400
opt.updatetime = 250

opt.wrap = false
opt.linebreak = true

opt.list = true
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " " }

opt.diffopt:append({ "linematch:60" })

-- Session contents — drop "blank" and "terminal" (noisy on restore).
opt.sessionoptions = { "buffers", "curdir", "folds", "help", "tabpages", "winsize", "globals", "skiprtp" }

-- Treesitter folds — start fully unfolded so foldexpr doesn't bite on open.
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99

if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

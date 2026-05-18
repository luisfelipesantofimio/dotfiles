require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return math.floor(vim.o.columns * 0.4)
    end
  end,
  open_mapping = [[<c-\>]],
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  persist_mode = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "rounded",
    winblend = 0,
  },
})

local Terminal = require("toggleterm.terminal").Terminal

-- One persistent terminal per direction so toggling preserves state.
local floating   = Terminal:new({ direction = "float",      hidden = true })
local horizontal = Terminal:new({ direction = "horizontal", hidden = true })
local vertical   = Terminal:new({ direction = "vertical",   hidden = true })
-- Lazygit-style scratch terminal — handy if the user has lazygit installed.
local lazygit    = Terminal:new({
  cmd = "lazygit",
  direction = "float",
  hidden = true,
  float_opts = { border = "rounded" },
})

local map = vim.keymap.set
map("n", "<leader>tf", function() floating:toggle()   end, { desc = "Float terminal" })
map("n", "<leader>th", function() horizontal:toggle() end, { desc = "Horizontal terminal" })
map("n", "<leader>tv", function() vertical:toggle()   end, { desc = "Vertical terminal" })
map("n", "<leader>tg", function() lazygit:toggle()    end, { desc = "Lazygit (if installed)" })
map("n", "<leader>tt", "<cmd>ToggleTerm<cr>",              { desc = "Toggle last terminal" })

-- Better terminal-mode escapes and window navigation.
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk",    [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  end,
})

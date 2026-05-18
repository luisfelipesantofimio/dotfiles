local map = vim.keymap.set

-- Save / quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all" })

-- Better escape
map("i", "jk", "<Esc>", { desc = "Escape" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

-- Split the current window. `/` overrides Vim's forward search — use telescope
-- (<leader>fg / <leader>fl) for searching, `?` still does reverse search.
map("n", "/", "<cmd>split<cr>",  { desc = "Split horizontally" })
map("n", "|", "<cmd>vsplit<cr>", { desc = "Split vertically" })

-- Window resize (window navigation is via Vim's native <C-w>h/j/k/l)
map("n", "<C-Up>",    "<cmd>resize +2<cr>")
map("n", "<C-Down>",  "<cmd>resize -2<cr>")
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>")

-- Buffer navigation: h/k = previous, l/j = next.
map("n", "<C-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<C-k>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<C-l>", "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<C-j>", "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Next buffer" })

-- <C-q> closes the current buffer without killing the window
-- (uses mini.bufremove so the split is preserved and replaced with the next buffer).
map("n", "<C-q>", function() require("mini.bufremove").delete(0, false) end, { desc = "Close buffer" })

map("n", "<leader>bd", function() require("mini.bufremove").delete(0, false) end, { desc = "Delete buffer" })
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>bp", "<cmd>buffer #<cr>", { desc = "Previous (alternate) buffer" })

-- Close other buffers (keep current). Modified buffers are skipped — save first.
map("n", "<leader>bc", function()
  local current = vim.api.nvim_get_current_buf()
  local closed, skipped = 0, 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted then
      if vim.bo[buf].modified then
        skipped = skipped + 1
      elseif pcall(require("mini.bufremove").delete, buf, false) then
        closed = closed + 1
      end
    end
  end
  vim.notify(("Closed %d buffer(s)%s"):format(closed,
    skipped > 0 and (", skipped %d modified"):format(skipped) or ""))
end, { desc = "Close other buffers" })

-- Close all buffers (current included). Modified buffers are skipped.
map("n", "<leader>bC", function()
  local closed, skipped = 0, 0
  local bufs = vim.tbl_filter(function(b) return vim.bo[b].buflisted end, vim.api.nvim_list_bufs())
  for _, buf in ipairs(bufs) do
    if vim.bo[buf].modified then
      skipped = skipped + 1
    elseif pcall(require("mini.bufremove").delete, buf, false) then
      closed = closed + 1
    end
  end
  vim.notify(("Closed %d buffer(s)%s"):format(closed,
    skipped > 0 and (", skipped %d modified"):format(skipped) or ""))
end, { desc = "Close all buffers" })

-- Move lines (visual)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up" })

-- Better indent in visual
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Keep cursor centered
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Diagnostics (0.11+ jump API)
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>xq", vim.diagnostic.setloclist, { desc = "Diagnostics loclist" })

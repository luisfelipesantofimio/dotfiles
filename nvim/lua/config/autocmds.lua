local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank (vim.hl is the 0.11+ home of on_yank)
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    (vim.hl or vim.highlight).on_yank({ timeout = 200 })
  end,
})

-- Equalize splits when the host window resizes
autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  command = "tabdo wincmd =",
})

-- Restore last cursor position
autocmd("BufReadPost", {
  group = augroup("last_loc", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit", "gitrebase" }
    if vim.tbl_contains(exclude, vim.bo[event.buf].filetype) then return end
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-create parent directories on save
autocmd("BufWritePre", {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then return end
    local file = (vim.uv or vim.loop).fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Native treesitter — start the highlighter and switch to treesitter folds
-- on every FileType, but only when a parser is actually available.
-- Neovim 0.12 ships parsers + queries for: c, lua, vim, vimdoc, query,
-- markdown, markdown_inline. For other languages, drop a parser into
-- ~/.config/nvim/parser/<lang>.so and queries into ~/.config/nvim/queries/<lang>/.
autocmd("FileType", {
  group = augroup("treesitter_native", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
    if not lang or not pcall(vim.treesitter.language.add, lang) then return end
    pcall(vim.treesitter.start, ev.buf, lang)
    vim.api.nvim_set_option_value("foldmethod", "expr", { scope = "local", win = 0 })
    vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { scope = "local", win = 0 })
  end,
})

-- Close some scratch filetypes with q
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {
    "help", "man", "qf", "lspinfo", "checkhealth", "notify",
    "startuptime", "tsplayground", "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
